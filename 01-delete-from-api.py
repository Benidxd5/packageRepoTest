import os
import requests
import sys

# url = "https://af4b-92-63-213-202.ngrok-free.app/api/approved-packages"
url = os.environ.get("API_URl")+"approved-packages"
token = os.environ.get("API_TOKEN")

identifier = sys.argv[1]

if(identifier):

    fetchResponse = requests.get(url=(url+'?filters[identifier][$eq]='+identifier), headers={"Authorization": token, "Content-Type": "application/json"})
    fetchResponseJson = fetchResponse.json()
    if(len(fetchResponseJson["data"])>0):
        id = fetchResponseJson["data"][0]["id"]
        delresp = requests.delete(url=(url+"/"+str(id)), headers={"Authorization": token, "Content-Type": "application/json"})
        print(delresp)



