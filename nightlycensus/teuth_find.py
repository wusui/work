"""
Find tasks in past runs.
"""
from datetime import date
from datetime import timedelta
import os.path
from os import listdir
import re
import yaml

BASEDIR = '/a'


def gen_past_date(numb, scandate):
    """
    Return a date of the form 2014-05-15 for
    each call.

    :param numb: number of days to scan for.
    :param scandate: last date in set of days.
    """
    strt = scandate - timedelta(numb - 1)
    while not strt > scandate:
        yield strt.isoformat()
        strt += timedelta(1)


def gen_run_list(days, scandate):
    """
    Return a list of /a files whose dates are within the
    day range specified.

    :param days: number of days to scan for.
    :param scandate: last date in set of days.
    """
    ret_list = []
    day_list = [x for x in gen_past_date(days, scandate)]
    runz = listdir(BASEDIR)
    pattern = re.compile('(\w+)\-(.*)_')
    for a_rundir in runz:
        scanned = (pattern.match(a_rundir))
        if not scanned:
            continue
        if scanned.group(2) in day_list:
            ret_list.append(a_rundir)
    return ret_list


def extract_yaml(file_name):
    """
    Extract the yaml file from the log specified by file_name
    """
    with open(file_name, 'r') as in_file:
        str1 = in_file.read()
    brk_pt = str1.find('INFO:teuthology.run_tasks:Running task')
    str1 = str1[0:brk_pt]
    pts = str1.split('\n')
    assemble = []
    for line in pts:
        if line.startswith('20'):
            continue
        assemble.append(line)
    yaml_d = '\n'.join(assemble)
    if yaml_d.startswith('Traceback'):
        return
    if yaml_d.startswith('{description:'):
        return
    if yaml_d.strip().startswith('<'):
        return
    ctx = yaml.safe_load(yaml_d)
    if not ctx:
        return
    if 'tasks' in ctx:
        olist = []
        for tsk in ctx['tasks']:
            olist.append(tsk.keys()[0])
        return olist
    return


def get_tasks(days, scandate):
    """
    Get all the tasks that have run in the given time frame.

    :param days: number of days to scan for.
    :param scandate: last date in set of days.
    """
    runs = gen_run_list(days, scandate)
    for dirname in runs:
        dpath = os.path.join(BASEDIR, dirname)
        test_list = listdir(dpath)
        run_list = [x for x in test_list if x.isdigit()]
        for indv_run in run_list:
            log_path = os.path.join(dpath, indv_run, 'teuthology.log')
            yamdata = extract_yaml(log_path)
            if yamdata:
                yield yamdata


def find_tasks(days, scandate):
    """
    Find all the tasks for the jobs run on the days specified.

    :param days: number of days to scan for.
    :param scandate: last date in set of days.
    """
    counters = {}
    for tasks in get_tasks(days, scandate):
        for task in tasks:
            if task in counters:
                counters[task] += 1
            else:
                counters[task] = 1
    return counters


def gather_info(days, scandate=date.today()):
    """
    Write collected task data onto files in the data directory.
    Each file is a yaml file whose entries are of the form
    'task: number' where the number is a count of the number
    of times that task was run.  Each yaml file represents a
    days worth of data.

    :param days: number of days to scan for.
    :param scandate: last date in set of days.
    """
    for datev in gen_past_date(days, scandate):
        print datev
        int_d = [int(x) for x in datev.split('-')]
        counts = find_tasks(1, date(int_d[0], int_d[1], int_d[2]))
        print counts
        fname = os.path.join('data', "{}.yaml".format(datev))
        with open(fname, 'w') as yaml_file:
            yaml_file.write(yaml.safe_dump(counts, default_flow_style=False))


if __name__ == '__main__':
    gather_info(7)
