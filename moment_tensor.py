import sys

import numpy

class Mrtf(object):
    def __init__(self, rr, tt, ff, rt, rf, tf):
        self.rr = rr
        self.tt = tt
        self.ff = ff
        self.rt = rt
        self.rf = rf
        self.tf = tf

def mw_from_m0(m0):
    return (numpy.log10(m0) - 9.1)/1.5

def log10_m0_from_mw(mw):
    return 1.5*mw + 9.1

def m0_from_mw(mw):
    return 10**(1.5*mw + 9.1)

def mrtf_matrix_from_mrtf(m):
    mrtf_matrix = numpy.ndarray(shape=(3, 3),
                                dtype=float)
    mrtf_matrix[0, :] = [m.rr, m.rt, m.rf]
    mrtf_matrix[1, :] = [m.rt, m.tt, m.rf]
    mrtf_matrix[2, :] = [m.rf, m.rf, m.ff]
    return mrtf_matrix

def mrtf_from_m_1_to_5(m_1_to_5):
    return Mrtf(rr = m_1_to_5[4],
                tt = m_1_to_5[1] - m_1_to_5[4],
                ff = -m_1_to_5[1],
                rt = m_1_to_5[3],
                rf = -m_1_to_5[2],
                tf = -m_1_to_5[0])

def mrtf_matrix_from_m_1_to_5(m_1_to_5):
    return mrtf_matrix_from_mrtf(mrtf_from_m_1_to_5(m_1_to_5))

def moment_from_m_1_to_5(m_1_to_5):
    eigs = numpy.linalg.eigvalsh(mrtf_matrix_from_m_1_to_5(m_1_to_5))
    return (eigs.max() - eigs.min())/2

def linear_transform(x, x0, x1, y0, y1):
    lx = x1 - x0
    if numpy.any(numpy.abs(lx) < 1/sys.float_info.max):
        raise ValueError('X range too small')
    return (x - x0)/lx*(y1 - y0) + y0

def get_psmeca_sm_moment(values):
    MW_MAX = 5

    values_min = numpy.min(values)
    assert(values_min >= 0)
    values_max = numpy.max(values)
    mw_min = (values_min/values_max)*MW_MAX

    if(mw_min < MW_MAX):
        mws = linear_transform(values, values_min, values_max, mw_min, MW_MAX)
    else:
        mws = numpy.ndarray(shape=numpy.shape(values),
                            dtype=float)
        mws = mw_min

    log10_m0s = log10_m0_from_mw(mws)
    exponents = numpy.floor(log10_m0s)
    coefficients = 10**(log10_m0s - exponents)
    exponents += 7 # GMT psmeca uses dyne-cm instead of Nm.
    assert(numpy.max(exponents) == 23)
    assert(numpy.min(exponents) >= 16)
    return dict(coefficients=coefficients,
                exponents=exponents)
