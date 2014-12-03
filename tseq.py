#!/usr/bin/python

import sys
import datetime


def main(argv):
    if len(argv) != 14:
        print('# `seq` command for time', file=sys.stderr)
        print('{} year1 month1 day1 hour1 min1 sec1 delta_sec year2 month2 day2 hour2 min2 sec2'.format(__file__), file=sys.stderr)
        exit(1)

    y1, m1, d1, H1, M1, S1, dS, y2, m2, d2, H2, M2, S2 = map(int, argv[1:])
    t = datetime.datetime(y1, m1, d1, H1, M1, S1)
    dt = datetime.timedelta(seconds=dS)
    t_end = datetime.datetime(y2, m2, d2, H2, M2, S2)
    while t <= t_end:
        print(t.strftime('%Y\t%m\t%d\t%H\t%M\t%S'))
        t += dt


if __name__ == '__main__':
    main(sys.argv)
