#!/bin/bash

function wer() {
echo -n "$1" "|" "$2" "| "
WER=$(python3 wer.py "$1" "$2")
echo "$WER" "|"    
}


function iterate() {
line=1
for file in samples/*.wav
do
  speaker=$(head -"$line" speaker.txt | tail -1 | tr -d '\n')
  echo -n "|" "$speaker" "| "
  input=$(head -"$line" utterances.txt | tail -1 | tr -d '\n')
  $1 "${file}" "$input"
  ((line=line+1))
done   
}
