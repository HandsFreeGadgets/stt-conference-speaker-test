#!/bin/bash

function request {
  TEXT=$(python3 assembly.py "$1")
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request