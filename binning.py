#!/usr/bin/python


import sys

import kshramt


def main(args):
    if len(args) == 2:
        bins = int(args[1])
    else:
        _usage_and_exit()
    if bins in ['-h', '--help']:
        _usage_and_exit()
    for b in kshramt.binning([float(l) for l in sys.stdin], bins):
        print('{}\t{}\t{}\t{}'.format(b['x1'], b['x2'], b['n'], b['y']))


def _usage_and_exit():
        print('# returns x1\tx2\tn\ty')
        print('{} N_BINS < NUMS'.format(sys.argv[0]))
        exit()


if __name__ == '__main__':
    main(sys.argv)
