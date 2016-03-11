#!/usr/bin/python


import unittest
import os
import sys


def main(argv):
    if len(argv) != 3:
        usage_and_exit()
    qs = argv[1].split()
    n = int(argv[2])
    if not qs:
        return
    qs = repeat('*', n) + qs + repeat('*', n)
    query = parse_query(qs)
    for ws in each_cons(tokenize(sys.stdin), len(qs)):
        if(query(ws)):
            print(' '.join(ws))


def tokenize(fh):
    for line in fh:
        yield from _tokenize(line)


def _tokenize(s):
    return s.lower()\
            .replace(':', ' : ')\
            .replace('\;', ' ; ')\
            .replace('!', ' ! ')\
            .replace('?', ' ? ')\
            .replace('"', ' " ')\
            .replace('(', ' ( ')\
            .replace(')', ' ) ')\
            .replace(',', ' , ')\
            .replace('.', ' . ')\
            .split()


def parse_query(qs):
    indices = []
    for i, q in enumerate(qs):
        if q != '*':
            indices.append(i)

    # following code is not faster
    # return lambda ws: all(ws[i] == _qs[i] for i in indices)
    def query(ws):
        for i in indices:
            if ws[i] != qs[i]:
                return False
        return True
    return query



def repeat(x, n):
    return [x for _ in range(n)]


def each_cons(xs, n):
    assert n >= 1
    return _each_cons_iter(iter(xs), n)


def _each_cons_iter(xs, n):
    ret = []
    for _ in range(n):
        ret.append(next(xs))
    yield ret
    for x in xs:
        ret = ret[1:]
        ret.append(x)
        yield ret


def usage_and_exit(s=1):
    print('{} <"* insar * is not * * *"> <n> < <data.txt>'.format(__file__), file=sys.stderr)
    exit(s)


if __name__ == '__main__':
    main(sys.argv)
