# Documents how data/moon/moon_dem.bin was made.
# Input: NASA SVS CGI Moon Kit file ldem_4_uint.tif (LRO LOLA, 4 px/deg, unsigned 16-bit, half-metres offset by +20000,
#        longitude -180..180) from https://svs.gsfc.nasa.gov/4720
# Output: raw little-endian uint16 grid, 1440 x 720, north row first.
param([string]$Tif = "ldem_4_uint.tif", [string]$Out = "..\data\moon\moon_dem.bin")
Add-Type -AssemblyName PresentationCore
$fs  = [IO.File]::OpenRead((Resolve-Path $Tif))
$dec = New-Object System.Windows.Media.Imaging.TiffBitmapDecoder($fs, [System.Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$fr  = $dec.Frames[0]
$stride = $fr.PixelWidth * 2
$buf = New-Object byte[] ($stride * $fr.PixelHeight)
$fr.CopyPixels($buf, $stride, 0)
$fs.Dispose()
[IO.File]::WriteAllBytes($Out, $buf)
"wrote $Out ($($fr.PixelWidth) x $($fr.PixelHeight))"