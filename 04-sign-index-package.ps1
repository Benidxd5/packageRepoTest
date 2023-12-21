param(
    $pfxPass
)

ECHO 'Y' | winget install --id MarcinOtorowski.MSIXHero

$pfxPassphrase = ($env:PFX_PASSPHRASE).Trim()
$pfxPath = "$PSScriptRoot\HS2N.pfx"

& msixherocli.exe sign --file "$pfxPath" --password "$pfxPass" --noPublisherUpdate --timestamp "http://timestamp.digicert.com" "$PSScriptRoot\source.msix"