#!/usr/bin/python

import sys
import json


def main(args):
    _parse_args(args)
    print("""
digraph{
   graph [rankdir=LR]
   node [shape=box, style=filled]
    edge [color="#00000011"]
    """)
    for target, deps in json.load(sys.stdin).items():
        target_str = _escape(target)
        deps_str = [_escape(dep) for dep in deps]
        print(target_str)
        for dep_str in deps_str:
            print(dep_str)
            print('{} -> {}'.format(target_str, dep_str))
    print("}")


def _escape(s):
    return '"{}"'.format(s.replace('"', r'\"'))


def _parse_args(args):
    if len(args) != 1:
        print('# convert tree in json format to dot format')
        print('{} < deps.json | dot -Tpdf >| workflow.pdf'.format(args[0]))
        sys.exit(1)


if __name__ == '__main__':
    main(sys.argv)
