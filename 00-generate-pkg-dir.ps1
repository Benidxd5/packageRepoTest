param (
    $url
)

$parts = $url.Split("/")[-5..-2]

$dirpath = $parts -join "/"

$dirpath = "./test/" + $dirpath

New-Item -Path $dirpath -Force -ItemType Directory
