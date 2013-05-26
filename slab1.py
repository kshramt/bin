#!/usr/bin/python
import numpy
import scipy.interpolate

class Slab1Data:
    def __init__(self, path, bounds_error=True, fill_value=numpy.nan):
        self.path = path
        self.points = numpy.loadtxt(path)

        self.__linear_interpolate = scipy.interpolate.interp2d(x=self.points[:, 0],
                                                               y=self.points[:, 1],
                                                               z=self.points[:, 2],
                                                               kind='linear',
                                                               bounds_error=bounds_error,
                                                               fill_value=fill_value)

    def interpolate(self, xs, ys):
        """Return interpolated values (depth, strike or dip)"""
        return numpy.diag(self.__linear_interpolate(xs, ys)).flatten() # flatten() is for a case that sx.size == ys.size == 1

if __name__ == '__main__':
    s1d = Slab1Data('./slab1_test.xyz', bounds_error=False, fill_value=numpy.nan)
    print(s1d.interpolate([0.5, 15], [0.5, 20]))
