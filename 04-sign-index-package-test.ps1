$winSdkFolder = if ($env:WINDOWS_SDK) { $env:WINDOWS_SDK_BIN_X64 } else { "C:\Program Files (x86)\Windows Kits\10\bin\10.0.20348.0\x64" }
$signToolPath = Join-Path $winSdkFolder -ChildPath signtool.exe

$pfxPassphrase = ($env:PFX_PASSPHRASE).Trim()
$pfxPath = "$PSScriptRoot\Certificate.pfx"

$thumbprint = ($env:PFX_THUMBPRINT).Trim()

& $signToolPath sign /f "$pfxPath" /d "source.msix" /p "$pfxPassphrase" /v /fd SHA256 /a ./Certificate.pfx /t "http://timestamp.comodoca.com/authenticode" "$PSScriptRoot\source.msix"
