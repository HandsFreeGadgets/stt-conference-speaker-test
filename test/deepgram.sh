#!/bin/bash

function request {
RESP=$(curl --no-progress-meter --request POST --url 'https://api.deepgram.com/v1/listen?language=de&numerals=true&model=general' --header "Authorization: Token $DEEPGRAM_KEY" --header 'content-type: audio/wav' --data-binary @"$1")
TEXT=$(echo -n "$RESP" | grep -o '"transcript":"[^"]*' | grep -o '[^"]*$' | xargs)
wer "$2" "$TEXT"
}

source iterate.sh
iterate request