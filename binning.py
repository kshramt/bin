#!/usr/bin/python


import unittest
import sys
# import re
# import pickle

import numpy as np
# import scipy as sp
# import matplotlib.pyplot as plt
# import pandas as pd

import kshramt


def main(args):
    if len(args) == 2:
        bins = args[1]
    else:
        _usage_and_exit()
    if bins == '--test':
        unittest.main(argv=[args[0]])
    if bins in ['-h', '--help']:
        _usage_and_exit()
    for b in binning([float(l) for l in sys.stdin], int(bins)):
        print('{}\t{}\t{}\t{}'.format(b['x1'], b['x2'], b['n'], b['y']))


def _usage_and_exit():
        print('# returns x1\tx2\tn\ty')
        print('{} N_BINS < NUMS'.format(sys.argv[0]))
        exit()


def binning(xs, bins):
    assert bins >= 1
    n_xs = len(xs)
    assert n_xs
    if n_xs == 1:
        x_min = xs[0] - 1/2
        x_max = xs[0] + 1/2
    else:
        x_min, x_max = _min_max(xs)
    dx = (x_max - x_min)/bins
    assert 0 < max(abs(x_min), abs(x_max))*sys.float_info.epsilon <= dx
    ns = [0 for _ in range(bins)]
    for x in xs:
        fi_bin = (x - x_min)/dx
        i_bin = int(fi_bin)
        if fi_bin != i_bin:
            ns[i_bin] += 1
        elif i_bin <= 0:
            ns[0] += 1
        elif i_bin >= bins:
            ns[-1] += 1
        else:
            ns[i_bin] += 1/2
            ns[i_bin - 1] += 1/2
    return [{'x1': x1,
             'x2': x2,
             'n': n,
             'y': n/n_xs/dx}
            for (x1, x2), n
            in zip(kshramt.each_cons(np.linspace(x_min, x_max, bins + 1), 2), ns)]


def _min_max(xs):
    assert xs
    min_ = max_ = xs[0]
    for x in xs[1:]:
        if x > max_:
            max_ = x
        elif x < min_:
            min_ = x
    return min_, max_


class _Tester(unittest.TestCase):

    def test_binning(self):
        bins = 10
        bs = binning([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], bins)
        b0 = bs[0]
        self.assertAlmostEqual(b0['x1'], 0)
        self.assertAlmostEqual(b0['x2'], 1)
        self.assertAlmostEqual(b0['n'], 1.5)
        self.assertAlmostEqual(b0['y'], 1.5/11)
        bbins = bs[-1]
        self.assertAlmostEqual(bbins['x1'], 9)
        self.assertAlmostEqual(bbins['x2'], 10)
        self.assertAlmostEqual(bbins['n'], 1.5)
        self.assertAlmostEqual(bbins['y'], 1.5/11)
        for i, b in enumerate(bs[1:bins-1]):
            self.assertAlmostEqual(b['x1'], i + 1)
            self.assertAlmostEqual(b['x2'], i + 2)
            self.assertAlmostEqual(b['n'], 1)
            self.assertAlmostEqual(b['y'], 1/11)


if __name__ == '__main__':
    main(sys.argv)
