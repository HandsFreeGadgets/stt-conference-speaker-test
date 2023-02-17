#!/bin/bash

function request {
  RESP=$(whisper --model small --language de "$1" 2>/dev/null)
  TEXT=$(echo -n "$RESP" | cut -c 28-)
  wer "$2" "$TEXT"
}
source iterate.sh
iterate request
