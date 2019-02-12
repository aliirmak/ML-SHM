# ML-SHM
Using Machine Learning to eliminate temperature variability in SHM applications

The following order is suggested to run the files:
* Make sure data and eq folder are created with three folders (1, 2, and 3) in them. Each folder is related to a damage condition.
* Download *OpenSees* excecutable file and *tcl/tk* package from http://opensees.berkeley.edu/OpenSees/user/download.php
* Put the *OpenSees.exe* into folder where ou will run the scripts. Add *tcl/tk* to path if it is not added already.
* Some documents require MATLAB. Make sure MATLAB installed. The code is tested in 2018b.
* Make sure *Anaconda*(https://www.anaconda.com/distribution/#download-section) is installed. Moreover, *Keras* (https://keras.io/) and *Tensorflow* (https://www.tensorflow.org/install/) should be installed. The code is only tested for *Python 3.6.7*.
* Run **temp_generator.py** to generate reference temperatures. This will create *T.txt* file for each damage condition.
* Run **blwn_noise_generator.py** to generate ambient vibrations. This will create a set of ambient excitiations for each damage condition.
* Run **eq_result_generator3.py** to generate structural responses using the ambient excitation. This part requires *OpenSees*. The code is written to run only on multi-core processors.
* Run **next_freq_modeshapper_grabber.py** to obtain frequencies and mode shapes from structural responses. This step requires *MATLAB* as it utilizes NExT-ERA files written by Dyke, Caicedo, and Giraldo.
* Run **pca3_paper_version.py** or **aann_6freqmodes_era_final_paper_version.py** to generate the novelty index.
