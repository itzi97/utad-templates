# ============================================================
#  Install the template fonts (Windows PowerShell)
#
#  Downloads Poppins (headings) and Carlito (body) from the Google Fonts
#  repository and installs them for the CURRENT USER (no admin needed):
#  the .ttf files go into %LOCALAPPDATA%\Microsoft\Windows\Fonts and are
#  registered under HKCU so applications pick them up. Both are free (OFL).
#
#  Usage:  .\scripts\install-fonts.ps1
#  If blocked: Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# ============================================================
$ErrorActionPreference = "Stop"

$Base = "https://raw.githubusercontent.com/google/fonts/main/ofl"
$Fonts = @(
  @{ dir = "poppins"; files = @("Poppins-Regular","Poppins-Italic","Poppins-Medium","Poppins-MediumItalic","Poppins-SemiBold","Poppins-Bold","Poppins-BoldItalic") },
  @{ dir = "carlito"; files = @("Carlito-Regular","Carlito-Italic","Carlito-Bold","Carlito-BoldItalic") }
)

$FontDir = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
New-Item -ItemType Directory -Force -Path $FontDir | Out-Null
$RegKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

foreach ($fam in $Fonts) {
  Write-Host "Installing $($fam.dir)…"
  foreach ($f in $fam.files) {
    $url  = "$Base/$($fam.dir)/$f.ttf"
    $dest = Join-Path $FontDir "$f.ttf"
    try {
      Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
      # register the font for the current user
      New-ItemProperty -Path $RegKey -Name "$f (TrueType)" -Value $dest -PropertyType String -Force | Out-Null
      Write-Host "  $f.ttf"
    } catch {
      Write-Host "warning: could not download $url" -ForegroundColor Yellow
    }
  }
}
Write-Host "Done. You may need to restart your editor/TeX app to see the new fonts."
