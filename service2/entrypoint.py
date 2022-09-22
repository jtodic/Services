import requests
import sys

SERVICE1_URL = "http://localhost:8080"

#http://api.open-notify.org/astros.json

message = requests.get(input()).text #sys.stdin.readline()
data = ["md5", message]
print (data)
print(requests.post(SERVICE1_URL, data="\n".join(data)))
print(requests.post(SERVICE1_URL, data="\n".join(data)).status_code == requests.codes.ok)
print (data)