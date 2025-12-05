<#
Revert image renames using `images-mapping.json`.
This will rename `newName` back to `oldName` where possible.
Run from repo root with PowerShell:
  powershell -ExecutionPolicy Bypass -File revert-image-names.ps1
#>

$mappingFile = Join-Path $PSScriptRoot 'images-mapping.json'
$imagesDir = Join-Path $PSScriptRoot 'Images'

if (-not (Test-Path $mappingFile)) { Write-Error "Mapping file not found: $mappingFile"; exit 1 }
if (-not (Test-Path $imagesDir)) { Write-Error "Images directory not found: $imagesDir"; exit 1 }

$map = Get-Content $mappingFile | ConvertFrom-Json

# Reverse mapping: newName -> oldName
$reverse = @{}
foreach ($k in $map.PSObject.Properties.Name) {
    $old = $k
    $new = $map.$k
    $reverse[$new] = $old
}

foreach ($newName in $reverse.Keys) {
    $oldName = $reverse[$newName]
    $newPath = Join-Path $imagesDir $newName
    $oldPath = Join-Path $imagesDir $oldName
    if (Test-Path $newPath) {
        try {
            Rename-Item -Path $newPath -NewName $oldName -Force
            Write-Host "Reverted: $newName -> $oldName"
        } catch {
            Write-Warning "Failed to revert $newName: $_"
        }
    } else {
        Write-Host "Skipped (not found): $newName"
    }
}

Write-Host "Revert script completed." -ForegroundColor Green
