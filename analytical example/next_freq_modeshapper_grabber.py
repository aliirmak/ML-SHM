import matlab.engine
import numpy as np

eng = matlab.engine.start_matlab()

filepathgen = r"C:\Users\Ali\cantilever_model_40_v2\NExT ERA_DC"
eng.addpath(eng.genpath(filepathgen));
eng.prepoolsetup(nargout=0)

## undamaged
inputfile = 'und.txt'

# inside the loop 
# insert the text file name inside Bench_lol4
T_und = np.loadtxt('data\\1\\T.txt', delimiter=' ')

for x in range(1, 2501):
    
    try:
        filename = 'data\\1\\' + str(x) + '.txt'
        fd, shd = eng.Bench_lol4(filename, nargout=2)
        
        if (
                fd.size[1] < 6 or 
                np.array(fd._data)[0] < 0.4 or  np.array(fd._data)[0] > 0.6  or
                np.array(fd._data)[1] < 1.5 or np.array(fd._data)[1] > 2.5 or
                np.array(fd._data)[2] < 3.5 or  np.array(fd._data)[2] > 5.5  or
                np.array(fd._data)[3] < 7.0 or  np.array(fd._data)[3] > 9.0  or 
                np.array(fd._data)[4] < 11.5 or  np.array(fd._data)[4] > 13.5  or
                np.array(fd._data)[5] < 16.2 or  np.array(fd._data)[5] > 19.2
                ):
            continue
        else:
            data_T_fd_shd = np.hstack((T_und[x-1],np.array(fd._data)[0:6],np.array(shd._data)[0:234]))
            data_T_fd_shd = data_T_fd_shd[:][None]
            with open(inputfile, 'ab+') as file:
                np.savetxt(file, data_T_fd_shd, delimiter=' ', newline='\n')
    except:
        print('A problem with matlab at step ' + str(x))


##15% damaged
inputfile = 'd1.txt'

# inside the loop 
# insert the text file name inside Bench_lol4
T_d1 = np.loadtxt('data\\2\\T.txt', delimiter=' ')

for x in range(1, 1301):
    
    try:
        filename = 'data\\2\\' + str(x) + '.txt'
        fd, shd  = eng.Bench_lol4(filename, nargout=2)
        
        if (
                fd.size[1] < 6 or 
                np.array(fd._data)[0] < 0.4 or  np.array(fd._data)[0] > 0.6  or
                np.array(fd._data)[1] < 1.5 or np.array(fd._data)[1] > 2.5 or
                np.array(fd._data)[2] < 3.5 or  np.array(fd._data)[2] > 5.5  or
                np.array(fd._data)[3] < 7.0 or  np.array(fd._data)[3] > 9.0  or 
                np.array(fd._data)[4] < 11.5 or  np.array(fd._data)[4] > 13.5  or
                np.array(fd._data)[5] < 16.2 or  np.array(fd._data)[5] > 19.2
                ):
            continue
        else:
            data_T_fd_shd = np.hstack((T_d1[x-1],np.array(fd._data)[0:6],np.array(shd._data)[0:234]))
            data_T_fd_shd = data_T_fd_shd[:][None]
            with open(inputfile, 'ab+') as file:
                np.savetxt(file, data_T_fd_shd, delimiter=' ', newline='\n')
    except:
        print('A problem with matlab at step ' + str(x))


## 50% damaged
inputfile = 'd2.txt'

# inside the loop 
# insert the text file name inside Bench_lol4
T_d2 = np.loadtxt('data\\3\\T.txt', delimiter=' ')

for x in range(1, 1350):
    
    try:
        filename = 'data\\3\\' + str(x) + '.txt'
        fd, shd = eng.Bench_lol4(filename, nargout=2)
        
        if (
                fd.size[1] < 6 or 
                np.array(fd._data)[0] < 0.4 or  np.array(fd._data)[0] > 0.6  or
                np.array(fd._data)[1] < 1.5 or np.array(fd._data)[1] > 2.5 or
                np.array(fd._data)[2] < 3.5 or  np.array(fd._data)[2] > 5.5  or
                np.array(fd._data)[3] < 7.0 or  np.array(fd._data)[3] > 9.0  or 
                np.array(fd._data)[4] < 11.5 or  np.array(fd._data)[4] > 13.5  or
                np.array(fd._data)[5] < 16.2 or  np.array(fd._data)[5] > 19.2
                ):
            continue
        else:
            data_T_fd_shd = np.hstack((T_d2[x-1],np.array(fd._data)[0:6],np.array(shd._data)[0:234]))
            data_T_fd_shd = data_T_fd_shd[:][None]
            with open(inputfile, 'ab+') as file:
                np.savetxt(file, data_T_fd_shd, delimiter=' ', newline='\n')
    except:
        print('A problem with matlab at step ' + str(x))

eng.quit()
