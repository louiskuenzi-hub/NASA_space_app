# Builds index.html from src/template.html and the files in data/ and assets/.
# Usage (Windows PowerShell 5.1 or PowerShell 7):  powershell -ExecutionPolicy Bypass -File src\build.ps1
param([string]$Out = (Join-Path (Split-Path $PSScriptRoot -Parent) "index.html"))
$root = Split-Path $PSScriptRoot -Parent
$enc  = New-Object Text.UTF8Encoding($false)
function B64($p) { [Convert]::ToBase64String([IO.File]::ReadAllBytes($p)) }
function Txt($p) { [IO.File]::ReadAllText($p, [Text.Encoding]::UTF8) }

$logo = "data:image/png;base64," + (B64 "$root\assets\logo-white.png")
$rep = @{
  '/*MOONDEM*/'   = "data/moon/moon_dem.bin"
  '/*MOONCOLOR*/' = "data/moon/lroc_color_2k.jpg"
  '/*MARSDEM*/'   = "data/mars/mars_dem.bin"
  '/*MARSCOLOR*/' = "data/mars/mars_color_1920.jpg"
  '/*LOGO*/'      = $logo
  '/*CREDITS*/'   = (Txt "$root\data\credits.html")
}
$sites  = (Txt "$root\data\sites.json").Replace('</', '<\/')
$world  = Txt "$root\data\countries-110m.json"
$folder = (Txt "$root\data\folder.json").Replace('</', '<\/')
$o = (Txt "$root\src\template.html").Replace('/*SITES*/', $sites).Replace('/*WORLD*/', $world).Replace('/*FOLDER*/', $folder)
foreach ($k in $rep.Keys) { $o = $o.Replace($k, $rep[$k]) }

$desc = "Interactive map of places on Earth that resemble the Moon or Mars, based on ESA's Catalogue of Planetary Analogues. Built by Helvetic Dynamics for the NASA Space Apps Challenge."
$head = '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><meta name="description" content="' + $desc + '"><meta property="og:title" content="Landing Site Finder"><meta property="og:description" content="' + $desc + '"><meta name="theme-color" content="#0b0d12"><link rel="icon" type="image/png" href="' + $logo + '"></head><body>'
[IO.File]::WriteAllText($Out, ($head + $o + '</body></html>'), $enc)
"wrote {0} ({1:N1} MB)" -f $Out, ((Get-Item $Out).Length / 1MB)