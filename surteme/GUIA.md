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
