#!/usr/bin/python

import sys
import itertools
import re

def parse_task(s):
    targets, dependencies = s.split(':', 2)
    targets = targets.split()
    dependencies = dependencies.split()

    return (targets, dependencies)

def _escape(s):
   return s.replace('%', r'\%')

def dotify(targets, dependencies):
    if len(dependencies) == 0:
        return '\n'.join('"{}"'.format(_escape(root))
                         for root
                         in targets)
    else:
        return '\n'.join('"{}" -> "{}"'.format(_escape(root), _escape(child))
                         for root, child
                         in itertools.product(targets, dependencies))

def is_task_line(line):
    return (re.match(r'^[a-zA-Z0-9_\-./%{}$()]+(\ [a-zA-Z0-9_\-./%{}$()]+)*:', line)
            and all(not line.startswith(special)
                    for special
                    in ['.SUFFIXES',
                        '.DELETE_ON_ERROR',
                        '.PRECIOUS']))

def main():
    print('digraph Workflow{')
    print('node [shape=note]')
    print('\n'.join(map(lambda s: dotify(*parse_task(s)),
                        filter(lambda line: is_task_line(line),
                               sys.stdin.readlines()))))
    print('}')

if __name__ == '__main__':
    main()
