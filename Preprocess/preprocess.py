#! /usr/bin/env python3.6
'''
    Author      : Coslate
    Date        : 2018/06/04
    Description :
        This program will do the preprocessing of the ptt articles used for word2vec.
        1. It will remove the redundant messages like 發信站:, 作者:, 文章網址:, 時間:, '--'.
        2. It will remove the author name of the upvote or downvote in an article.
        One can input the parameter -file {file_name} to do the preprocessing of {file_name}
        One can input the parameter -odir {directory} to output the preprocessed file in the directory
        with the name 'file_name.preprocessed'
'''
from os import listdir
from os.path import isfile, join
from os.path import basename
import argparse
import operator
import re

#########################
#     Main-Routine      #
#########################
def main():
    (file_name, out_dir) = ArgumentParser()
    abs_file_name = basename(file_name)

    with open('{x}'.format(x = file_name), 'r') as in_file:
        lines = in_file.read().splitlines()

    with open('{y}/{x}'.format(x = abs_file_name+'.preprocessed', y = out_dir), 'w') as out_file:
        for line in lines:
            #Remove redundant messages.
            if((re.match(r'.*※ 發信站:.*', line)) or (re.match(r'.*※ 文章網址:.*', line))
               or (re.match(r'.*作者:.*', line)) or (re.match(r'.*時間:.*', line))
               or (re.match(r'^--\s$', line)) or (re.match(r'^作者.*', line))
               or (re.match(r'.*※\s*\[\s*本文\s*轉錄\s*自\s*.*\s*看\s*板.*\]\s*', line))):
                continue
            #Extract only the content of the upvote/downvote.
            m = re.match(r'\S+\s*\S+\s*\:(.*?)\s*\d+\/\d+\s*\d+\:\d+\s*', line)
            if(m):
                out_file.write("{a}\n".format(a = m.groups()[0]))
            else:
                out_file.write("{a}\n".format(a = line))

#########################
#     Sub-Routine       #
#########################
def ArgumentParser():
    file_name = ""
    out_dir   = ""

    parser = argparse.ArgumentParser()
    parser.add_argument("--file_name", "-file", help="The name of the file to do the preprocessing.")
    parser.add_argument("--out_dir", "-odir", help="The name of the file to do the preprocessing.")

    args = parser.parse_args()
    if args.file_name:
        file_name = args.file_name

    if args.out_dir:
        out_dir = args.out_dir

    return (file_name, out_dir)

#---------------Execution---------------#
if __name__ == '__main__':
    main()
