#!/usr/bin/python


import sys

import dep.kshramt_py.kshramt as kshramt


def main(args):
    if len(args) == 2:
        bins = int(args[1])
    else:
        _usage_and_exit()
    if bins in ['-h', '--help']:
        _usage_and_exit()
    dx, bs = kshramt.binning([float(l) for l in sys.stdin], bins)
    for x1, x2, n, r in bs:
        print('\t'.join(map(str, [x1, x2, n, r, r/dx, n/dx])))


def _usage_and_exit():
        print('# returns x1\tx2\tn\ty')
        print('{} N_BINS < NUMS'.format(sys.argv[0]))
        exit()


if __name__ == '__main__':
    main(sys.argv)
