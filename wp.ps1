# -src -dest -l -p -s

Param 
(
    [switch]$p,
    [switch]$l,
    [string]$src,
    [string]$dest
)

if 
(
    (![System.IO.Directory]::Exists($src))    -or  
    (![System.IO.Directory]::Exists($dest))

)
{
    Write-Host "-src or -dest parameter is not specified or not accessible"
    exit(1)
}


if
(
    $p -and $l
)
{
    write-host "both -l and -p flags specified. must be either -p of -l"
    exit(1)
}

if
(
    !$p -and !$l
)
{
    Write-Host "you must set -l or -p flag"
    exit(1)
}

$image = New-Object -ComObject Wia.ImageFile
try
{
$srcFiles = Get-ChildItem $src\* -Include *.jpg, *.png
}
catch
{
    Write-Host "can't load files:"
    Write-host $Error[0].Exception
    exit(1)
}

if
(
$srcFiles.count -eq 0
)
{
    write-host "there are no .jpg or .png images in this folder :("
    exit(1)
}

foreach ($currentImage in $srcFiles)
{
    $image.LoadFile($currentImage.FullName)
    $w = $image.width
    $h = $image.height
    if ($w -gt $h) 
    {
        write-host "$currentImage is landscape"
        if ($l)
        {
            write-host "copying to $dest"
            cp $currentImage.FullName $dest       
        }
    }
    if ($h -gt $w)
    {
        Write-Host "$currentImage is portrait"
        if ($p)
        {
            write-host "copying to $dest"
            cp $currentImage.FullName $dest
        }
    }
}