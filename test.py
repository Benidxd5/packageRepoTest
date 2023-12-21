import requests
from datetime import datetime, timedelta


url_approved = "http://10.10.10.152:1337/api/approved-packages?fields[0]=identifier&fields[1]=versions&pagination[pageSize]=1000&&pagination[page]=2"
token = "bearer a89f39354845fdf47dd780ab9918c43ecd98046c958260de14551505ce9dc691f0a655288964447577310e84e3707f2e96fc16775a8d09bf888c641369dd2d831f36db417e18e825d3d29efdeb5ca68615bb925e7abb5e50d37d94eb2871a4fdbf6bb753dbca0289f13337565d895c988406aa1cb5f0e608446b9b87d050459c"

five_hours_ago = str(datetime.utcnow() - timedelta(hours=5,days=2))

print(five_hours_ago)

url_available ="http://10.10.10.152:1337/api/packages?fields[0]=updatedAt&pagination[pageSize]=100&filters[updatedAt][$lt]="+str(datetime.utcnow() - timedelta(hours=5, days=2))


# url_approved = "http://10.10.10.152:1337/api/approved-packages?filters[identifier][$eq]=Microsoft.VisualStudioCode"


fetchResponse = requests.get(url=(url_available), headers={"Authorization": token, "Content-Type": "application/json"})
        
fetchResponseJson = fetchResponse.json()

print(fetchResponseJson)

data = fetchResponseJson["data"]
oldcount = 0
newcount = 0
for pkg in data:
    parsed_date = datetime.strptime(pkg["attributes"]["updatedAt"], '%Y-%m-%dT%H:%M:%S.%fZ')
    time_difference = datetime.utcnow() - parsed_date
    if time_difference > timedelta(days=2):
        oldcount+=1
    else: 
        newcount+=1

print(oldcount, newcount)
# print(fetchResponseJson)

# pageCount = fetchResponseJson["meta"]["pagination"]["pageCount"]




# data = fetchResponseJson["data"]

# paths = []

# for old_pkg in data:
#     print(old_pkg["attributes"]["identifier"])

#     fetchResponse = requests.get(url=(url_available+old_pkg["attributes"]["identifier"]), headers={"Authorization": token, "Content-Type": "application/json"}) 
    
#     if(fetchResponse):

#         fetchResponseJson = fetchResponse.json()

#         if fetchResponseJson["data"]:
#             updatedPackage = fetchResponseJson["data"][0]["attributes"]

#         for version in old_pkg["attributes"]["versions"]:
#             print(version)
#             if version in updatedPackage["versions"]:
#                 paths.append(updatedPackage["versions"][str(version)])



# resp = requests.post("https://api.github.com/repos/hs2n/winget-pkgs/dispatches", json={"event_type": "pkgadd", "client_payload":{"pkgPaths":"test"}}, headers={"Authorization": "token " + "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"})
# print(resp)
# print(resp.json())

