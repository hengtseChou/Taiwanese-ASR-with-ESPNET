import csv
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("test_dir", type=str)
args = parser.parse_args()
test_dir = args.test_dir

with open(os.path.join(test_dir, "text"), "r") as text_f, open(
    "submission.csv", "w", encoding='UTF8'
) as csv_file:
    lines = text_f.read()
    lines = lines.rstrip("\n").split("\n")
    
    writer = csv.writer(csv_file)
    writer.writerow(["id","sentence"])
    for line in lines:
        line = line.split()
        writer.writerow([line[0], " ".join(line[1:])])