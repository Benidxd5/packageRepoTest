
Get-ChildItem .\packages -Recurse -Include 'HS2N.PAKETTEST.*' | % {
    "Processing File"
    $_
    $_.Directoryname

    Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".def.yaml")

    # Array mit Pfaden zu den YAML-Dateien
    $inhalt = Get-Content -Path $_
    $inhalt = $inhalt | ConvertFrom-Yaml
    $pkgid = $inhalt["PackageIdentifier"]

    $quelleDateien = @(
        (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".yaml")),
        (Join-Path -Path $_.Directoryname -ChildPath ( $inhalt["PackageIdentifier"]+".def.yaml"))
    )

    $cpyMerge = ""



    $combInh = @{}
    # Schleife zum Durchlaufen der YAML-Dateien
    foreach ($datei in $quelleDateien) {

        if (Test-Path $datei) {


            $inhalt = Get-Content -Path $datei -Raw
            #$cpyMerge += $inhalt
            #$yamlInhalt = $inhalt | ConvertFrom-Yaml #$inhalt | ConvertFrom-Yaml
            # foreach ($key in $yamlInhalt.Keys) {
            #     $combInh[$key] = $yamlInhalt[$key]
            # }
            # if($yamlInhalt.Keys -contains "ManifestType"){
            #     # $yamlInhalt["ManifestType"] = "merged"
            #     $yamlInhalt.Remove("ManifestType")
            # }

            $cpyMerge += $inhalt #($yamlInhalt | ConvertTo-Yaml)


            $cpyMerge

        }   
    }

    # $combInh["ManifestType"] = "merged"

    $zielDatei = (Join-Path -Path $_.Directoryname -ChildPath ($pkgid+".def.yaml"))

    Set-Content -Path $zielDatei -Value $cpyMerge #($combInh | ConvertTo-Yaml)

    Write-Host "Die kombinierte Datei wurde erstellt: $zielDatei"
}


Remove-Item -Path .\manifests -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path .\packages -Recurse -Force -Destination .\manifests