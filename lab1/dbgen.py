import random

nTasks = 50
nCPUs = 70
rt = []
rc = []

for i in range(0,nTasks):
    rt.append(round(random.uniform(100, 700),2))

for i in range(0,nCPUs):
    rc.append(round(random.uniform(100, 700),2))

str_rt = str(rt).replace(',', '')
str_rc = str(rc).replace(',', '')

print("nTasks =", nTasks, ";")
print("nCPUs =", nCPUs, ";")
print("rt =", str_rt, ";")
print("rc =", str_rc, ";")
