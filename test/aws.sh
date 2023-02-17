#!/bin/bash

function request {
  TEXT=$(python3 aws.py "$1")
  wer "$2" "$TEXT"
}

source iterate.sh
iterate request