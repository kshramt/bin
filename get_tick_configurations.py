import sys
import argparse

from dep.kshramt_py.kshramt import get_tick_configurations


__version__ = '0.0.0'


def main(args):
    parser = argparse.ArgumentParser(description='get pretty tick configurations')
    parser.add_argument('x1_x2',
                        metavar='NUM',
                        type=float,
                        nargs=2,
                        help='data range values')
    parser.add_argument('--version',
                        action='version',
                        version='%(prog)s {version}'.format(version=__version__))
    parsed_args = parser.parse_args(args)
    output = '\t'.join(str(x) for x in get_tick_configurations(*parsed_args.x1_x2))
    print(output)

if __name__ == '__main__':
    main(sys.argv[1:])
