#!/bin/bash

# Define file paths
ENV_FILE=".env.example"
ROUTE_FILE="app/api/route.js"
CHAT_FORM_FILE="app/components/ChatForm.js"
PAGE_FILE="app/page.js"
PACKAGE_JSON_FILE="package.json"

# Backup original files
cp $ENV_FILE "${ENV_FILE}.bak"
cp $ROUTE_FILE "${ROUTE_FILE}.bak"
cp $CHAT_FORM_FILE "${CHAT_FORM_FILE}.bak"
cp $PAGE_FILE "${PAGE_FILE}.bak"
cp $PACKAGE_JSON_FILE "${PACKAGE_JSON_FILE}.bak"

# Remove Turnstile-related environment variables from .env.example
sed -i '/NEXT_PUBLIC_TURNSTILE_SITE_KEY/d' $ENV_FILE
sed -i '/TURNSTILE_SECRET_KEY/d' $ENV_FILE
sed -i '/TURNSTILE_CHALLENGE_ENDPOINT/d' $ENV_FILE

# Remove Turnstile-related code from app/api/route.js
sed -i '/const { TURNSTILE_CHALLENGE_ENDPOINT, TURNSTILE_SECRET_KEY } = process.env;/d' $ROUTE_FILE
sed -i '/async function verifyTurnstile/,/return data.success;/d' $ROUTE_FILE
sed -i '/if (!await verifyTurnstile(token)) {/,/return new Response/d' $ROUTE_FILE

# Remove Turnstile-related code from app/components/ChatForm.js
sed -i '/import { Turnstile } from/d' $CHAT_FORM_FILE
sed -i '/const TURNSTILE_SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY;/d' $CHAT_FORM_FILE
sed -i '/<Turnstile/,/\/>/d' $CHAT_FORM_FILE

# Remove Turnstile-related code from app/page.js
sed -i '/import { Turnstile } from/d' $PAGE_FILE
sed -i '/const TURNSTILE_SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY;/d' $PAGE_FILE
sed -i '/const \[didPassChallenge, setDidPassChallenge\] = useState(false);/d' $PAGE_FILE
sed -i '/const \[turnstileStatus, setTurnstileStatus\] = useState("pending");/d' $PAGE_FILE
sed -i '/const turnstileRef = useRef(null);/d' $PAGE_FILE
sed -i '/const handleTurnstileSuccess = /,/};/d' $PAGE_FILE
sed -i '/const handleTurnstileError = /,/};/d' $PAGE_FILE
sed -i '/const handleTurnstileExpire = /,/};/d' $PAGE_FILE
sed -i '/const retryTurnstile = /,/};/d' $PAGE_FILE
sed -i '/token: turnstileRef?.current?.getResponse(),/d' $PAGE_FILE
sed -i '/{turnstileStatus === "failed" &&/,/<\/dialog>/d' $PAGE_FILE
sed -i '/!didPassChallenge ? (/,{/EmptyState/d' $PAGE_FILE
sed -i '/<Turnstile/,/\/>/d' $PAGE_FILE

# Remove the Turnstile package from package.json
sed -i '/"@marsidev\/react-turnstile": "/d' $PACKAGE_JSON_FILE

echo "Changes applied successfully. Original files have been backed up with .bak extension."

