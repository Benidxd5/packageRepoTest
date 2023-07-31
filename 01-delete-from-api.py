import os
import requests

# url = "https://af4b-92-63-213-202.ngrok-free.app/api/approved-packages"
url = os.environ.get("API_URl")+"approved-packages"

identifier = os.environ.get("PKG_IDENTIFIER")

token = os.environ.get("API_TOKEN")

version = url.split("/")[-2]

print(version)

fetchResponse = requests.get(url=(url+'?filters[identifier][$eq]='+identifier), headers={"Authorization": token, "Content-Type": "application/json"})
fetchResponseJson = fetchResponse.json()
print(fetchResponseJson)
if(len(fetchResponseJson["data"])>0):
    id = fetchResponseJson["data"][0]["id"]
    delresp = requests.delete(url=(url+"/"+str(id)), headers={"Authorization": "token", "Content-Type": "application/json"})
    print(delresp)