# ============================================================
#  U-tad templates installer  (Windows PowerShell)
#
#  Usage:
#     .\install.ps1            # install both Typst and LaTeX
#     .\install.ps1 typst      # Typst only
#     .\install.ps1 latex      # LaTeX only
#     .\install.ps1 tfg        # the TFG class only (utad-tfg.cls)
#
#  Typst  -> local package:   #import "@local/utad:0.1.0": *
#  LaTeX  -> user texmf tree:  \usepackage{utad}  (xelatex / lualatex)
#
#  If script execution is blocked, run once in this shell:
#     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# ============================================================
param([string]$Target = "all")

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Version   = "0.1.0"

function Info($m) { Write-Host "==> $m" -ForegroundColor Blue }
function Ok($m)   { Write-Host "  ok $m" -ForegroundColor Green }
function Warn($m) { Write-Host "warning: $m" -ForegroundColor Yellow }
function Fail($m) { Write-Host "error: $m" -ForegroundColor Red }

function Install-Typst {
  Info "Installing the Typst package (utad $Version)…"
  if (-not (Get-Command typst -ErrorAction SilentlyContinue)) {
    Warn "typst not on PATH — copying files anyway."
  }
  $base = Join-Path $env:APPDATA "typst\packages\local"
  $dest = Join-Path $base "utad\$Version"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($f in @("utad.typ","utad-report.typ","utad-assignment.typ","utad-slides.typ","lib.typ","typst.toml")) {
    Copy-Item (Join-Path $ScriptDir "typst\$f") $dest -Force
  }
  Copy-Item (Join-Path $ScriptDir "typst\logo-*.svg") $dest -Force
  Ok "installed to $dest"
  Ok 'use it with:  #import "@local/utad:0.1.0": *'
}

function Install-Latex {
  Info "Installing the LaTeX package (utad)…"
  if (-not (Get-Command kpsewhich -ErrorAction SilentlyContinue)) {
    Fail "no TeX installation found (kpsewhich missing). Install TeX Live or MiKTeX first."
    return
  }
  $texmf = (& kpsewhich -var-value TEXMFHOME).Trim()
  if ([string]::IsNullOrWhiteSpace($texmf)) { $texmf = Join-Path $env:USERPROFILE "texmf" }
  $dest = Join-Path $texmf "tex\latex\utad"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item (Join-Path $ScriptDir "latex\utad.sty") $dest -Force
  Copy-Item (Join-Path $ScriptDir "latex\logo-*.pdf") $dest -Force
  if (Get-Command mktexlsr -ErrorAction SilentlyContinue) { & mktexlsr $texmf | Out-Null }
  elseif (Get-Command initexmf -ErrorAction SilentlyContinue) { & initexmf --update-fndb | Out-Null }
  Ok "installed to $dest"
  Ok 'use it with:  \usepackage{utad}   (compile with xelatex or lualatex)'
}

function Install-Tfg {
  Info "Installing the TFG class (utad-tfg)…"
  if (-not (Get-Command kpsewhich -ErrorAction SilentlyContinue)) {
    Fail "no TeX installation found (kpsewhich missing). Install TeX Live or MiKTeX first."
    return
  }
  $texmf = (& kpsewhich -var-value TEXMFHOME).Trim()
  if ([string]::IsNullOrWhiteSpace($texmf)) { $texmf = Join-Path $env:USERPROFILE "texmf" }
  $dest = Join-Path $texmf "tex\latex\utad-tfg"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($f in @("utad-tfg.cls","logo-utad.png","logo-ucjc.png")) {
    Copy-Item (Join-Path $ScriptDir "latex-tfg\$f") $dest -Force
  }
  if (Get-Command mktexlsr -ErrorAction SilentlyContinue) { & mktexlsr $texmf | Out-Null }
  elseif (Get-Command initexmf -ErrorAction SilentlyContinue) { & initexmf --update-fndb | Out-Null }
  Ok "installed to $dest"
  Ok 'use it with:  \documentclass{utad-tfg}   (latexmk -pdf; needs biber + biblatex-apa)'
}

switch ($Target.ToLower()) {
  "typst" { Install-Typst }
  "latex" { Install-Latex }
  "tfg"   { Install-Tfg }
  "all"   { Install-Typst; Write-Host ""; Install-Latex; Write-Host ""; Install-Tfg }
  default { Fail "unknown target '$Target' (use: typst | latex | tfg | all)" }
}
