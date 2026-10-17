# Notas para Claude

El usuario no sabe programar: explicar todo en español y de forma sencilla.

## Página de Surteme (`surteme/`)
- Dirección fija: https://op7jonas-svg.github.io/underdog_rd/surteme/
- **Al terminar cualquier cambio, enviar siempre el enlace para entrar**, con la versión al final para que el teléfono cargue lo nuevo:
  `https://op7jonas-svg.github.io/underdog_rd/surteme/?v=<versión>` (la misma versión de `surteme/version.txt`).
- Publicar en `main` **y** en `gh-pages` (el sitio se publica desde `gh-pages`): `git push origin main` y `git push origin main:gh-pages`.
- En cada cambio, subir la versión: `APP_VERSION` en `surteme/index.html` y el contenido de `surteme/version.txt` deben ser iguales (así los teléfonos se actualizan solos).
- Si se crea una tabla nueva en Supabase, la página muestra el texto SQL para que el usuario lo pegue en **SQL Editor**; añadirlo también a `surteme/setup.sql`.

## Base de datos (Supabase)
- El usuario conectó el conector de **Supabase** en claude.ai: crear/revisar tablas directamente con las herramientas `mcp__Supabase__*` (proyecto `kxkfoqnwtflsugqbbzwv`) en vez de pedirle que pegue SQL.
- Revisar primero con `list_tables`. Crear con `apply_migration` y **sin** sentencias `drop ...` (piden una confirmación que no llega y la llamada se queda esperando); usar `create ... if not exists`.
- Cada tabla nueva: RLS activado, política `for all to authenticated using (true) with check (true)` y `grant select, insert, update, delete ... to authenticated`. Guardar el SQL también en `surteme/setup.sql`.
