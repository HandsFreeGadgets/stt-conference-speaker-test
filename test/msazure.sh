#!/bin/bash

function request {
  RESP=$(spx recognize --file "$1" --language de-DE --once+ 2>/dev/null)
  TEXT=$(echo -n "$RESP" | grep -o 'RECOGNIZED: .*' | cut -c 13-)
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request
