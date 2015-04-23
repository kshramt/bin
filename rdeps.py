#!/usr/bin/python


import unittest
import sys
import json


def main(argv):
    if len(argv) == 1 or '-h' in argv or '--help' in argv:
        usage_and_exit()
    json.dump([filter_dag(dag, argv[1:]) for dag in json.load(sys.stdin)], sys.stdout)


def filter_dag(dag, targets, ret=None):
    if ret is None:
        ret = {}
    for target in targets:
        if (not (target in ret)) and (target in dag):
            deps = dag[target]
            ret[target] = deps
            filter_dag(dag, deps, ret)
    return ret


def usage_and_exit():
    print("""
{} <file1> [<file2>...] < workflow.json
    """.format(__file__), file=sys.stderr)
    exit(1)


if __name__ == '__main__':
    main(sys.argv)
