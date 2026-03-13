# 建置環境
- Python 3.12
- uv
- Ui.Vision for Chrome
- FFmpeg

# uv
```bash
uv init
uv python pin 3.12
uv venv

# CPU Version of PaddlePaddle
uv pip install paddlepaddle==3.2.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
uv add paddleocr==3.3.3

uv add edge-tts
uv run edge-tts --list-voices | grep zh-CN

uv add Pillow
```

# FFmpeg
```bash
sudo apt update
sudo apt install ffmpeg
```

# Ui.Vision
- **Install the Ui.Vision RPA extension from the Chrome Web Store** to automate browser tasks.
- For advanced features like desktop automation (mouse/keyboard simulation), download and install the **Ui.Vision XModules** for Windows, Mac, or Linux
- Import macro **pcreader.json**