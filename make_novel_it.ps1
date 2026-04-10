param (
    [string]$ebook_dir,
    [string]$target_name,
    [string]$voice_type  # optional: female / male
)

if (-not $ebook_dir -or -not $target_name) {
    Write-Host "Usage: make_novel_it.ps1 ebook_dir target_name"
    Write-Host "Ex: make_novel_it.ps1 C:\ebook\farmer\001 farmer-001"
    exit 1
}

$mp3_name = Join-Path $ebook_dir "$target_name.mp3"

Get-ChildItem -Path (Join-Path $ebook_dir "txt") -Filter *.txt | ForEach-Object {

    $txt = $_.FullName
    $mp3 = [System.IO.Path]::ChangeExtension($txt, "mp3")

    if (Test-Path $mp3) {
        Write-Host "Skip (mp3 exists): $mp3"
    } else {
        if ($voice_type -eq "female") {
            # female voice
            Write-Host "Processing(female): $txt"
            uv run edge-tts --rate +50% --volume +200% --voice zh-CN-XiaoxiaoNeural --file "$txt" --write-media "$mp3"
        } else {
            # male voice
            Write-Host "Processing(male): $txt"
            uv run edge-tts --rate +50% --volume +200% --voice zh-CN-YunxiNeural --file "$txt" --write-media "$mp3"
        }
    }
}