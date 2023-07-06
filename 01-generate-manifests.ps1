
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
    "Processing File"
    $_.Directoryname

    # Array mit Pfaden zu den YAML-Dateien
    $quelleDateien = @(
        Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_"))+".yaml",
        Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_"))+".def.yaml"
    )

    # Leeres Hashtable zum Speichern der Attribute
    $attributeHash = @{}

    # Schleife zum Durchlaufen der YAML-Dateien
    foreach ($datei in $quelleDateien) {
        # Inhalte der Datei lesen
        $inhalt = Get-Content -Path $datei -Raw

        # Konvertiere den YAML-Inhalt zu einem Hashtable
        $yamlInhalt = $inhalt | ConvertFrom-Yaml

        # Schleife durch die Attribute und füge sie dem Hashtable hinzu
        foreach ($attribut in $yamlInhalt.PSObject.Properties) {
            $attributeHash[$attribut.Name] = $attribut.Value
        }
    }

    # Konvertiere das Hashtable zurück in ein PowerShell-Objekt
    $kombiniertesObjekt = [PSCustomObject]$attributeHash

    # Konvertiere das kombinierte Objekt zu YAML
    $kombiniertesYaml = ConvertTo-Yaml -InputObject $kombiniertesObjekt

    # Pfad zur Zieldatei
    $zielDatei = $_.Directoryname+".def.yaml"

    # Speichere das kombinierte YAML in der Zieldatei
    Set-Content -Path $zielDatei -Value $kombiniertesYaml

    Write-Host "Die kombinierte Datei wurde erstellt: $zielDatei"
}


















Remove-Item -Path .\manifests -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path .\packages -Recurse -Force -Destination .\manifests