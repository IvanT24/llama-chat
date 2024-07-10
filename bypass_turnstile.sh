#!/bin/bash

# Define the file paths relative to the root directory
ROUTE_FILE="app/api/route.js"
CHAT_FORM_FILE="app/components/ChatForm.js"
PAGE_FILE="app/page.js"

# Backup the original files
cp $ROUTE_FILE "${ROUTE_FILE}.bak"
cp $CHAT_FORM_FILE "${CHAT_FORM_FILE}.bak"
cp $PAGE_FILE "${PAGE_FILE}.bak"

# Modify the verifyTurnstile function to always return true
sed -i 's|async function verifyTurnstile(token) {.*|async function verifyTurnstile(token) {\n  // Bypass CAPTCHA verification and always return true\n  return true;\n}|' $ROUTE_FILE

# Ensure frontend submits a dummy token in ChatForm.js
sed -i 's|const token = turnstileRef?.current?.getResponse();|const token = "dummy-token"; // Use a dummy token since it is not being verified|' $CHAT_FORM_FILE

# Ensure frontend submits a dummy token in page.js
sed -i 's|const token = turnstileRef?.current?.getResponse();|const token = "dummy-token"; // Use a dummy token since it is not being verified|' $PAGE_FILE

# Modify the siteKey check to prevent warnings and bypass
sed -i 's|if (!siteKey) {|if (false) {|' $PAGE_FILE

echo "Changes applied successfully. Original files have been backed up with .bak extension."

