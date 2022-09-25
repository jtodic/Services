import requests
import sys

SERVICE1_URL = "http://service1:8080"

message = requests.get(sys.stdin.readline()).text #sys.stdin.readline()
data = ["md5", message]

print (data)
print(requests.post(SERVICE1_URL, data="\n".join(data)))
print(requests.post(SERVICE1_URL, data="\n".join(data)).status_code == requests.codes.ok)
print (data)
