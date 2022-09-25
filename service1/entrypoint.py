import sys
import hashlib

inp = sys.stdin.readlines()

hash_func = inp[0].strip()
message = '\n'.join(inp[1:]).strip()

h = hashlib.new(hash_func)
h.update(str.encode(message))

#Added writing hash to file
f = open("hash-log.txt", "a")
f.write("Message: " + message + " Hash: " + h.hexdigest()+ "\n")
f.close()

