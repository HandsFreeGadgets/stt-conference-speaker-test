#!/bin/bash

function request {
  RESP=$(curl -s -X POST -u "apikey:${IBM_API_KEY}" \
      -H "Content-Type: audio/wav" \
      --data-binary @"$1" \
      "${IBM_URL}""/v1/recognize?model=de-DE_Multimedia")
  TEXT=$(echo -n "$RESP" | grep -o '"transcript": "[^"]*' | grep -o '[^"]*$')
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request
