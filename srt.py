from faster_whisper import WhisperModel
from dotenv import load_dotenv
import os
import sys

load_dotenv()
yt_wav = os.getenv("YT_WAV")
yt_srt = os.getenv("YT_SRT")

if len(sys.argv) >= 3:
    yt_wav = sys.argv[1]
    yt_srt = sys.argv[2]

model = WhisperModel(
    "large-v3",
    device="cpu",
    compute_type="float32"
)

segments, info = model.transcribe(yt_wav, language="zh")

with open(yt_srt, "w", encoding="utf-8") as f:

    def format_time(seconds):
        h = int(seconds // 3600)
        m = int((seconds % 3600) // 60)
        s = int(seconds %60)
        ms = int((seconds - int(seconds)) * 1000)
        return f"{h:02}:{m:02}:{s:02},{ms:03}"
    
    for i, seg in enumerate(segments, start=1):
        f.write(f"{i}\n")
        f.write(f"{format_time(seg.start)} --> {format_time(seg.end)}\n")
        f.write(seg.text.strip() + "\n\n")

