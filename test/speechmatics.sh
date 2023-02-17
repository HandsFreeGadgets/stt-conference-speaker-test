#!/bin/bash

function request {
RESP=$(curl -s -L -X POST https://asr.api.speechmatics.com/v2/jobs/ -H "Authorization: Bearer $SPEECHMATICS_KEY" -F data_file=@"$1" -F config="{\"type\": \"transcription\", \"transcription_config\": { \"operating_point\":\"enhanced\", \"language\": \"de\" }}")
ID=$(echo -n "$RESP" | grep -o '"id":"[^"]*' | grep -o '[^"]*$')
STATUS="running"
while [ "$STATUS" = "running" ]; do
  sleep 5
  RESP=$(curl -s -L -X GET https://asr.api.speechmatics.com/v2/jobs/"${ID}" -H "Authorization: Bearer $SPEECHMATICS_KEY")
  STATUS=$(echo -n "$RESP" | grep -o '"status":"[^"]*' | grep -o '[^"]*$')
done
RESP=$(curl -s -L -X GET https://asr.api.speechmatics.com/v2/jobs/"${ID}"/transcript?format=txt -H "Authorization: Bearer $SPEECHMATICS_KEY")
TEXT="$RESP"
wer "$2" "$TEXT"
}

source iterate.sh
iterate request