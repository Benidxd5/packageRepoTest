param (
    $path
)

$parts = $path.Split("/")

$parts = $parts[0..($parts.Length-2)]

$fileName = $path.Split("/")[-1]

$dirpath = $parts -join "/"

$dirpath = "packages/" + $dirpath

$null = New-Item -Path $dirpath -Force -ItemType Directory

$filePath = (Join-Path -Path $dirpath -ChildPath $fileName)

$null = New-Item -Path $filePath -Force -ItemType File

return [string]$filePath