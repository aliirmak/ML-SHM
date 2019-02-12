"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
from time import time
from keras.layers import Input, Dense
from keras.models import Model
from keras.callbacks import TensorBoard
from keras.callbacks import EarlyStopping
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
#from keras.utils.vis_utils import plot_model

und = np.loadtxt('und.txt', delimiter=' ', usecols=list(range(7))); und = und[0:2000,:]
d1 = np.loadtxt('d1.txt', delimiter=' ', usecols=list(range(7))); d1 = d1[0:1000,:]
d2 = np.loadtxt('d2.txt', delimiter=' ', usecols=list(range(7))); d2 = d2[0:1000,:]

scaler = StandardScaler()
und_norm = scaler.fit_transform(und)
d1_norm = scaler.transform(d1)
d2_norm = scaler.transform(d2)

# this is our input placeholder
input_data = Input(shape=(7,))
# "encoded" is the encoded representation of the input
encoded = Dense(3, activation='linear')(input_data)
# "bottleneck" is the necked mapping
neck = Dense(1, activation='linear')(encoded)
# "decoded" is the lossy reconstruction of the input
decoded = Dense(3, activation='linear')(encoded)
# "decoded" is the lossy reconstruction of the input
output_data = Dense(6, activation='linear')(decoded)

# this model maps an input to its reconstruction
autoencoder = Model(input_data, output_data)

autoencoder.compile(loss='mse', # Cross-entropy
                optimizer='adam', # Root Mean Square Propagation
                metrics=['accuracy']) # Accuracy performance metric

x_train, x_test = und_norm[0:750,:], und_norm[750:250,:]

#show th  model
#plot_model(autoencoder, to_file='model_plot.png', show_shapes=True, show_layer_names=True)
print(autoencoder.summary())

tensorboard = TensorBoard(log_dir='./Graph'.format(time()),
                          histogram_freq=0,
                          write_graph=True, write_images=True)

autoencoder.fit(x_train, x_train[:,1:],
                epochs=2500,
                batch_size=100,
                shuffle=True,
                validation_data=(x_test, x_test[:,1:]),
                verbose=0)


print(x_train[0:1,1:], '\n',
      autoencoder.predict(x_train[0:1,:]))

und_noT = und[:,1:]
d1_noT = d1[:,1:]
d2_noT = d2[:,1:]

#predict result
und_noT_fit=autoencoder.predict(und_norm)
d1_noT_fit=autoencoder.predict(d1_norm)
d2_noT_fit=autoencoder.predict(d2_norm)

#attach normalized temp back to predicted values
und_noT_fit = np.hstack((und_norm[:,0][:,None],und_noT_fit))
d1_noT_fit = np.hstack((d1_norm[:,0][:,None],d1_noT_fit))
d2_noT_fit = np.hstack((d2_norm[:,0][:,None],d2_noT_fit))

# inverse norm
und_fit = scaler.inverse_transform(und_noT_fit)
d1_fit = scaler.inverse_transform(d1_noT_fit)
d2_fit = scaler.inverse_transform(d2_noT_fit)

#again strip back the temp
und_noT_fit = und_fit[:,1:7]
d1_noT_fit = d1_fit[:,1:7]
d2_noT_fit = d2_fit[:,1:7]

NI0_freq = np.linalg.norm(und_noT-und_noT_fit, axis=-1)
NI1_freq = np.linalg.norm(d1_noT-d1_noT_fit, axis=-1)
NI2_freq = np.linalg.norm(d2_noT-d2_noT_fit, axis=-1)

#from sklearn.metrics import mean_squared_error
#NI = mean_squared_error(x_train[0:1,1:], B) # hich is basically MSE
fig1 = plt.plot(np.arange(1, 2001, 1), und_noT[:,:], 'r')
plt.plot(np.arange(2001, 3001, 1), d1_noT, 'b')
plt.plot(np.arange(3001, 4001, 1), d2_noT, 'g')
plt.ylabel('Frequency (Hz)')
plt.ylabel('Sample No.')
plt.axis([1, 4001, 0, 30])
plt.show()

fig2 = plt.figure(figsize=(8,6))
plt.plot(np.arange(1, 2001, 1), NI0_freq)
plt.plot(np.arange(2001, 3001, 1), NI1_freq)
plt.plot(np.arange(3001, 4001, 1), NI2_freq)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 4001, 0, 0.35])
plt.grid()
plt.savefig('AE-no_modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance without Mode Shapes:')
print(np.linalg.norm(NI0_freq[1000:2000]-NI0_freq[0:1000])/np.mean(NI0_freq[1000:2000]))
print(np.linalg.norm(NI0_freq[1000:2000]-NI1_freq)/np.mean(NI0_freq[1000:2000]))
print(np.linalg.norm(NI0_freq[1000:2000]-NI2_freq)/np.mean(NI0_freq[1000:2000]))

