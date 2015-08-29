import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("file", help="key data")
args = parser.parse_args()
with open(args.file) as data_file:
    data = json.load(data_file)
print data['swift_keys'][0]['secret_key']
