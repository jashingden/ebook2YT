#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Usage: $0 ebook_dir target_name cover_img"
  echo "Ex: $0 /opt/ebook/farmer/001 farmer-001 001-cover.png"
  exit 1
fi

ebook_dir=$1
target_name=$2
cover_img=$3
mp3_name=$ebook_dir/$target_name.mp3
srt_name=$ebook_dir/$target_name.srt
mp4_name=$ebook_dir/$target_name.mp4
uv run edge-tts --rate +50% --voice zh-CN-YunxiNeural --file $ebook_dir/$target_name.txt --write-media $mp3_name --write-subtitles $srt_name
ffmpeg -loop 1 -i $ebook_dir/$cover_img -i $mp3_name -filter_complex "scale=426:240:force_original_aspect_ratio=decrease,pad=426:240:(ow-iw)/2:(oh-ih)/2,subtitles=${srt_name}:force_style='FontSize=24,Alignment=2'" -c:v libx264 -tune stillimage -c:a aac -b:a 128k -pix_fmt yuv420p -shortest $mp4_name
