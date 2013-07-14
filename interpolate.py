import sys
import itertools
import argparse

import numpy
import scipy.interpolate

__version__ = '0.0.0'


def main(args):
    parser = argparse.ArgumentParser(description='interpolate 2D data from stdin')
    parser.add_argument('--version',
                        action='version',
                        version='%(prog)s {version}'.format(version=__version__))
    parser.add_argument('--method',
                        default='nearest',
                        help='interpolate method nearest|linear|cubic [nearest]')
    parser.add_argument('--print_intervals',
                        action='store_true',
                        help='print x and y intervals and exit')
    parser.add_argument('--fill_value',
                        type=float,
                        default=numpy.nan,
                        help='value out side of a convex hull of given points [nan]')
    parser.add_argument('--nx',
                        type=int,
                        default=150,
                        help='number of grids in x direction')
    parser.add_argument('--ny',
                        type=int,
                        default=150,
                        help='number of grids in y direction')
    parser.add_argument('--x_lower',
                        type=float,
                        default=None,
                        help='lower value of a x range of an interporated region')
    parser.add_argument('--x_upper',
                        type=float,
                        default=None,
                        help='upper value of a x range of an interporated region')
    parser.add_argument('--y_lower',
                        type=float,
                        default=None,
                        help='lower value of a y range of an interporated region')
    parser.add_argument('--y_upper',
                        type=float,
                        default=None,
                        help='upper value of a y range of an interporated region')
    parsed_args = parser.parse_args(args)

    xyz_data = numpy.loadtxt(sys.stdin)
    if parsed_args.x_lower is None:
        x_lower = xyz_data[:, 0].min()
    else:
        x_lower = parsed_args.x_lower
    if parsed_args.x_upper is None:
        x_upper = xyz_data[:, 0].max()
    else:
        x_upper = parsed_args.x_upper
    if parsed_args.y_lower is None:
        y_lower = xyz_data[:, 1].min()
    else:
        y_lower = parsed_args.y_lower
    if parsed_args.y_upper is None:
        y_upper = xyz_data[:, 1].max()
    else:
        y_upper = parsed_args.y_upper

    assert(parsed_args.nx >= 2)
    assert(parsed_args.ny >= 2)
    xs = numpy.linspace(x_lower, x_upper, parsed_args.nx)
    ys = numpy.linspace(y_lower, y_upper, parsed_args.ny)

    if parsed_args.print_intervals:
        output = '\t'.join([str(xs[1] - xs[0]), str(ys[1] - ys[0])])
        print(output)
        sys.exit()

    xys = numpy.ndarray(shape=(parsed_args.nx*parsed_args.ny, 2),
                        dtype=float)
    for ix, x in enumerate(xs):
        for iy, y in enumerate(ys):
            xys[ix*parsed_args.ny + iy, :] = (x, y)

    zs = scipy.interpolate.griddata(xyz_data[:, 0:2], xyz_data[:, 2], xys,
                                    method=parsed_args.method,
                                    fill_value=parsed_args.fill_value)
    for ixy in range(len(xys)):
        output = '\t'.join(str(x) for x in (xys[ixy, 0], xys[ixy, 1], zs[ixy]))
        print(output)

if __name__ == '__main__':
    main(sys.argv[1:])
