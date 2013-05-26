#!/usr/bin/python
import numpy
import scipy.interpolate

class Slab1Data:
    """Hold Slab1.0 data"""
    def __init__(self, path, bounds_error=True, fill_value=numpy.nan):
        self.path = path
        self.points = numpy.loadtxt(path)

        xs = self.points[:, 0]
        self.x_min = xs.min()
        self.x_max = xs.max()
        ys = self.points[:, 1]
        self.y_min = ys.min()
        self.y_max = ys.max()
        zs = self.points[:, 2]
        self.__linear_interpolate = scipy.interpolate.interp2d(x=xs,
                                                               y=ys,
                                                               z=zs,
                                                               kind='linear',
                                                               bounds_error=bounds_error,
                                                               fill_value=fill_value)

    def interpolate(self, xs, ys):
        """Return interpolated values (depth, strike or dip)"""
        return numpy.diag(self.__linear_interpolate(xs, ys)).flatten() # flatten() is for a case that sx.size == ys.size == 1

if __name__ == '__main__':
    s1d = Slab1Data('./slab1_test.xyz', bounds_error=False, fill_value=numpy.nan)
    print(s1d.interpolate([0.5, 15], [0.5, 20]))
