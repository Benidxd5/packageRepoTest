import requests
import sqlite3
from sqlite3 import Error
import os
import math

db_path = ".tmp/source/Public/index.db"

token = os.environ.get("API_TOKEN")

url_post = os.environ.get("API_URl")+"packages"

# url_post = "http://10.10.10.138:1337/api/packages"
# token = "bearer d547a841dc8b98d9234e94238d09aa4aad78b985d294d5d45feca6ebdb16d0dcaee0c3bd4e357e02998d5dd4e45090a02323dbb4ffb3ee083ac824e6db67792a9a9713454e3186e9ea18172ca3730e42dfdcc06c3a7b34fd1a40afc1f699a0d6619e1920ba20358d7281cf0b6984b6b76a9f01be1873ab71031c61a78855e11b"


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
        
        #fetch package to get id
        fetchResponse = requests.get(url=(url_post+'?filters[identifier][$eq]='+data["PackageIdentifier"]), headers={"Authorization": token, "Content-Type": "application/json"})
        fetchResponseJson = fetchResponse.json()
        if(len(fetchResponseJson["data"])>0):
            pkgID = fetchResponseJson["data"][0]["id"]
            updated_package = {
                "name": data['PackageName'],
                "identifier": data["PackageIdentifier"],
                "description": data["Description"] if "Description" in data else " ",
                "versions": packageVersions[data['PackageIdentifier']],
                "path": data["Path"]
            }
            payload = {
                "data": updated_package
            }
            requests.put(url=(url_post+"/"+str(pkgID)), json=payload, headers={"Authorization": token, "Content-Type": "application/json"})

    else:
        packageVersions[data['PackageIdentifier']] = {str(data['PackageVersion']):data["Path"]}
        new_package = {
            "name": data['PackageName'],
            "identifier": data["PackageIdentifier"],
            "description": data["Description"] if "Description" in data else " ",
            "versions": packageVersions[data['PackageIdentifier']],
            "path": data["Path"]
        }
        payload = {
            "data": new_package
        }
        post_response = requests.post(url=url_post, json=payload, headers={"Authorization": token, "Content-Type": "application/json"})





con = sqlite3.connect(db_path)

sql_file = open("index.db.sql")
sql_as_string = sql_file.read()

cursor = con.cursor()

cursor.execute('SELECT id, name, version, pathpart FROM manifest where rowid<100;')
row = cursor.fetchall()
cnt=0

progress = ["."] * 100

numPkgs = len(row)
pkgNum = 1

progress[:math.floor(1/numPkgs*100)] = ["|"]*(math.floor(1/numPkgs*100))

for idx in row:
    pkgData = createPackageDataObj(idx,cursor)
    pushPackage(pkgData)
    progress[math.floor(pkgNum/numPkgs*100)] = "|"
    print("".join(progress))
    pkgNum+=1



print("Fetched " +numPkgs+ " packages!")




