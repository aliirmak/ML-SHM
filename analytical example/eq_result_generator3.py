# -*- coding: utf-8 -*-
"""
Created on Sat Aug 11 00:40:32 2018

@author: Ali
"""

import subprocess
import os
import numpy as np
import multiprocessing as mp

def eq_generator(cmd, inputfile, string0_to_be_mod, string1_to_be_mod, 
                 string2_to_be_mod, string3_to_be_mod, T, x, data):
      
    string0_mod = string0_to_be_mod[:6] + str(T) + '\n'    
    string1_mod = string1_to_be_mod[:27]  + str(x) + '.txt' + string1_to_be_mod[27:]  + '\n'
    string2_mod = string2_to_be_mod[:18] + str(x) + '_1' + '.txt' + string2_to_be_mod[18:] + '\n'
    string3_mod = string3_to_be_mod[:18] + str(x) + '_2' + '.txt' + string3_to_be_mod[18:] + '\n'
    
    data[28] = string0_mod # now change the line
    data[61] = string1_mod # now change the line
    data[91] = string2_mod # now change the line
    data[92] = string3_mod # now change the line
	
    newinputfile = inputfile[:-4]+'_'+str(x)+'.tcl'
    with open(newinputfile, 'w') as file:
        # read a list of lines into data
        file.writelines(data)
    
    subprocess.run(cmd + ' ' + newinputfile);
    os.remove(newinputfile);

if __name__ == '__main__':
    
    pool = mp.Pool(processes=4)
    cmd = 'OpenSees'
    
    ##1
    inputfile = 'colpro_undg_sim2.tcl'
    string0_to_be_mod = 'set T 15.0\n'
    string1_to_be_mod = 'recorder Node -file data/1/ -time -nodeRange  2 40 -dof 2 accel'
    string2_to_be_mod = 'set GMfile1 "eq/1/"'
    string3_to_be_mod = 'set GMfile2 "eq/1/"'
    
    with open(inputfile, 'r') as file:
        # read a list of lines into data
        data = file.readlines()
    T_und = np.loadtxt('data\\1\\T.txt', delimiter=' ')
    
    results = [pool.apply_async(
            eq_generator, 
            args=(cmd, inputfile, string0_to_be_mod, string1_to_be_mod, 
                  string2_to_be_mod, string3_to_be_mod, T_und[x], x+1, data)) 
            for x in range(2500)]
    [p.get() for p in results];
    
    ##2
    inputfile = 'colpro_d1_sim2.tcl'
        
    string0_to_be_mod = 'set T 15.0\n'
    string1_to_be_mod = 'recorder Node -file data/2/ -time -nodeRange  2 40 -dof 2 accel'
    string2_to_be_mod = 'set GMfile1 "eq/2/"'
    string3_to_be_mod = 'set GMfile2 "eq/2/"'
    
    with open(inputfile, 'r') as file:
        data = file.readlines()
    T_d1 = np.loadtxt('data\\2\\T.txt', delimiter=' ')
    
    results = [pool.apply_async(
            eq_generator, 
            args=(cmd, inputfile, string0_to_be_mod, string1_to_be_mod, 
                  string2_to_be_mod, string3_to_be_mod, T_d1[x], x+1, data)) 
            for x in range(1301)]
    [p.get() for p in results];
    
    ##3
    inputfile = 'colpro_d2_sim2.tcl'
        
    string0_to_be_mod = 'set T 15.0\n'
    string1_to_be_mod = 'recorder Node -file data/3/ -time -nodeRange  2 40 -dof 2 accel'
    string2_to_be_mod = 'set GMfile1 "eq/3/"'
    string3_to_be_mod = 'set GMfile2 "eq/3/"'
    
    with open(inputfile, 'r') as file:
        data = file.readlines()
    T_d2 = np.loadtxt('data\\3\\T.txt', delimiter=' ')

    results = [pool.apply_async(
            eq_generator, 
            args=(cmd, inputfile, string0_to_be_mod, string1_to_be_mod, 
                  string2_to_be_mod, string3_to_be_mod, T_d2[x], x+1, data)) 
            for x in range(1349)]
    [p.get() for p in results];