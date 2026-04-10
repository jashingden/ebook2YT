#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Usage: $0 ebook_dir target_name"
  echo "Ex: $0 /opt/ebook/farmer/001 farmer-001"
  exit 1
fi

ebook_dir=$1
target_name=$2
mp3_name=$ebook_dir/$target_name.mp3

for txt in "$ebook_dir"/txt/*.txt; do
  base="${txt%.txt}"
  mp3="${base}.mp3"

  if [ -f "$mp3" ]; then
    echo "Skip (mp3 exists): $mp3"
  else
    if [ "$3" = "female" ]; then
      # female voice
      echo "Processing(female): $txt"
      uv run edge-tts --rate +50% --volume +200% --voice zh-CN-XiaoxiaoNeural --file $txt --write-media $mp3
    else
      # male voice
      echo "Processing(male): $txt"
      uv run edge-tts --rate +50% --volume +200% --voice zh-CN-YunxiNeural --file $txt --write-media $mp3
    fi
  fi
done

(
  cd "$ebook_dir"/txt || exit
  ls *.mp3 | sed "s/^/file '/;s/$/'/" > list.txt
  ffmpeg -f concat -safe 0 -i list.txt -c copy "$mp3_name"
  echo "Merged to $mp3_name"
)
