# !/usr/bin/python

import math
import numpy as np
import matplotlib.pyplot as plt

def getOptionPriceAtTimeT(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100, seed = 0):
    '''
    To get the option price at time 0.
    Everytime you call this function, you will get one test.
    '''
    h = 0.03
    St = [S0 - h, S0, S0 + h]
    dt = 1.0 * T / steps
    # print seed
    # np.random.seed(seed)
    dWt = np.random.normal(0, dt**0.5, steps)
    for i in xrange(100):
        for j in xrange(3):
            sigma = 0.17 * math.exp(-0.004 * St[j] - 1.6667 * i * dt)
            dSt = St[j] * (r * dt + sigma * dWt[i])
            St[j] = St[j] + dSt
    V0 = map(lambda x: (x - K)**2 * math.exp(- r * T), St)
    return V0

def gExpOptPriAndConInt(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100, alpha = 0.95):
    '''
    This function should be named as getOptionPriceAndConfidenceInterval,
    but it is too long to read.
    Try to test 100,000 times, and find the shortest interval as confidence interval.
    Also, treat the average of the 100,000 test as the final result.
    '''
    V = []
    N = 100000
    # seeds = np.random.normal(100, 1, N)
    for i in xrange(N):
        V.append(getOptionPriceAtTimeT(S0 = S0, K = K, r = r, T = T, steps = steps))
    V = np.array(V)
    Gammas = map(lambda x: (x[0] + x[2] - 2 * x[1])/0.0009, V)
    V0 = V.T[1].tolist()
    Gammas.sort()
    V0.sort()
    E = np.mean(V0)
    gamma = np.mean(Gammas)
    ua = int(round(N * alpha))
    width = 2 << 20  # = 2^21
    width2 = 2 << 20
    for j in xrange(N - ua):
        d = V0[j + ua] - V0[j]
        d2 = Gammas[j + ua] - Gammas[j]
        if d < width:
            width = d
            Confidence = [V0[j], V0[j + ua]]
        if d2 < width2:
            width2 = d2
            Confidence2 = [Gammas[j], Gammas[j + ua]]
    fig = plt.figure()
    ax1 = fig.add_subplot(1, 2, 1)
    ax2 = fig.add_subplot(1, 2, 2)
    ax1.hist(V0, 1000)
    ax1.set_title("Option Values with E = %.2f and sigma = %.2f"%(E, np.std(V0)))
    ax2.hist(Gammas, 1000)
    ax2.set_title("Gamma Values with E = %.2f and sigma = %.2f"%(gamma, np.std(Gammas)))
    plt.show()
    return [E, width, Confidence, gamma, width2, Confidence2]
"""
def getGamma(S0 = 250, K = 225, r = 0.03681, T = 0.6, steps = 100, alpha = 0.95):
    '''
    Cuz the error is O(h^2), we set h = 0.03 to ensure that the error is less than 0.01.
    Compute the Option value n times by using S0 = 249.97, 250, and 250.03, then
    we will get n^3 gammas.
    '''
    h = 0.03
    S = []
    n = 600
    print "getting option price..."
    for i in xrange(3):
        s = []
        S0 = S0 + h * (i - 1)
        for j in xrange(n):
            E = gExpOptPriAndConInt(S0 = S0, K = K, r = r, T = T, steps = steps)[0]
            s.append(E)
            print "%.2f%% completed"%(100 * (1.0 * i * n + j + 1)/(3 * n))
        S.append(s)
    Gamma = []
    print "getting Gammas..."
    for i in S[0]:
        for j in S[1]:
            for k in S[2]:
                Gamma.append((i + k - 2 * j)/(h * h))
    print "done"
    print "getting confidence interval..."
    Gamma.sort()
    ua = int(round(n**3 * alpha))
    width = 2 << 20  # = 2^21
    Confidence = -1
    for j in xrange(n**3 - ua):
        d = Gamma[j + ua] - Gamma[j]
        if d < width:
            width = d
            Confidence = [Gamma[j], Gamma[j + ua]]
    print "done"
    E = np.mean(Gamma)
    std = np.std(Gamma)
    plt.hist(Gamma, round(n**1.5))
    plt.show()
    return [E, width, std * 3.92, Confidence]
"""
if __name__ == '__main__':
    [E, width, Confidence, gamma, width2, Confidence2] = gExpOptPriAndConInt()
    print '--------------------------Result of Option---------------------------'
    print 'Expceted value: %s'%E
    print 'The width of confidence interval: %s'%width
    print 'Confidence interval: %s'%Confidence
    print '---------------------------------------------------------------------\n'
    #[gE, gwidth, gwidth2, gConfidence] = getGamma()
    print '--------------------------Result of Gamma----------------------------'
    print 'Expceted value: %s'%gamma
    print 'The width of confidence interval: %s'%width2
    print 'Confidence interval: %s'%Confidence2
    print '---------------------------------------------------------------------'
