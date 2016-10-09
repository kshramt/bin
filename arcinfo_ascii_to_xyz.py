#!/usr/bin/python


import sys


def main(argv):
    if len(argv) != 1:
        _usage_and_exit()

    ncols = int(sys.stdin.readline().split()[1])
    assert ncols > 0
    nrows = int(sys.stdin.readline().split()[1])
    assert nrows > 0
    xllcorner = float(sys.stdin.readline().split()[1])
    yllcorner = float(sys.stdin.readline().split()[1])
    cellsize = float(sys.stdin.readline().split()[1])
    nodata_value = int(sys.stdin.readline().split()[1])
    i = nrows
    x1 = xllcorner + cellsize/2
    y1 = yllcorner + cellsize/2

    header = '# -Ix{} -N{} -r -R{}/{}/{}/{}'.format(
        cellsize,
        nodata_value,
        xllcorner,
        xllcorner + ncols*cellsize,
        yllcorner,
        yllcorner + nrows*cellsize,
    )
    print(header)
    for l in sys.stdin:
        row = l.split()
        j = 1
        y = y1 + (i - 1)*cellsize
        for z in row:
            x = x1 + (j - 1)*cellsize
            print(x, '\t', y, '\t', z)
            j += 1
        assert j == ncols + 1
        i -= 1
    assert i == 0


def _usage_and_exit(s=1):
    if s == 0:
        fh = sys.stdout
    else:
        fh = sys.stderr
    print('{} < srtm.asc >| srtm.xyz'.format(__file__), file=fh)
    exit(s)


if __name__ == '__main__':
    main(sys.argv)
