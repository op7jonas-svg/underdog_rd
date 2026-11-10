#!/usr/bin/env bash
# Publica la función «leer-factura» y guarda la llave de Google en Supabase.
#
# Uso (las dos variables son obligatorias):
#   SUPABASE_ACCESS_TOKEN=sbp_... GEMINI_API_KEY=... ./supabase/deploy.sh
#
# La llave de Google NO se guarda en el repo: queda en los secretos del proyecto.
set -euo pipefail

REF="${SUPABASE_PROJECT_REF:-kxkfoqnwtflsugqbbzwv}"
: "${SUPABASE_ACCESS_TOKEN:?Falta SUPABASE_ACCESS_TOKEN (Account → Access Tokens en supabase.com)}"
: "${GEMINI_API_KEY:?Falta GEMINI_API_KEY (aistudio.google.com → Get API key)}"

DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$DIR/functions/leer-factura/index.ts"
API="https://api.supabase.com/v1/projects/$REF"

echo "1) Guardando la llave de Google en Supabase…"
curl -sS -X POST "$API/secrets" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "[{\"name\":\"GEMINI_API_KEY\",\"value\":\"$GEMINI_API_KEY\"}]" \
  -w '\n   HTTP %{http_code}\n'

echo "2) Publicando la función…"
RESP="$(curl -sS -X POST "$API/functions/deploy?slug=leer-factura" \
  -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -F 'metadata={"entrypoint_path":"index.ts","name":"leer-factura","verify_jwt":true}' \
  -F "file=@$SRC" \
  -w '\n%{http_code}')"
CODE="$(printf '%s' "$RESP" | tail -n1)"
BODY="$(printf '%s' "$RESP" | sed '$d')"
echo "   HTTP $CODE"
printf '%s\n' "$BODY" | head -c 600; echo

if [ "$CODE" != "200" ] && [ "$CODE" != "201" ]; then
  echo "3) El endpoint nuevo no la aceptó; probando el de creación clásica…"
  curl -sS -X POST "$API/functions?slug=leer-factura&name=leer-factura&verify_jwt=true&entrypoint_path=index.ts" \
    -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
    -H "Content-Type: text/plain" \
    --data-binary "@$SRC" \
    -w '\n   HTTP %{http_code}\n'
fi

echo "4) Funciones del proyecto:"
curl -sS "$API/functions" -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print('\n'.join('   - %s (%s) verify_jwt=%s' % (f.get('slug'), f.get('status'), f.get('verify_jwt')) for f in d))" 2>/dev/null || true

echo
echo "Listo. URL: https://$REF.supabase.co/functions/v1/leer-factura"
