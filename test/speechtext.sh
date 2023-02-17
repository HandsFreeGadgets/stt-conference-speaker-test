#!/bin/bash

function request {
RESP=$(curl -s -H "Content-Type:application/octet-stream" --data-binary @"$1" "https://api.speechtext.ai/recognize?key=${SPEECHTEXT_KEY}&language=de-DE&format=wav")
ID=$(echo -n "$RESP" | grep -o '"id": "[^"]*' | grep -o '[^"]*$')
STATUS="processing"
while [ "$STATUS" = "processing" ]; do
  RESP=$(curl -s -X GET "https://api.speechtext.ai/results?key=${SPEECHTEXT_KEY}&task=${ID}&summary=true&summary_size=15")
  STATUS=$(echo -n "$RESP" | grep -o '"status": "[^"]*' | grep -o '[^"]*$')    
done
TEXT=$(echo -n "$RESP" | grep -o '"transcript": "[^"]*' | grep -o '[^"]*$')
wer "$2" "$TEXT"
}

source iterate.sh
iterate request