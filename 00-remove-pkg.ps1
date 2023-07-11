param (
    $url
)


$parts = $url.Split("/")[-5..-1]

$filePath = $parts -join "/"

$filePath = "packages/" + $filePath

if (Test-Path $filePath) {
    Remove-Item -Path $filePath
}