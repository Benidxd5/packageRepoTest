param (
    $url
)

$parts = $url.Split("/")[0..-2]

$fileName = $url.Split("/")[-1]

$dirpath = $parts -join "/"

$dirpath = "packages/" + $dirpath

$null = New-Item -Path $dirpath -Force -ItemType Directory

$filePath = (Join-Path -Path $dirpath -ChildPath $fileName)

$null = New-Item -Path $filePath -Force -ItemType File

return [string]$filePath