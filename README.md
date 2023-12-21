# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

To use our packages, just add this repository as new source in winget using the following command.

```powershell
winget source add --name hs2n https://hs2n.github.io/winget-pkgs/
```

If you want to update it later run this:

```powershell
winget source update --name hs2n
```

Now you can install packages hosted in this repository:

```powershell
winget install [Package Name] -s hs2n
```

Just run `winget search -s hs2n` to get a complete list of packages available from this repo.


## Secrets

### API_URL: 
    The url of the API ending on .../api/
### API_TOKEN: 
    The API token used for reading and writing
### PFX_PASSPHRASE: 
    password of the certificate to sign the build (currently "testCer")

## Repo-Variables

### REPOSITORY_API_URL:
    The url of the github api for this repository
    Used to trigger workflows

## Workflows

### manual.yml: 
    A workflow triggered by the api (http dispatch). Adds/Removes Packages from the repo
    Called via "https://api.github.com/repos/hs2n/winget-pkgs/dispatches"

    Payload:
        "event_type": "pkgadd" OR "pkgrem", 
        "client_payload":{
            "pkgPaths": String containing the paths of the selected packages as a String (seperated with ",")     
        }

    Authorization:
        "Authorization": [github token]

### release.yml: 
    A workflow for building the repo. Runs after every change in the repository.

### wingetfetch.yml: 
    A workflow for fetching all winget packages from the community repo and storing them in the database. Triggered manually or via interval.
    Outdated winget-packages will be removed (approved ones are kept!)
    Approved packages are synced with their available counterpart


