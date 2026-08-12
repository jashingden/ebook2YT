#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 target_name"
  echo "Ex: $0 PXL_20260723_053939053"
  exit 1
fi

target_name=$1
mp4_name=$target_name.mp4
wav_name=$target_name.wav
srt_name=$target_name.srt
ffmpeg -i $mp4_name -map a:0 -ac 2 $wav_name
echo "Processing: $wav_name"
uv run python srt.py $wav_name $srt_name
