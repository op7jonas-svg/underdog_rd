// Lee una factura de suplidor (foto o PDF) y devuelve los datos en JSON.
// La llave de Google vive en los secretos de Supabase (GEMINI_API_KEY): nunca se publica en la app.
//
// Desplegar:  supabase functions deploy leer-factura --project-ref kxkfoqnwtflsugqbbzwv
// Secreto:    supabase secrets set GEMINI_API_KEY=... --project-ref kxkfoqnwtflsugqbbzwv
// Modelo:     GEMINI_MODELO (opcional; por defecto gemini-2.5-flash)

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const responder = (cuerpo: unknown, estado = 200) =>
  new Response(JSON.stringify(cuerpo), {
    status: estado,
    headers: { ...CORS, "Content-Type": "application/json" },
  });

const PROMPT = `Eres un asistente que digitaliza facturas de suplidores de una empresa dominicana de desechables y suministros.
Devuelve SOLO los datos que aparecen en el documento. Nunca inventes ni completes con suposiciones.

Reglas:
- Montos: número sin separador de miles y con punto decimal (1,850.00 → 1850.00). Si el documento usa coma decimal, conviértela.
- Fecha: AAAA-MM-DD. Si no se ve el año, null.
- "proveedor" es quien EMITE la factura (el nombre y RNC de arriba), NO el cliente que aparece como "Cliente".
- RNC y NCF tal cual aparecen, con sus guiones.
- "numero" es el número de factura del suplidor (no el NCF).
- Cada renglón de la tabla de productos es un item. No juntes ni dividas renglones.
- "presentacion" es el texto de empaque tal cual (fardo, caja, paquete, unidad) y "unidades_por_presentacion" cuántas unidades trae esa presentación (ej. "Fardo (1,000 u)" → 1000). Si no lo dice, null.
- "precio_unitario" es el precio de UNA presentación (la columna Precio), no el importe del renglón.
- Si un renglón no tiene cantidad o precio legible, inclúyelo igual con null en lo que falte.
- "dudas": lista corta de campos que no se leen con seguridad (ej. "el NCF está borroso"). Si todo se lee bien, deja la lista vacía.`;

