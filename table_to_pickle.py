#!/usr/bin/python

"""
The first line should be a header.


```
time	amplitude
2014-05-24T23:52:14.132	2.5
2014-05-24T23:52:15.23	-3.2
2014-05-24T23:52:18.332	0.25
```
"""


import sys
import dateutil.parser
import pickle

import pandas


def main(date_columns=[], in_=sys.stdin, out=sys.stdout.buffer):
    pickle.dump(pandas.read_table(in_,
                                  parse_dates=date_columns,
                                  # Need to specify date_parser to keep time zone information.
                                  date_parser=dateutil.parser.parse),
                file=out)


if __name__ == '__main__':
    main([int(n) for n in sys.argv[1:]])
