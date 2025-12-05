<#
PowerShell image optimization script.
- If ImageMagick (`magick`) is available it will create compressed JPEG/PNG copies and WebP versions.
- Run from repository root: `.
ormalize\optimize-images.ps1` or `powershell -ExecutionPolicy Bypass -File optimize-images.ps1`

This script is safe — it writes new files next to originals with suffixes `-opt.jpg` and `.webp`.
#>

$imagesDir = Join-Path $PSScriptRoot 'Images'
if (-not (Test-Path $imagesDir)) {
    Write-Error "Images directory not found: $imagesDir"
    exit 1
}

# Check for ImageMagick
$magick = Get-Command magick -ErrorAction SilentlyContinue
if (-not $magick) {
    Write-Host "ImageMagick 'magick' not found. This script requires ImageMagick for conversion." -ForegroundColor Yellow
    Write-Host "Install ImageMagick (https://imagemagick.org) and ensure 'magick' is on PATH, or use the provided README for alternatives."
    exit 0
}

# Process images
$files = Get-ChildItem -Path $imagesDir -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png)$' }
if ($files.Count -eq 0) {
    Write-Host "No JPG/PNG files found to optimize." -ForegroundColor Yellow
    exit 0
}

foreach ($f in $files) {
    $src = $f.FullName
    $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $optJpg = Join-Path $imagesDir ("$base-opt.jpg")
    $webp = Join-Path $imagesDir ("$base.webp")

    try {
        Write-Host "Optimizing: $($f.Name) -> $([System.IO.Path]::GetFileName($optJpg)), $([System.IO.Path]::GetFileName($webp))"
        # Create compressed JPEG (quality 75) and WebP
        magick convert "$src" -strip -interlace Plane -quality 75 "$optJpg"
        magick convert "$src" -strip -quality 75 "$webp"
    } catch {
        Write-Warning "Failed to optimize $($f.Name): $_"
    }
}

Write-Host "Optimization complete. Compressed files saved with '-opt.jpg' suffix and WebP versions alongside originals." -ForegroundColor Green
