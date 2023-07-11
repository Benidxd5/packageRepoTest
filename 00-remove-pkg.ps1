param (
    $url
)


$parts = $url.Split("/")[-5..-1]

$filePath = $parts -join "/"

if (Test-Path $filePath) {
    Remove-Item -Path $filePath
}