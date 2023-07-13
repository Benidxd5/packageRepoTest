param (
    $url
)

# $parts = $url.Split("/")[-5..-2]

# $fileName = $url.Split("/")[-1]

# $dirpath = $parts -join "/"

$dirpath = "packages/" + $url

$null = New-Item -Path $dirpath -Force -ItemType Directory

$filePath = (Join-Path -Path $dirpath -ChildPath $fileName)

$null = New-Item -Path $filePath -Force -ItemType File

return [string]$filePath