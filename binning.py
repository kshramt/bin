#!/usr/bin/python


import sys

import dep.kshramt_py.kshramt as kshramt


def main(args):
    x_min = None
    x_max = None
    if len(args) == 2:
        bins = int(args[1])
    elif len(args) == 4:
        bins = int(args[1])
        x_min = float(args[2])
        x_max = float(args[3])
    else:
        _usage_and_exit()
    if bins in ['-h', '--help']:
        _usage_and_exit()
    dx, bs = kshramt.binning([float(l) for l in sys.stdin], bins, x_min, x_max)
    for x1, x2, n, r in bs:
        print('\t'.join(map(str, [x1, x2, n, r, r/dx, n/dx])))


def _usage_and_exit():
        print('# returns x1\tx2\tn\tratio\tratio/dx\tn/dx', file=sys.stderr)
        print('{} <n_bins> < NUMS'.format(sys.argv[0]), file=sys.stderr)
        print('{} <n_bins> <x_min> <x_max> < NUMS'.format(sys.argv[0]), file=sys.stderr)
        exit(1)


if __name__ == '__main__':
    main(sys.argv)
