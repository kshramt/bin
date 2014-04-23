#!/usr/bin/python

import sys
import json


def main(args):
    _parse_args(args)
    for l in sys.stdin:
        if l.startswith('# Make data base, printed on '):
            json.dump(_parse_db(sys.stdin), sys.stdout)
            sys.exit(0)

def _parse_db(fp):
    for l in fp:
        if l.startswith('# Files'):
            fp.readline() # skip the first empty line
            return _parse_entries(fp)


def _parse_entries(fp):
    deps_tree = {}
    for l in fp:
        if l.startswith('# files hash-table stats:'):
            return deps_tree
        elif l.startswith('# Not a target:'):
            _skip_until_next_entry(fp)
        else:
            _parse_entry(l, deps_tree)
            _skip_until_next_entry(fp)


def _parse_entry(l, deps_tree):
    target, deps = l.split(':', 2)
    deps_tree[target] = [dep for dep in deps.split() if dep != '|']


def _skip_until_next_entry(fp):
    for l in fp:
        if _is_new_entry(l):
            return


def _is_new_entry(s):
    return s.startswith('\n')


def _parse_args(args):
    if len(args) != 1:
        print("# parse Makefile's data base and print dependency graph in dot format")
        print("LANG=C gmake all test --dry-run --print-data-base | {} | json_to_dot.py | dot -Tpdf >| workflow.pdf".format(args[0]))
        sys.exit(1)


if __name__ == '__main__':
    main(sys.argv)
