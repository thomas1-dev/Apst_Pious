Image optimization and mapping — README

What I added
- `images-mapping.json` — JSON mapping of original filename -> new SEO-friendly filename.
- `optimize-images.ps1` — PowerShell script that uses ImageMagick (if installed) to create compressed `-opt.jpg` copies and `.webp` versions.
- `revert-image-names.ps1` — PowerShell script that reverts renamed files using `images-mapping.json`.

How to run (Windows PowerShell)

1) Quick check for ImageMagick

```powershell
Get-Command magick -ErrorAction SilentlyContinue
```

2) To generate compressed JPG and WebP versions (requires ImageMagick)

```powershell
# from repository root
powershell -ExecutionPolicy Bypass -File .\optimize-images.ps1
```

3) To revert renamed images back to original names

```powershell
powershell -ExecutionPolicy Bypass -File .\revert-image-names.ps1
```

Notes & alternatives
- If ImageMagick is not installed, the optimization script will exit with a message and not change files.
- You can install ImageMagick for Windows from: https://imagemagick.org
- Alternative: use Node.js + `sharp` or Python + `Pillow`/`img2webp` if you prefer; I can add a `package.json` + Node script or Python script if you'd like.

Next steps I can take for you
- Run the optimization automatically if you want and ImageMagick is available on your machine.
- Add a Node.js `sharp` script so optimizations work cross-platform without requiring ImageMagick.
- Replace `-opt.jpg` files in your HTML with the optimized versions (if you want optimized files served by default).
