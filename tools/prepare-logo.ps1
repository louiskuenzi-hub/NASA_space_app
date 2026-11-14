# Documents how assets/logo-white.png was made from assets/logo-original.png:
# crops the margins and turns the black mark into white on a transparent background (alpha = darkness).
param([string]$Src = "..\assets\logo-original.png", [string]$Dst = "..\assets\logo-white.png")
Add-Type -AssemblyName System.Drawing
$im = New-Object Drawing.Bitmap((Resolve-Path $Src).Path)
$minx = $im.Width; $miny = $im.Height; $maxx = 0; $maxy = 0
for ($y = 0; $y -lt $im.Height; $y++) { for ($x = 0; $x -lt $im.Width; $x++) {
  $c = $im.GetPixel($x, $y); $l = 0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B
  if ($c.A -gt 20 -and $l -lt 200) { if ($x -lt $minx) { $minx = $x }; if ($x -gt $maxx) { $maxx = $x }; if ($y -lt $miny) { $miny = $y }; if ($y -gt $maxy) { $maxy = $y } } } }
$pad = 6; $x0 = [math]::Max(0, $minx - $pad); $y0 = [math]::Max(0, $miny - $pad)
$cw = [math]::Min($im.Width - $x0, $maxx - $minx + 1 + 2 * $pad); $ch = [math]::Min($im.Height - $y0, $maxy - $miny + 1 + 2 * $pad)
$out = New-Object Drawing.Bitmap($cw, $ch, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
for ($y = 0; $y -lt $ch; $y++) { for ($x = 0; $x -lt $cw; $x++) {
  $c = $im.GetPixel($x0 + $x, $y0 + $y); $l = 0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B
  $a = [int]([math]::Round((255 - $l) * ($c.A / 255))); if ($a -lt 0) { $a = 0 }
  $out.SetPixel($x, $y, [Drawing.Color]::FromArgb($a, 255, 255, 255)) } }
$out.Save(((Resolve-Path (Split-Path $Dst)).Path + "\" + (Split-Path $Dst -Leaf)), [Drawing.Imaging.ImageFormat]::Png)