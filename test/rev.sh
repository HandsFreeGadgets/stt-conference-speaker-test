#!/bin/bash

function request {
  
RESP=$(curl -s -X POST "https://api.rev.ai/speechtotext/v1/jobs" -H "Authorization: Bearer $REV_KEY" -H "Content-Type: multipart/form-data" -F "media=@$1;type=audio/wav" -F "options={\"language\":\"de\"}")
ID=$(echo -n "$RESP" | grep -o '"id":"[^"]*' | grep -o '[^"]*$')
STATUS="in_progress"
while [ "$STATUS" = "in_progress" ]; do
  sleep 5
  RESP=$(curl -s -X GET "https://api.rev.ai/speechtotext/v1/jobs/${ID}/transcript" -H "Authorization: Bearer $REV_KEY" -H "Accept: text/plain")
  STATUS=$(echo -n "$RESP" | grep -o '"current_value":"[^"]*' | grep -o '[^"]*$')
done
TEXT=$(echo "$RESP" | cut -c 26-)
wer "$2" "$TEXT"
}

source iterate.sh
iterate request