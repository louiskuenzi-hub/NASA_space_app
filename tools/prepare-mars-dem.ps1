# Documents how data/mars/mars_dem.bin was made.
# Input: NASA PDS MOLA MEGDR file megt90n000cb.img (4 px/deg, signed 16-bit big-endian metres relative to the areoid,
#        column 0 = 0 deg E) from https://pds-geosciences.wustl.edu/mgs/urn-nasa-pds-mgs_mola_topography_derived/meg004/
# Output: raw little-endian int16 grid, 1440 x 720, north row first, rotated so column 0 = -180 deg (matches the colour map).
param([string]$Img = "megt90n000cb.img", [string]$Out = "..\data\mars\mars_dem.bin")
$raw = [IO.File]::ReadAllBytes((Resolve-Path $Img)); $W = 1440; $H = 720
for ($i = 0; $i -lt $raw.Length; $i += 2) { $t = $raw[$i]; $raw[$i] = $raw[$i + 1]; $raw[$i + 1] = $t }
$res = New-Object byte[] $raw.Length
for ($r = 0; $r -lt $H; $r++) {
  $o = $r * $W * 2
  [Buffer]::BlockCopy($raw, $o + 720 * 2, $res, $o, 720 * 2)
  [Buffer]::BlockCopy($raw, $o, $res, $o + 720 * 2, 720 * 2)
}
[IO.File]::WriteAllBytes($Out, $res)
"wrote $Out"