param (
    $url
)

$parts = $url.Split("/")[-5..-2]

$fileName = $url.Split("/")[-1]

$dirpath = $parts -join "/"

$dirpath = "packages/" + $dirpath

New-Item -Path $dirpath -Force -ItemType Directory

New-Item -Path (Join-Path -Path $dirpath -ChildPath $fileName) -Force -ItemType File