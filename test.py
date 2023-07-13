import requests
from requests.auth import HTTPBasicAuth
import json
import math

# url_post = "http://10.10.10.138:1337/api/approved-packages"
# token = "bearer ee3d6da7cf68479d1392d3a9fd45282ec14499a8832556465dd236504582a834842a1025626441d9c84a49265a1c75fdde2936c5f6b03f1c2339b39351a26ecea7c07735f522374b4a36a7169e4691bc586777f0800db321a8ba3abe018e6d80de0810001f5805630dc3494d6bb77cf96e6668f46830b3787a4cf0687eaede64"

# new_package = {
#     "name": "testname",
#     "identifier": "testid",
#     "description": "testdesc",
#     "versions": [16.4,20.2],
#     "path": "/b/joe"
# }

# payload = {
#     "data": new_package
# }

# post_response = (requests.post(url=url_post, json=payload, headers={"Authorization": token, "Content-Type": "application/json"}))
# post_response_json = post_response.json()
# print(post_response_json)

# url_post = "https://e8cf-92-63-213-202.ngrok-free.app/api/approved-packages"

# token = "bearer d547a841dc8b98d9234e94238d09aa4aad78b985d294d5d45feca6ebdb16d0dcaee0c3bd4e357e02998d5dd4e45090a02323dbb4ffb3ee083ac824e6db67792a9a9713454e3186e9ea18172ca3730e42dfdcc06c3a7b34fd1a40afc1f699a0d6619e1920ba20358d7281cf0b6984b6b76a9f01be1873ab71031c61a78855e11b"


# # fetchResponse = requests.get(url=(url_post+'?filters[identifier][$eq]='+"7zip.7zip"), headers={"Authorization": token, "Content-Type": "application/json"})
# # fetchResponseJson = fetchResponse.json()
# # print(fetchResponseJson)
# # pkgID = fetchResponseJson["data"][0]["id"]
# # print(len (fetchResponseJson["data"]))

# updated_package = {
#     "name": "Postman",
#     "identifier": "Postman.Postman",
#     "description": "descr",
#     "versions": [1.3, 1.4],
#     "path": "https://"
# }
# payload = {
#     "data": updated_package
# }
# post_response = requests.post(url=(url_post), json=payload, headers={"Authorization": token, "Content-Type": "application/json"})
# # Print the response
# print(post_response)
# post_response_json = post_response.json()
# print(post_response_json)


# packageVersions = {}

# packageVersions["pid"] = {"1.0.0":"/pfad"}

# packageVersions["pid"]["2.0.0"] = "/pfad2"

# print(packageVersions)

progress = ["."] * 100

# progress[:4] = ["j"]*4

# print("".join(progress))
# print(len(progress))

progress[:math.floor(1/3500*100)] = ["|"]*(math.floor(1/3500*100))

for idx in range(3500):
    progress[math.floor(idx/3500*100)] = "|"
    print("".join(progress))

