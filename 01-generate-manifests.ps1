
$tmpPath = Join-Path -Path (Resolve-Path .tmp).Path -ChildPath .\manifests

New-Item -Path $tmpPath -Force -ItemType Directory

Get-ChildItem .\packages -Filter '*.jsonnet' | % {
    jsonnet -m $tmpPath -c ".\packages\$($_.Name)"
}

Get-ChildItem .tmp -Recurse -Include '*.json' | % {
    $item = (Get-Content -Path "$_" | ConvertFrom-Json)
    Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item | ConvertTo-Yaml).TrimEnd()
    Remove-Item $_
}
# "TO YAML"
# Get-ChildItem .\packages -Recurse -Include '*.yaml' | % {
#     "YAML FOUND"
#     $item = (Get-Content -Path "$_")
#     $item
#     Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item).TrimEnd()
#     Remove-Item $_
# }


Remove-Item -Path .\manifests -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$tmpPath\" -Recurse -Force -Destination .\manifests
