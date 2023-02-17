#!/bin/bash

function request {
  RESP=$(stt --model model.tflite --scorer kenlm.scorer --audio "$1" 2>/dev/null)
  TEXT=$(echo "$RESP" | tail -n1)
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request