const SCHEMA = {
  type: "OBJECT",
  properties: {
    proveedor: { type: "STRING", nullable: true, description: "Nombre de quien emite la factura" },
    rnc: { type: "STRING", nullable: true },
    ncf: { type: "STRING", nullable: true },
    numero: { type: "STRING", nullable: true, description: "Número de factura del suplidor" },
    fecha: { type: "STRING", nullable: true, description: "AAAA-MM-DD" },
    items: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          codigo: { type: "STRING", nullable: true },
          descripcion: { type: "STRING" },
          presentacion: { type: "STRING", nullable: true },
          unidades_por_presentacion: { type: "NUMBER", nullable: true },
          cantidad: { type: "NUMBER", nullable: true },
          precio_unitario: { type: "NUMBER", nullable: true },
          importe: { type: "NUMBER", nullable: true },
        },
        required: ["descripcion"],
        propertyOrdering: ["codigo", "descripcion", "presentacion", "unidades_por_presentacion", "cantidad", "precio_unitario", "importe"],
      },
    },
    subtotal: { type: "NUMBER", nullable: true },
    itbis: { type: "NUMBER", nullable: true },
    total: { type: "NUMBER", nullable: true },
    dudas: { type: "ARRAY", items: { type: "STRING" } },
  },
  required: ["proveedor", "fecha", "items", "total"],
  propertyOrdering: ["proveedor", "rnc", "ncf", "numero", "fecha", "items", "subtotal", "itbis", "total", "dudas"],
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return responder({ error: "Usa POST." }, 405);

  try {
    const cuerpo = await req.json().catch(() => ({}));
    const imagen = cuerpo?.imagen;
    const tipo = cuerpo?.tipo;
    if (!imagen || typeof imagen !== "string") {
      return responder({ error: "Falta la foto de la factura." }, 400);
    }
    if (imagen.length > 8_000_000) {
      return responder({ error: "La foto es muy grande. Tómala otra vez con menos resolución." }, 413);
    }
    const mime = /^image\/(jpeg|png|webp)$/i.test(tipo) || tipo === "application/pdf" ? tipo : "image/jpeg";

    const llave = Deno.env.get("GEMINI_API_KEY");
    if (!llave) {
      return responder({ error: "Falta configurar la llave de Google en Supabase (GEMINI_API_KEY)." }, 500);
    }
    // Modelos en orden: si uno no existe o está saturado, pasa al siguiente sin que el dueño lo note
    const modelos = (Deno.env.get("GEMINI_MODELO") || "gemini-3.5-flash,gemini-3.1-flash-lite,gemini-flash-latest")
      .split(",").map((m) => m.trim()).filter(Boolean);

    const pedido = (estricto: boolean) => ({
      contents: [{
        role: "user",
        parts: [{ text: PROMPT }, { inline_data: { mime_type: mime, data: imagen } }],
      }],
      generationConfig: {
        temperature: 0,
        responseMimeType: "application/json",
        ...(estricto ? { responseSchema: SCHEMA, thinkingConfig: { thinkingBudget: 0 } } : {}),
        maxOutputTokens: 8192,
      },
    });

    const llamar = (modelo: string, estricto: boolean) =>
      fetch(`https://generativelanguage.googleapis.com/v1beta/models/${modelo}:generateContent`, {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-goog-api-key": llave },
        body: JSON.stringify(pedido(estricto)),
      });

    let r: Response | null = null, usado = modelos[0];
    for (const modelo of modelos) {
      usado = modelo;
      for (let intento = 0; intento < 2; intento++) {
        r = await llamar(modelo, true);
        // Si el modelo no acepta el esquema o el «thinking», se reintenta sin ellos
        if (r.status === 400) r = await llamar(modelo, false);
        if (r.ok) break;
        if (r.status === 404 || r.status === 503 || r.status === 429) break;  // este modelo no sirve ahora: al siguiente
        if (r.status < 500) break;                                            // 4xx no se arregla reintentando
        await new Promise((ok) => setTimeout(ok, 700));
      }
      if (r && (r.ok || r.status === 429)) break;
    }

    if (!r || !r.ok) {
      const detalle = r ? (await r.text()).slice(0, 500) : "sin respuesta";
      console.error("Gemini", r?.status, detalle);
      if (r?.status === 429) {
        return responder({ error: "El lector está saturado (límite de Google). Espera un minuto y vuelve a intentar." }, 429);
      }
      if (r?.status === 403) {
        return responder({ error: "La llave de Google no tiene permiso para este modelo. Revisa la llave en Supabase." }, 502);
      }
      return responder({ error: "Google no pudo leer la factura. Intenta otra vez." }, 502);
    }

    const g = await r.json();
    const cand = g?.candidates?.[0];
    const texto = (cand?.content?.parts || []).map((p: { text?: string }) => p.text || "").join("");
    if (cand?.finishReason === "MAX_TOKENS") {
      return responder({ error: "La factura tiene demasiados renglones para leerla de una vez. Tómala en dos fotos." }, 422);
    }
    if (!texto) {
      return responder({ error: "No se pudo leer esa foto. Que se vea la hoja completa y con buena luz." }, 422);
    }

    let datos: unknown;
    try {
      datos = JSON.parse(texto);
    } catch {
      console.error("JSON inválido de Gemini:", texto.slice(0, 500));
      return responder({ error: "El lector devolvió algo que no entendí. Intenta otra vez." }, 502);
    }

    return responder({ ok: true, datos, modelo: usado });
  } catch (e) {
    console.error(e);
    return responder({ error: "Falló la lectura: " + (e instanceof Error ? e.message : String(e)) }, 500);
  }
});
