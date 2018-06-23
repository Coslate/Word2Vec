#! /usr/bin/env python3.6
from os import listdir
from os import system
from os.path import isfile, join
from os.path import basename
from pathlib import Path
import argparse
import operator
import subprocess
import os
import re
import sys


corpus_dir = './test_mv_dir'
all_files = os.listdir(corpus_dir)

for file_examine in all_files:
    file_examine_origin = file_examine
    file_examine = file_examine.replace('-', '_')
    file_examine = file_examine.replace('>', '_')
    file_examine = file_examine.replace('$', '_')
    file_examine = file_examine.replace('(', '_')
    file_examine = file_examine.replace(')', '_')

    print(f'file_examine_origin = {file_examine_origin}')
    print(f'file_examine = {file_examine}')

    os.rename('{y}/{x}'.format(y=corpus_dir, x=file_examine_origin), '{y}/{b}'.format(y=corpus_dir, b=file_examine))
#    os.system('rm -rf {y}/{x}'.format(x=file_examine_origin, y=corpus_dir))
#    subprocess.getoutput('rm -rf {y}/{x}'.format(x='123', y = corpus_dir))
#    subprocess.getoutput('rm -rf {y}/{x}'.format(x=file_examine_origin, y=corpus_dir))
#    subprocess.getoutput('mv {y}/{x} {y}/{b}'.format(x=file_examine_origin, y=corpus_dir, b=file_examine))
