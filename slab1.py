#!/usr/bin/python
import numpy
import scipy.interpolate
import pandas


class Slab1Data(object):
    def __init__(self, path, bounds_error=False, fill_value=numpy.nan):
        def _get_knots(xs, dx):
            x_min = xs.min()
            x_max = xs.max()
            nx = round((x_max - x_min)/dx)
            return numpy.linspace(x_min, x_max, nx + 1)

        self.path = path
        self.points = pandas.read_table(path, header=None).values
        x = _get_knots(self.points[:, 0], 0.02)
        y = _get_knots(self.points[:, 1], 0.02)

        self.__linear_interpolate = scipy.interpolate.interp2d(x=x,
                                                               y=y,
                                                               z=numpy.reshape(self.points[:, 2], (y.size, x.size)),
                                                               kind='linear',
                                                               bounds_error=bounds_error,
                                                               fill_value=fill_value)

    def interpolate(self, x, y):
        """Return interpolated values (depth, strike or dip)

        Parameters
        ----------
        x, y : float, int or 1-D array (assending order)

        Returns
        -------
        Interpolated value(s)
            Size-1 1-D array of an interpolated value if x and y are float, int or size-1 1-D array.
            2-D ndarray of interpolated values on mesh(x, y) if x and y are 1-D array.
        """
        return self.__linear_interpolate(x, y)

if __name__ == '__main__':
    import numpy
    import matplotlib.pyplot
    import mpl_toolkits.mplot3d
    s1d = Slab1Data('./slab1_test.xyz')

    fig = matplotlib.pyplot.figure()
    ax = fig.add_subplot(111, projection='3d')
    x = numpy.linspace(0, 0.02)
    y = numpy.linspace(0, 0.02)
    xx, yy = numpy.meshgrid(x, y)
    ax.plot_surface(xx, yy, s1d.interpolate(x, y))
    matplotlib.pyplot.show()
