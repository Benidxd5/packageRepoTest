import requests
import sqlite3
from sqlite3 import Error
import os
import math
from urllib.parse import quote
from datetime import datetime, timedelta


db_path = ".tmp/source/Public/index.db"

token = os.environ.get("API_TOKEN")

url_available = os.environ.get("API_URL")+"packages"

url_approved = os.environ.get("API_URL")+"approved-packages?fields[0]=identifier&fields[1]=versions&pagination[pageSize]=100"

git_token = os.environ.get("GITHUB_TOKEN")

repo_dispatch_url = os.environ.get("REPOSITORY_API_URL")+"/dispatches"


packageVersions = {}


def getPath(id):
    path = ""
    parentId = id
    while(parentId>1):
        cursor.execute('SELECT parent,pathpart FROM pathparts where rowid={};'.format(parentId))
        row = cursor.fetchall()
        parentId=row[0][0]
        path=row[0][1]+"/"+path

    path = path[:-1]

    return path


def createPackageDataObj(manifestRow, cursor):
    data = {}

    cursor.execute('SELECT id from ids where rowid={}'.format(manifestRow[0]))
    data["PackageIdentifier"] = cursor.fetchall()[0][0]

    cursor.execute('SELECT name from names where rowid={}'.format(manifestRow[1]))
    data["PackageName"] = cursor.fetchall()[0][0]

    cursor.execute('SELECT version from versions where rowid={}'.format(manifestRow[2]))
    data["PackageVersion"] = cursor.fetchall()[0][0]

    data["Path"] = getPath(manifestRow[3])

    return data


def pushPackage(data):

    if(data['PackageIdentifier'] in packageVersions):
        packageVersions[data['PackageIdentifier']][str(data['PackageVersion'])] = data["Path"]
    else:
        packageVersions[data['PackageIdentifier']] = {str(data['PackageVersion']):data["Path"]}

    parsedIdentifier = quote(data["PackageIdentifier"])
    #fetch package to check if already inserted
    fetchResponse = requests.get(url=(url_available+'?filters[identifier][$eq]='+parsedIdentifier), headers={"Authorization": token, "Content-Type": "application/json"})
        
    fetchResponseJson = fetchResponse.json()

    description = data["Description"] if "Description" in data else data["ShortDescription"] if "ShortDescription" in data else " "

    if(len(fetchResponseJson["data"])>0):
        pkgID = fetchResponseJson["data"][0]["id"]
        updated_package = {
            "name": data['PackageName'],
            "identifier": data["PackageIdentifier"],
            "description": description,
            "versions": packageVersions[data['PackageIdentifier']],
            "path": data["Path"]
        }
        payload = {
            "data": updated_package
        }
        requests.put(url=(url_available+"/"+str(pkgID)), json=payload, headers={"Authorization": token, "Content-Type": "application/json"})

    else:
        new_package = {
            "name": data['PackageName'],
            "identifier": data["PackageIdentifier"],
            "description": description,
            "versions": packageVersions[data['PackageIdentifier']],
            "path": data["Path"]
        }
        payload = {
            "data": new_package
        }
        requests.post(url=url_available, json=payload, headers={"Authorization": token, "Content-Type": "application/json"})





con = sqlite3.connect(db_path)

sql_file = open("index.db.sql")
sql_as_string = sql_file.read()

cursor = con.cursor()

cursor.execute('SELECT id, name, version, pathpart FROM manifest;')
row = cursor.fetchall()
cnt=0

progress = ["."] * 100

numPkgs = len(row)
pkgNum = 1

progress[:math.floor(1/numPkgs*100)] = ["|"]*(math.floor(1/numPkgs*100))

for idx in row:
    pkgData = createPackageDataObj(idx,cursor)
    pushPackage(pkgData)
    print(str(pkgNum) + "/" + str(numPkgs))
    pkgNum+=1



print("Fetched " +str(numPkgs)+ " packages/versions!")

print("removing outdated packages")

#filter entries, which haven't recieved an update for the last 5 hours
url_outdated = url_available + "?fields[0]=updatedAt&pagination[pageSize]=100&filters[updatedAt][$lt]="+str(datetime.utcnow() - timedelta(hours=5)) 

fetchResponse = requests.get(url=(url_outdated), headers={"Authorization": token, "Content-Type": "application/json"}) #get outdated packages

fetchResponseJson = fetchResponse.json()

data = fetchResponseJson["data"]

for pkg in data:
    pkgId = pkg["id"]
    requests.delete(url=(url_available+"/"+str(pkgId)), headers={"Authorization": token, "Content-Type": "application/json"})

print(str(len(data)) + " outdated packages removed")
    


print("Updating approved packages")
#sync the paths with the recently pulled winget packages

fetchResponse = requests.get(url=(url_approved), headers={"Authorization": token, "Content-Type": "application/json"})
        
fetchResponseJson = fetchResponse.json()

pageCount = fetchResponseJson["meta"]["pagination"]["pageCount"]

paths = []

url_available += "?filters[identifier][$eq]="

currPage = 1

while currPage <= pageCount:   #multiple page support

    data = fetchResponseJson["data"]

    fetchResponse = requests.get(url=(url_approved+"&pagination[page]="+str(currPage)), headers={"Authorization": token, "Content-Type": "application/json"})
    fetchResponseJson = fetchResponse.json()
    currPage+=1

    for old_pkg in data:
        print("updating " + old_pkg["attributes"]["identifier"])

        fetchResponse = requests.get(url=(url_available+old_pkg["attributes"]["identifier"]), headers={"Authorization": token, "Content-Type": "application/json"}) 
        
        if(fetchResponse):

            fetchResponseJson = fetchResponse.json()

            if fetchResponseJson["data"]:
                updatedPackage = fetchResponseJson["data"][0]["attributes"]

            for version in old_pkg["attributes"]["versions"]:
                print(version)
                if version in updatedPackage["versions"]:
                    paths.append(updatedPackage["versions"][str(version)])

#trigger the pkgadd github workflow, to update the approved packages
if len(paths)>0:
    response = requests.post(repo_dispatch_url, json={"event_type": "pkgadd", "client_payload":{"pkgPaths":','.join(map(str, paths))}}, headers={"Authorization": "token " + git_token})
    print(response)


