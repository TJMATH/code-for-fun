# !/usr/bin/python

import math
import numpy as np
import matplotlib.pyplot as plt

def getOptionPriceAtTimeT(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100):
    '''
    To get the option price at time 0.
    Everytime you call this function, you will get one test.
    '''
    St = S0
    dt = 1.0 * T / steps
    dWt = np.random.normal(0, dt, steps)
    for i in xrange(100):
        sigma = 0.17 * math.exp(-0.004 * St - 1.6667 * i * dt)
        dSt = St * (r * dt + sigma * dWt[i])
        St = St + dSt
    return (St - K)**2 * math.exp(- r * T)

def gExpOptPriAndConInt(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100, alpha = 0.95):
    '''
    This function should be named as getOptionPriceAndConfidenceInterval,
    but it is too long to read.
    Try to test 100,000 times, and find the shortest interval as confidence interval.
    Also, treat the average of the 100,000 test as the final result.
    '''
    STs = []
    N = 100000
    for i in xrange(N):
        ST = getOptionPriceAtTimeT(S0 = S0, K = K, r = r, T = T, steps = steps)
        STs.append(ST)
    STs.sort()
    ua = int(round(N * alpha))
    width = 2 << 20  # = 2^21
    for j in xrange(N - ua):
        d = STs[j + ua] - STs[j]
        if d < width:
            width = d
            Confidence = [STs[j], STs[j + ua]]
    E = np.mean(STs)
    std = np.std(STs)
    # plt.hist(STs, 1000)
    # plt.show()
    return [E, width, std * 3.92, Confidence]

def getGamma(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100, alpha = 0.95):
    '''
    Cuz the error is O(h^2), we set h = 0.03 to ensure that the error is less than 0.01.
    Compute the Option value n times by using S0 = 249.97, 250, and 250.03, then
    we will get n^3 gammas.
    '''
    h = 0.03
    S = []
    n = 47
    for i in xrange(3):
        s = []
        S0 = S0 + h * (i - 1)
        for j in xrange(n):
            E = gExpOptPriAndConInt(S0 = S0, K = K, r = r, T = T, steps = steps)[0]
            s.append(E)
        S.append(s)
    Gamma = []
    for i in S[0]:
        for j in S[1]:
            for k in S[2]:
                Gamma.append((i + k - 2 * j)/(h * h))
    Gamma.sort()
    ua = int(round(n**3 * alpha))
    width = 2 << 20  # = 2^21
    for j in xrange(n**3 - ua):
        d = Gamma[j + ua] - Gamma[j]
        if d < width:
            width = d
            Confidence = [Gamma[j], Gamma[j + ua]]
    E = np.mean(Gamma)
    std = np.std(Gamma)
    plt.hist(Gamma, 50)
    plt.show()
    return [E, width, std * 3.92, Confidence]

if __name__ == '__main__':
    [E, width, width2, Confidence] = gExpOptPriAndConInt()
    print '--------------------------Result of Option---------------------------'
    print 'Expceted value: %s'%E
    print 'The width of confidence interval: %s'%width
    print 'The width of confidence interval(using Normal hypothesis): %s'%width2
    print 'Confidence interval: %s'%Confidence
    print '---------------------------------------------------------------------\n'
    [gE, gwidth, gwidth2, gConfidence] = getGamma()
    print '--------------------------Result of Gamma----------------------------'
    print 'Expceted value: %s'%gE
    print 'The width of confidence interval: %s'%gwidth
    print 'The width of confidence interval(using Normal hypothesis): %s'%gwidth2
    print 'Confidence interval: %s'%gConfidence
    print '---------------------------------------------------------------------'
