import csv


def print_me(me):
    print(me)

print("")

def add_ip(ipData):
    with open("data/data.csv", "a") as f:
        write = csv.writer(f)
        write.writerow(ipData)
