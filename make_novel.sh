#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $0 ebook_dir target_name"
  echo "Ex: $0 /opt/ebook/farmer/001 farmer-001"
  exit 1
fi

ebook_dir=$1
target_name=$2
mp3_name=$ebook_dir/$target_name.mp3
srt_name=$ebook_dir/$target_name.srt
uv run edge-tts --rate +50% --volume +200% --voice zh-CN-YunxiNeural --file $ebook_dir/$target_name.txt --write-media $mp3_name --write-subtitles $srt_name
