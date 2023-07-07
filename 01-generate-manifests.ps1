
# $tmpPath = Join-Path -Path (Resolve-Path .tmp).Path -ChildPath .\manifests

# New-Item -Path $tmpPath -Force -ItemType Directory

# Get-ChildItem .\packages -Filter '*.jsonnet' | % {
#     "Name"
#     $_.Name
#     jsonnet -m $tmpPath -c ".\packages\$($_.Name)"
# }

# Get-ChildItem .\packages -Recurse -Include '*.yaml' | % {
#     "YamlFOUND"
#     $_.Directoryname
#     ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")
#     $item = (Get-Content -Path "$_")
#     $item
#     Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item).TrimEnd()
#     Remove-Item $_
    
# }

# Get-ChildItem .tmp -Recurse -Include '*.json' | % {
#     "Dirname"
#     $_.Directoryname
#     ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")
#     $item = (Get-Content -Path "$_" | ConvertFrom-Json)
#     Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item | ConvertTo-Yaml).TrimEnd()
#     Remove-Item $_





# }
# "TO YAML"
# Get-ChildItem .\packages -Recurse -Include '*.yaml' | % {
#     "YAML FOUND"
#     $item = (Get-Content -Path "$_")
#     $item
#     Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item).TrimEnd()
#     Remove-Item $_
# }





Get-ChildItem .\packages -Recurse -Include '*.yaml' | % {
    #if( $_ -like "*installer.yaml"){
    "Processing File"
    $_.Directoryname

    Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".def.yaml")

    # Array mit Pfaden zu den YAML-Dateien
    $inhalt = Get-Content -Path $_
    $inhalt = $inhalt | ConvertFrom-Yaml
    $inhalt["PackageIdentifier"]
    $quelleDateien = @(
        (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".yaml")),
        (Join-Path -Path $_.Directoryname -ChildPath ( $inhalt["PackageIdentifier"]+".def.yaml"))
    )
    "afterpaths"
    # Leeres Hashtable zum Speichern der Attribute
    $attributeHash = @{}
    $combInh = ""
    # Schleife zum Durchlaufen der YAML-Dateien
    foreach ($datei in $quelleDateien) {
        # Inhalte der Datei lesen
        if (Test-Path $datei) {
            #if( $datei -notlike "*def.yaml"){
                "new file"
                $inhalt = Get-Content -Path $datei -Raw
                $datei
                $inhalt
                # Konvertiere den YAML-Inhalt zu einem Hashtable
                $yamlInhalt = $inhalt | ConvertFrom-Yaml
                "inh"
                $yamlInhalt
                # Schleife durch die Attribute und füge sie dem Hashtable hinzu
                foreach ($attribut in $yamlInhalt) {
                    $attributeHash[$attribut] = $attribut.Value
                }

                "dateifound"
                $attributeHash 
                $combInh = $combInh+$inhalt
                "combinh"
                $combInh
            #}
        }   
    }

    # Konvertiere das Hashtable zurück in ein PowerShell-Objekt
    $kombiniertesObjekt = [PSCustomObject]$attributeHash
    "komb"
    # Konvertiere das kombinierte Objekt zu YAML
    $kombiniertesYaml = ($attributeHash | ConvertTo-Yaml)
    # Pfad zur Zieldatei
    $kombiniertesYaml
    $zielDatei = $_.Directoryname+"\HS2N.PAKETTEST.def.yaml"

    # Speichere das kombinierte YAML in der Zieldatei
    Set-Content -Path $zielDatei -Value $combInh


    "yaml"
    "content"
    Get-Content -Path $zielDatei -Raw

    Write-Host "Die kombinierte Datei wurde erstellt: $zielDatei"
   # }
}



# Installieren des PowerShell-Moduls 'powershell-yaml'
# Beachte, dass du dies vor dem Ausf端hren des Skripts einmalig ausf端hren musst.
# Dateipfade der Eingabedateien
# Installieren des PowerShell-Moduls 'powershell-yaml'
# Beachte, dass du dies vor dem Ausf端hren des Skripts einmalig ausf端hren musst.


# Get-ChildItem .\packages -Recurse -Include '*.yaml' | % {

# # Dateipfade der Eingabedateien
# $file1 = (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".yaml")),
# $file2 = (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_")+".def.yaml"))

# # Einlesen der Daten aus den Eingabedateien
# $data1 = Get-Content -Raw -Path $file1 | ConvertFrom-Yaml
# $data2 = Get-Content -Raw -Path $file2 | ConvertFrom-Yaml

# # Zusammenf端hren der Daten
# $mergedData = @{}
# $mergedData += $data1
# $mergedData += $data2


# # Konvertieren der Daten in YAML
# $yamlData = $mergedData | ConvertTo-Yaml -Depth 100

# # Speichern der YAML-Daten in einer Datei
# $outputFile = $_.Directoryname+"\HS2N.PAKETTEST.def.yaml"
# $yamlData | Out-File -FilePath $outputFile -Encoding UTF8

# Write-Host "Die Zusammenf端hrung wurde abgeschlossen und die Ausgabedatei wurde unter $outputFile gespeichert."

# }












Remove-Item -Path .\manifests -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path .\packages -Recurse -Force -Destination .\manifests