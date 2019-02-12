# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 14:31:11 2018

@author: Ali
"""
import numpy as np

def fftnoise(f):
    f = np.array(f, dtype='complex')
    Np = (len(f) - 1) // 2
    phases = np.random.rand(Np) * 2 * np.pi
    phases = np.cos(phases) + 1j * np.sin(phases)
    f[1:Np+1] *= phases
    f[-1:-1-Np:-1] = np.conj(f[1:Np+1])
    return np.fft.ifft(f).real

def band_limited_noise(min_freq, max_freq, samples=1024, samplerate=1):
    freqs = np.abs(np.fft.fftfreq(samples, 1/samplerate))
    f = np.zeros(samples)
    idx = np.where(np.logical_and(freqs>=min_freq, freqs<=max_freq))[0]
    f[idx] = 1
    return fftnoise(f)

for x in range(3, 4):
    print(x)
    for y in range(1301, 1350):
        noise_data1 = 10*band_limited_noise(0, 1024, 300*1024, 1024)
        noise_data2 = 10*band_limited_noise(0, 1024, 300*1024, 1024)
        np.savetxt('eq\\' + str(x) + '\\' + str(y) + '_1' +'.txt', noise_data1[:,][None], delimiter=' ')
        np.savetxt('eq\\' + str(x) + '\\' + str(y) + '_2' +'.txt', noise_data2[:,][None], delimiter=' ')