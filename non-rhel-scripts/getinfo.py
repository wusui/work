import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("file", help="key data")
args = parser.parse_args()
with open(args.file) as data_file:
    data = json.load(data_file)
for fld in data['keys']:
    if not fld['user'].endswith(':swift'):
        print fld['access_key']
        print fld['secret_key']
