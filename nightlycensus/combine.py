"""
Combine the data/*.yaml files into one giant yaml
"""
import os
from os import listdir
import yaml


def doit():
    """
    Output will be in all.yaml
    """
    total = {}
    for ymlf in listdir('data'):
        filep = os.path.join('data', ymlf)
        with open(filep) as yfile:
            info = yaml.safe_load(yfile)
            for entry in info:
                if entry in total:
                    total[entry] += info[entry]
                else:
                    total[entry] = info[entry]
    with open('combine.yaml', 'w') as yaml_file:
        yaml_file.write(yaml.safe_dump(total, default_flow_style=False))

if __name__ == '__main__':
    doit()
