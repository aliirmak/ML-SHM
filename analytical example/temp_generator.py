# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 14:31:11 2018

@author: Ali
"""
import numpy as np

for x in range(1, 4):
    
    np.savetxt('data\\' + str(x) + '\\' + 'T.txt', np.random.uniform(-15.0, 50.0, 2500))
    np.savetxt('data\\' + str(x) + '\\' + 'T.txt', np.random.uniform(-15.0, 50.0, 2500))
    np.savetxt('data\\' + str(x) + '\\' + 'T.txt', np.random.uniform(-15.0, 50.0, 2500))