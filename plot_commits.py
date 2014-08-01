#!/usr/bin/python

import sys
import dateutil.parser

import matplotlib.dates
import pylab

times = []
adds = []
deletes = []
totals = []

for line in sys.stdin:
    time, add, delete, total = line.split()
    times.append(dateutil.parser.parse(time))
    adds.append(int(add))
    deletes.append(-int(delete))
    totals.append(int(total))

time_zone = times[0].tzinfo
fig, axes = pylab.subplots()
axes.set_xmargin(0.05)
axes.set_ymargin(0.05)
#axes.xaxis.set_major_locator(matplotlib.dates.MonthLocator(tz=time_zone))
#axes.xaxis.set_major_formatter(matplotlib.dates.DateFormatter('%m-%d'))
#axes.xaxis.set_minor_locator(matplotlib.dates.DayLocator(tz=time_zone))
axes.plot(times, adds, color='green', label='Addition')
axes.plot(times, totals, color='red', label='Total')
axes.plot(times, deletes, color='blue', label='Deletion')
axes.legend(loc='upper left')
axes.axhline(0, color='black')
axes.set_xlabel('Date')
axes.set_ylabel('Number of Lines')
fig.autofmt_xdate()

# sys.stdout returns error: TypeError: must be str, not bytes
pylab.savefig(sys.stdout.buffer, format='pdf', bbox_inches='tight')