####
und = np.loadtxt('und.txt', delimiter=' '); und = und[0:2000,:]
d1 = np.loadtxt('d1.txt', delimiter=' '); d1 = d1[0:1000,:]
d2 = np.loadtxt('d2.txt', delimiter=' '); d2 = d2[0:1000,:]

scaler = StandardScaler()
und_norm = scaler.fit_transform(und)
d1_norm = scaler.transform(d1)
d2_norm = scaler.transform(d2)

# this is our input placeholder
input_data = Input(shape=(241,))
# "encoded" is the encoded representation of the input
encoded = Dense(12, activation='linear')(input_data)
# "bottleneck" is the necked mapping
neck = Dense(1, activation='linear')(encoded)
# "decoded" is the lossy reconstruction of the input
decoded = Dense(12, activation='linear')(encoded)
# "decoded" is the lossy reconstruction of the input
output_data = Dense(6, activation='linear')(decoded)

# this model maps an input to its reconstruction
autoencoder = Model(input_data, output_data)

autoencoder.compile(loss='mse', # Cross-entropy
                optimizer='adam', # Root Mean Square Propagation
                metrics=['accuracy']) # Accuracy performance metric

x_train, x_test = und_norm[0:750,:], und_norm[750:1000,:]

#show th  model
#plot_model(autoencoder, to_file='model_plot.png', show_shapes=True, show_layer_names=True)
print(autoencoder.summary())

tensorboard = TensorBoard(log_dir='./Graph'.format(time()),
                          histogram_freq=0,
                          write_graph=True, write_images=True)

early_stopping = EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='auto', baseline=None)

autoencoder.fit(x_train, x_train[:,1:7],
                epochs=3000,
                batch_size=100,
                shuffle=True,
                validation_data=(x_test, x_test[:,1:7]),
                callbacks=[early_stopping],
                verbose=0)

und_noT = und[:,1:7]
d1_noT = d1[:,1:7]
d2_noT = d2[:,1:7]

#predict result
und_noT_fit=autoencoder.predict(und_norm)
d1_noT_fit=autoencoder.predict(d1_norm)
d2_noT_fit=autoencoder.predict(d2_norm)

#attach normalized temp back to predicted values
und_noT_fit = np.hstack((und_norm[:,0][:,None],und_noT_fit,und_norm[:,7:]))
d1_noT_fit = np.hstack((d1_norm[:,0][:,None],d1_noT_fit,d1_norm[:,7:]))
d2_noT_fit = np.hstack((d2_norm[:,0][:,None],d2_noT_fit,d2_norm[:,7:]))

und_fit = scaler.inverse_transform(und_noT_fit)
d1_fit = scaler.inverse_transform(d1_noT_fit)
d2_fit = scaler.inverse_transform(d2_noT_fit)

#again strip back the temp
und_noT_fit = und_fit[:,1:7]
d1_noT_fit = d1_fit[:,1:7]
d2_noT_fit = d2_fit[:,1:7]

NI0_freqms = np.linalg.norm(und_noT-und_noT_fit, axis=-1)
NI1_freqms = np.linalg.norm(d1_noT-d1_noT_fit, axis=-1)
NI2_freqms = np.linalg.norm(d2_noT-d2_noT_fit, axis=-1)

#from sklearn.metrics import mean_squared_error
#NI = mean_squared_error(x_train[0:1,1:], B) # hich is basically MSE

fig22 = plt.figure(figsize=(8,6))
plt.plot(np.arange(1, 2001, 1), NI0_freqms)
plt.plot(np.arange(2001, 3001, 1), NI1_freqms)
plt.plot(np.arange(3001, 4001, 1), NI2_freqms)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 4001, 0, 1.2])
plt.grid()
plt.savefig('AE-modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance with Mode Shapes:')
print(np.linalg.norm(NI0_freqms[1000:2000]-NI0_freqms[0:1000])/np.mean(NI0_freqms[1000:2000]))
print(np.linalg.norm(NI0_freqms[1000:2000]-NI1_freqms)/np.mean(NI0_freqms[1000:2000]))
print(np.linalg.norm(NI0_freqms[1000:2000]-NI2_freqms)/np.mean(NI0_freqms[1000:2000]))