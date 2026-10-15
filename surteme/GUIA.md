# Surteme: cómo dejar la página lista (se hace una sola vez)

Página: https://op7jonas-svg.github.io/underdog_rd/surteme/

## 1. Crear la cuenta gratis
1. Entra a https://supabase.com y pulsa **Start your project**. Regístrate (puedes usar tu cuenta de GitHub o tu correo).
2. Pulsa **New project**.
   - **Name:** `surteme`
   - **Database Password:** inventa una contraseña y guárdala (casi nunca la vas a necesitar).
   - **Region:** `East US` (la más cerca de RD).
   - Plan: **Free**.
3. Pulsa **Create new project** y espera 1 o 2 minutos.

## 2. Preparar el archivador
1. En el menú de la izquierda entra a **SQL Editor**.
2. Abre el archivo `setup.sql` (está en esta misma carpeta), copia todo el texto, pégalo y pulsa **Run**.
3. Debe salir "Success". Si sale un aviso de confirmación, acéptalo.

## 3. Crear los usuarios (tú y tu esposa)
1. Menú izquierdo: **Authentication** → **Users** → **Add user** → **Create new user**.
2. Pon el correo y una contraseña. Marca **Auto Confirm User**. Pulsa **Create user**.
3. Repite para tu esposa.
4. Para que nadie más pueda registrarse: **Authentication** → **Sign In / Providers** → apaga **Allow new users to sign up** → **Save**.

## 4. Conectar la página
1. Pulsa el botón **Connect** (arriba) o ve a **Project Settings** → **API Keys**.
2. Copia estos dos datos:
   - **Project URL** (empieza con `https://` y termina en `.supabase.co`)
   - **Publishable key** (empieza con `sb_publishable_`) o, si no aparece, la **anon public key**
3. Pégalos en `config.js`, o mándaselos a Claude para que los ponga.
   Estos dos datos se pueden compartir sin problema. **Nunca** compartas la **secret key** ni la **service_role key**.

## Bueno saber
- Todo es gratis: unos 500 MB de datos y 1 GB de archivos (más o menos 1,000 a 2,000 facturas en PDF).
- Si nadie usa la página en 7 días, Supabase la pone "en pausa". No se pierde nada: entras a supabase.com y pulsas **Restore project**.
- En el teléfono puedes poner la página como si fuera una app: ábrela en el navegador → **Compartir** → **Agregar a pantalla de inicio**.

## Suplidores (comparar precios)
- Pestaña **Suplidores**. La primera vez te pedirá pegar un texto en **SQL Editor** (el mismo botón **Copiar texto** te lo da) y luego pulsar **Cargar precios de la plantilla**.
- Todo se compara con ITBIS y por unidad, igual que la plantilla de Excel.
- Toca un producto para ver todos los precios, editarlos o pasarlos a la calculadora.
- En **Mis suplidores** puedes indicar si cada suplidor cotiza con o sin ITBIS.

## Gastos y combustible
- Pestaña **Gastos**. La primera vez te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- **Mis gastos:** anota cada gasto (combustible, peajes, sueldos, alquiler, etc.) con foto del recibo. Ves el total del mes y la **ganancia real** (lo que ganaste en facturas menos los gastos).
- **Calcular combustible:** distancia, cuánto rinde el vehículo y precio del galón → cuánto cuesta el viaje y cuánto por entrega.
- Si en cada tanqueada anotas galones y kilometraje, la página calcula sola cuánto rinde tu vehículo.

## Abonos y cobros por WhatsApp
- La primera vez, en **Facturas** te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- Abre una factura → **+ Agregar abono**: cuánto pagó, fecha, cómo pagó y foto del comprobante. La factura queda **Pendiente**, **Abonada** (dice cuánto falta) o **Pagada** sola.
- **Recordar pago por WhatsApp** (en el cliente o en la factura): abre WhatsApp con el mensaje listo, solo con lo que falta. Tú pulsas **Enviar**.
- El cliente necesita tener su teléfono guardado.

## Cotizaciones y facturas con el diseño de Surteme
- La primera vez, en **Cotizaciones** te pedirá pegar un texto en **SQL Editor** (botón **Copiar texto**).
- **Datos de mi empresa:** teléfono, RNC, dirección, etc. Salen al pie de cada documento.
- **+ Nueva cotización:** eliges el cliente y agregas productos (de tu lista de precios o escritos a mano). El número (001-2026, 002-2026…) se pone solo.
- **Compartir imagen (WhatsApp)**, **PDF** o **Imprimir**.
- **Convertir en factura:** pasa la cotización a factura. La factura aparece también en **Facturas** para anotar abonos y cobrar por WhatsApp.
- En **Facturas → + Crear factura** puedes hacer una factura directa sin cotización.

## Para Claude (al publicar cambios)
- Cambiar `APP_VERSION` en `index.html` y el contenido de `version.txt` al mismo valor nuevo, para que los teléfonos se actualicen solos.
- Publicar en `main` y también en `gh-pages` (el sitio se publica desde `gh-pages`).
