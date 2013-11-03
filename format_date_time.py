#!/usr/bin/python

import sys
import datetime
import unittest
import argparse
import signal

import kshramt


__version__ = '0.0.0'


def _parse_zero_or_pos_int(s):
    n = int(s)
    assert n >= 0
    return n


def _chomp(s):
    if s.endswith('\n'):
        s = s[:-1]

    return s

def _convert(s, column, columns, input_format, output_format, delta):
    assert column >= 1 and all(i >= 1 for i in columns)

    if any(i == column for i in columns):
        dd = datetime.datetime
        return dd.strftime(dd.strptime(s, input_format) + delta,
                           output_format)
    else:
        return s


def _parse_arguments(args=sys.argv[1:]):
    parser = argparse.ArgumentParser(description='convert date time format')
    parser.add_argument('--input',
                        required=True,
                        help='input date time format')
    parser.add_argument('--output',
                        default='%Y-%m-%dT%H:%M:%S.%f%z',
                        help='output date time format [%(default)s]')
    parser.add_argument('--columns',
                        type=lambda s: [int(n) for n in s.split(',')],
                        default=[1],
                        help='columns to be converted [%(default)s]')
    parser.add_argument('--header',
                        type=_parse_zero_or_pos_int,
                        default=0,
                        help='number of rows to skip [%(default)s]')
    parser.add_argument('--delta',
                        type=lambda s: datetime.timedelta(seconds=float(s)),
                        default=datetime.timedelta(seconds=0),
                        help='time delta to add in seconds [%(default)s]')
    parser.add_argument('--test',
                        action=kshramt.TestAction,
                        help='run tests')
    parser.add_argument('--version',
                        action='version',
                        version='%(prog)s {version}'.format(version=__version__))

    return parser.parse_args(args)

def main(args=sys.argv[1:]):
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    parsed_args = _parse_arguments(args)
    columns = parsed_args.columns

    for _ in range(parsed_args.header):
        line = sys.stdin.readline()
        if not line:
            return

        print(_chomp(line))

    while True:
        line = sys.stdin.readline()
        if not line:
            break

        words = _chomp(line).split('\t')
        assert len(words) >= max(columns) and all(i >= 1 for i in columns)

        output = '\t'.join(_convert(s=word,
                                    column=i + 1,
                                    columns=columns,
                                    input_format=parsed_args.input,
                                    output_format=parsed_args.output,
                                    delta=parsed_args.delta)
                           for i, word
                           in enumerate(words))
        try:
            print(output)
        except BrokenPipeError:
            return


class _Tester(unittest.TestCase):
    def test__convert(self):
        params = [('2013-02-02', ('2013-02-01', 1, [1], '%Y-%m-%d', '%Y-%m-%d', datetime.timedelta(seconds=24*60*60))),
                  ('2013-02-01', ('2013-02-01', 1, [2], '%Y-%m-%d', '%Y-%m-%d', datetime.timedelta(seconds=24*60*60))),
                  ('2013/03', ('2013-02-03', 1, [1], '%Y-%m-%d', '%Y/%d', datetime.timedelta(seconds=0)))]
        for expected, (input_, column, columns, input_format, output_format, delta) in params:
            self.assertEqual(expected, _convert(s=input_,
                                                column=column,
                                                columns=columns,
                                                input_format=input_format,
                                                output_format=output_format,
                                                delta=delta))

        with self.assertRaises(AssertionError):
            _convert(s='2013-02-01',
                     column=0,
                     columns=[1],
                     input_format='%Y-%m-%d',
                     output_format='%Y',
                     delta=datetime.timedelta(seconds=0))

        with self.assertRaises(AssertionError):
            _convert(s='2013-02-01',
                     column=1,
                     columns=[1, 2, 0],
                     input_format='%Y-%m-%d',
                     output_format='%Y',
                     delta=datetime.timedelta(seconds=0))


if __name__ == '__main__':
    main(sys.argv[1:])
