#!/bin/bash

GOOGLE_REQ_FILE=google-request.json

function request {
  BASE64=$(base64 "$1")
  cat <<EOF > $GOOGLE_REQ_FILE
  {
    "config": {
        "encoding":"LINEAR16",
        "languageCode": "de-DE",
        "enableWordTimeOffsets": false
    },
    "audio": {
        "content": "${BASE64}"
    }
  }
EOF
  
  RESP=$(curl -s -H "Content-Type: application/json" \
      -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
      https://speech.googleapis.com/v1/speech:recognize \
      -d @${GOOGLE_REQ_FILE})
  TEXT=$(echo -n "$RESP" | grep -o '"transcript": "[^"]*' | grep -o '[^"]*$')
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request
rm $GOOGLE_REQ_FILE
