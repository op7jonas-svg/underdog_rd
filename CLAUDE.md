# Notas para Claude

El usuario no sabe programar: explicar todo en español y de forma sencilla.

## Página de Surteme (`surteme/`)
- Dirección fija: https://op7jonas-svg.github.io/underdog_rd/surteme/
- **Al terminar cualquier cambio, enviar siempre el enlace para entrar**, con la versión al final para que el teléfono cargue lo nuevo:
  `https://op7jonas-svg.github.io/underdog_rd/surteme/?v=<versión>` (la misma versión de `surteme/version.txt`).
- Publicar en `main` **y** en `gh-pages` (el sitio se publica desde `gh-pages`): `git push origin main` y `git push origin main:gh-pages`.
- En cada cambio, subir la versión: `APP_VERSION` en `surteme/index.html` y el contenido de `surteme/version.txt` deben ser iguales (así los teléfonos se actualizan solos).
- Si se crea una tabla nueva en Supabase, la página muestra el texto SQL para que el usuario lo pegue en **SQL Editor**; añadirlo también a `surteme/setup.sql`.
