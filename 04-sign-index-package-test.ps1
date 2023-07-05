# $winSdkFolder = if ($env:WINDOWS_SDK) { $env:WINDOWS_SDK_BIN_X64 } else { "C:\Program Files (x86)\Windows Kits\10\bin\10.0.20348.0\x64" }
# $signToolPath = Join-Path $winSdkFolder -ChildPath signtool.exe
# $signToolPath = msixherocli.exe
$ConfirmPreference = 'None'
winget install --id MarcinOtorowski.MSIXHero

$pfxPassphrase = ($env:PFX_PASSPHRASE).Trim()
$pfxPath = "$PSScriptRoot\HS2N.pfx"

# $thumbprint = ($env:PFX_THUMBPRINT).Trim()

# & msixherocli.exe sign /f "$pfxPath" /d "source.msix" /p "$pfxPassphrase" /v /fd SHA256 /a ./Certificate.pfx /t "http://timestamp.comodoca.com/authenticode" "$PSScriptRoot\source.msix"
& msixherocli.exe sign --file "$pfxPath" --password "$pfxPassphrases" --timestamp auto "$PSScriptRoot\source.msix"