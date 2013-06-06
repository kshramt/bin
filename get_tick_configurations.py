import sys
import math
import unittest
import argparse

VERSION = '0.0.0'

def _get_interval(lx):
    assert(lx > 0)
    dx = 10**(math.ceil(math.log10(lx)) - 1)
    if lx > 5*dx:
        return dx
    elif lx > 2*dx:
        return 5*dx/10
    else:
        return 2*dx/10

def _get_lower_limit(x, dx):
    assert(dx > 0)
    return math.floor(x/dx)*dx

def _get_upper_limit(x, dx):
    assert(dx > 0)
    return math.ceil(x/dx)*dx

def get_tick_configurations(x1, x2):
    x_small, x_large = sorted([x1, x2])
    dx = _get_interval(x_large - x_small)
    lower = _get_lower_limit(x_small, dx)
    upper = _get_upper_limit(x_large, dx)
    return (lower, upper, dx)

class Tester(unittest.TestCase):
    def test__get_interval(self):
        with self.assertRaises(AssertionError):
            _get_interval(-1)
        with self.assertRaises(AssertionError):
            _get_interval(0)

        lx_dx = [(1, 0.1),

                 (2, 0.2),

                 (3, 0.5),
                 (4, 0.5),
                 (5, 0.5),

                 (6, 1),
                 (7, 1),
                 (8, 1),
                 (9, 1),
                 (10, 1),

                 (11, 2),
                 (12, 2),
                 (19, 2),
                 (20, 2),

                 (21, 5),
                 (22, 5),
                 (49, 5),
                 (50, 5),

                 (51, 10),
                 (52, 10),
                 (99, 10),
                 (100, 10)]
        for lx, dx in lx_dx:
            self.assertAlmostEqual(_get_interval(lx), dx)

    def test__get_lower_limit(self):
        with self.assertRaises(AssertionError):
            _get_lower_limit(0, 0)
        with self.assertRaises(AssertionError):
            _get_lower_limit(0, -1)

        self.assertAlmostEqual(_get_lower_limit(-10, 3), -12)

    def test__get_upper_limit(self):
        with self.assertRaises(AssertionError):
            _get_upper_limit(0, 0)
        with self.assertRaises(AssertionError):
            _get_upper_limit(0, -1)

        self.assertAlmostEqual(_get_upper_limit(-10, 3), -9)

    def test_get_tick_configurations(self):
        x1, x2, dx = get_tick_configurations(101.001, 103.0001)
        self.assertAlmostEqual(x1, 101)
        self.assertAlmostEqual(x2, 103.2)
        self.assertAlmostEqual(dx, 0.2)

def main(args):
    parser = argparse.ArgumentParser(description='get pretty tick configurations')
    parser.add_argument('x1_x2',
                        metavar='NUM',
                        type=float,
                        nargs=2,
                        help= 'one of data range values')
    parser.add_argument('--test',
                        action='store_true',
                        help='run tests')
    parser.add_argument('--version',
                        action='version',
                        version='%(prog)s {version}'.format(version=VERSION))
    parsed_args = parser.parse_args(args)
    if parsed_args.test:
        unittest.main(argv=sys.argv[:1])
    else:
        output = '\t'.join(str(x) for x in get_tick_configurations(*parsed_args.x1_x2))
        print(output)

if __name__ == '__main__':
    main(sys.argv[1:])
