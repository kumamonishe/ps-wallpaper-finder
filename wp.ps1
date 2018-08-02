# -src -dest -l -p -s

Param 
(
    [switch]$p,
    [switch]$l,
    [switch]$y, #if set will create non-existant -dest
    [string]$src,
    [switch]$rec,
    [string]$dest
)


if 
(
    (![System.IO.Directory]::Exists($src))

)
{
    Write-Host "-src parameter is not specified or not accessible"
    exit(1)
}

if (![System.IO.Directory]::Exists($dest))
{
    write-host "Directory not found"
    if ($y)
    {
        Write-Host "Creating $dest"
        mkdir $dest
    }
    else
    {
        Write-Host "specify flag -y for directories autocreation"
        exit(1)
    }
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

if (!$rec) {
try
{
$srcFiles = Get-ChildItem $src\* -Include *.jpg, *.png
}
catch
{
    Write-Host "can't load files:"
    Write-host $Error[0].Exception
    exit(1)
}}
else {

$srcFiles = Get-ChildItem -recurse $src\* -Include *.jpg, *.png
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
    $NewName = add-timestamp($currentImage)
    $w = $image.width
    $h = $image.height
    if ($w -gt $h) 
    {
        write-host "$currentImage is landscape"
        if ($l)
        {
            write-host "copying to $dest"
            try {
            cp $currentImage.FullName $dest\$NewName
            }
            catch {
    Write-Host "cant copy"
    write-Host $Error[0].Exception
            }
        }
    }
    if ($h -gt $w)
    {
        Write-Host "$currentImage is portrait"
        if ($p)
        {
            write-host "copying to $dest"
            try {
            cp $currentImage.FullName $dest\$NewName
            }
            catch {

    Write-Host "cant copy"
    write-Host $Error[0].Exception
            }
        }
    }
}
