#!/usr/bin/python

"""Makefile to Dot

# Note

Only a simple Makefile can be parsed.
"""


import sys
import re
import argparse
import unittest

from kshramt import TestAction, list_2d, flatten


__version__ = '0.0.0'


class Graph(object):
    """Fixed size static graph structure.
    """

    def __init__(self, pairs):
        """All data should be included in pairs since you can't update.

        pairs - (((parent1),          (child11, child12, ...)),
                 ((parent2),          (child21, child22, ...)),
                 ((parent1, parent3), (child11, child13, ...)),
                 ...)
        """

        super().__init__()

        self.nodes = tuple(set(flatten(pairs)))

        n_nodes = len(self.nodes)
        self._matrix = list_2d(n_nodes, n_nodes)

        for pair in pairs:
            parents, children = pair
            for parent in parents:
                i_parent = self.nodes.index(parent)
                for child in children:
                    i_child = self.nodes.index(child)
                    self._matrix[i_parent][i_child] = True

    def pairs(self):
        """Return a generator which yields all parent-child pairs
        """
        for i_parent, parent in enumerate(self.nodes):
            for i_child, child in enumerate(self.nodes):
                if self._matrix[i_parent][i_child]:
                    yield (parent, child)


class _Tester(unittest.TestCase):
    def test_Graph_pairs(self):
        self.assertEqual(sorted(Graph((((1,), (2, 3)),
                                       ((1,), (4, 5)),
                                       ((1, 2), (2, 1)),
                                       ((2,), (2, 3)),
                                       ((7,), ()))).pairs()),
                         sorted(((1, 1),
                                 (1, 2),
                                 (1, 3),
                                 (1, 4),
                                 (1, 5),
                                 (2, 1),
                                 (2, 2),
                                 (2, 3))))


def dot_from_makefile(s):
    graph = Graph([parse_task(l)
                   for l
                   in s.split('\n')
                   if is_task_line(l)])

    return '\n'.join(['''digraph Workflow{
                           rankdir=LR
                           node [shape=note, style=filled]
                           edge [color=gray]''',
                      '\n'.join(_decorate_node('"{}"'.format(_escape(node)))
                                for node
                                in graph.nodes),
                      '\n'.join('"{}" -> "{}"'.format(_escape(parent),
                                                      _escape(child))
                                for parent, child
                                in graph.pairs()),
                      '}'])


def parse_task(s):
    targets, dependencies = s.split(':', 1)
    targets = targets.split()
    dependencies = dependencies.split()

    return (targets, dependencies)


def is_task_line(line):
    return (re.match(r'^[a-zA-Z0-9_\-./%{}$()]+(\ [a-zA-Z0-9_\-./%{}$()]+)*:', line)
            and all(not line.startswith(special)
                    for special
                    in ['.SUFFIXES',
                        '.DELETE_ON_ERROR',
                        '.ONESHELL',
                        '.EXPORT_ALL_VARIABLES',
                        '.NOTPARALLEL',
                        '.SECONDARY',
                        '.POSIX',
                        '.PRECIOUS']))


def _decorate_node(s):
    prop = ''
    if re.search(r'/?\${HOME}/', s):
        prop = '[fillcolor="#ddddff"]'
    elif re.search(r'/?bin/', s):
        prop = '[fillcolor=pink]'
    elif re.search(r'/?template/', s):
        prop = '[fillcolor=orange]'
    elif re.search(r'/?report/', s):
        prop = '[fillcolor="#aaffaa"]'
    elif re.search(r'/?doc/', s):
        prop = '[fillcolor="#aaffaa"]'
    elif re.search(r'/?tmp/', s):
        prop = '[fillcolor=yellow]'
    elif re.search(r'/?work/', s):
        prop = '[fillcolor=orange]'
    elif re.search(r'/?data/', s):
        prop = '[fillcolor=orange]'
    elif re.search(r'/?Makefile', s):
        prop = '[fillcolor=orange]'

    return '{} {}'.format(s, prop)


def _escape(s):
   return s.replace('%', r'\%')


def _parse_arguments(args=sys.argv[1:]):
    parser = argparse.ArgumentParser(description='Read a simple Makefile and write a dot file')
    parser.add_argument('--test',
                        action=TestAction,
                        help='run tests')
    parser.add_argument('--version',
                        action='version',
                        version='%(prog)s {version}'.format(version=__version__))

    return parser.parse_args(args)


def main(args=sys.argv[1:]):
    _parse_arguments(args)

    print(dot_from_makefile(sys.stdin.read()))


if __name__ == '__main__':
    main(sys.argv[1:])
