param (
    $url
)

$parts = $url.Split("/")[0..($url.Split("/").Length-3)]

$folderPath = $parts -join "/"

$folderPath = "packages/" + $folderPath

$subfolders = Get-ChildItem -Path $folderPath -Directory

$numSubfolders = $subfolders.Count

$numSubfolders


if($numSubfolders -gt 1){

    #Delete specific version-folder

    $parts = $url.Split("/")[0..($url.Split("/").Length-2)]

    $folderPath = $parts -join "/"

    $filePath = "packages/" + $folderPath

    if (Test-Path $filePath) {
        Remove-Item -Path $filePath -Recurse
    }
}else{

    #delete whole package

    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse
    }


    $parts = $url.Split("/")[0..($url.Split("/").Length-4)]

    $folderPath = $parts -join "/"

    $folderPath = "packages/" + $folderPath

    $subfolders = Get-ChildItem -Path $folderPath -Directory

    $numSubfolders = $subfolders.Count

    #check whether publisher has other packages
    if($numSubfolders -eq 0){
        #remove publisher-folder
        if (Test-Path $folderPath) {
            Remove-Item -Path $folderPath -Recurse
        }
    }

}



