import numpy as np
from time import time
from keras.layers import Input, Dense
from keras.models import Model
from keras.callbacks import TensorBoard
from keras.callbacks import EarlyStopping
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt

# the same configuration with the new data
tot = np.loadtxt('data_4dof.txt', delimiter=',', usecols=list(range(4)));
stat = tot[:, 0]
und = tot[0:50, 1:]
d1 = tot[50:99, 1:]
d2 = tot[99:149, 1:]
d3 = tot[149:199, 1:]
d4 = tot[199:244, 1:]

scaler = StandardScaler()
und_norm = scaler.fit_transform(und)
d1_norm = scaler.transform(d1)
d2_norm = scaler.transform(d2)
d3_norm = scaler.transform(d3)
d4_norm = scaler.transform(d4)

# this is our input placeholder
input_data = Input(shape=(3,))
# "encoded" is the encoded representation of the input
encoded = Dense(2, activation='relu')(input_data)
# "bottleneck" is the necked mapping
neck = Dense(1, activation='relu')(encoded)
# "decoded" is the lossy reconstruction of the input
decoded = Dense(2, activation='relu')(encoded)
# "decoded" is the lossy reconstruction of the input
output_data = Dense(3, activation='relu')(decoded)

# this model maps an input to its reconstruction
autoencoder = Model(input_data, output_data)

autoencoder.compile(loss='mse', # Cross-entropy
                optimizer='adam', # Root Mean Square Propagation
                metrics=['accuracy']) # Accuracy performance metric

x_train, x_test = und_norm[0:40,:], und_norm[40:50,:]

#show th  model
#plot_model(autoencoder, to_file='model_plot.png', show_shapes=True, show_layer_names=True)
print(autoencoder.summary())

early_stopping = EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='auto', baseline=None)

autoencoder.fit(x_train, x_train,
                epochs=3000,
                batch_size=100,
                shuffle=True,
                validation_data=(x_test, x_test),
                callbacks=[early_stopping],
                verbose=0)

#predict result
und_fit=autoencoder.predict(und_norm)
d1_fit=autoencoder.predict(d1_norm)
d2_fit=autoencoder.predict(d2_norm)
d3_fit=autoencoder.predict(d3_norm)
d4_fit=autoencoder.predict(d4_norm)

# inverse norm
und_fit = scaler.inverse_transform(und_fit)
d1_fit = scaler.inverse_transform(d1_fit)
d2_fit = scaler.inverse_transform(d2_fit)
d3_fit = scaler.inverse_transform(d3_fit)
d4_fit = scaler.inverse_transform(d4_fit)

NI0 = np.linalg.norm(und-und_fit, axis=-1)
NI1 = np.linalg.norm(d1-d1_fit, axis=-1)
NI2 = np.linalg.norm(d2-d2_fit, axis=-1)
NI3 = np.linalg.norm(d3-d3_fit, axis=-1)
NI4 = np.linalg.norm(d4-d4_fit, axis=-1)

#from sklearn.metrics import mean_squared_error
#NI = mean_squared_error(x_train[0:1,1:], B) # hich is basically MSE
fig1 = plt.figure(figsize=(8,6))
plt.plot(np.arange(0, 50)+1, NI0)
plt.plot(np.arange(50, 99)+1, NI1)
plt.plot(np.arange(99, 149)+1, NI2)
plt.plot(np.arange(149, 199)+1, NI3)
plt.plot(np.arange(199, 244)+1, NI4)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 245, 0, 10.0])
plt.grid()
plt.savefig('AE-no_modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance without Mode Shapes:')
NI0_x = np.repeat(NI0[40:50], 5)
print(np.linalg.norm(NI0_x[0:40]-NI0[0:40])/np.mean(NI0_x[0:40]))
print(np.linalg.norm(NI0_x[0:49]-NI1)/np.mean(NI0_x[0:49]))
print(np.linalg.norm(NI0_x-NI2)/np.mean(NI0_x))
print(np.linalg.norm(NI0_x-NI3)/np.mean(NI0_x))
print(np.linalg.norm(NI0_x[0:45]-NI4)/np.mean(NI0_x[0:45]))

#####
# the same configuration with the new data
tot = np.loadtxt('data_4dof.txt', delimiter=',');
stat = tot[:, 0]
und = tot[0:50, 1:]
d1 = tot[50:99, 1:]
d2 = tot[99:149, 1:]
d3 = tot[149:199, 1:]
d4 = tot[199:244, 1:]

scaler = StandardScaler()
und_norm = scaler.fit_transform(und)
d1_norm = scaler.transform(d1)
d2_norm = scaler.transform(d2)
d3_norm = scaler.transform(d3)
d4_norm = scaler.transform(d4)

# this is our input placeholder
input_data = Input(shape=(12,))
# "encoded" is the encoded representation of the input
encoded = Dense(8, activation='relu')(input_data)
# "bottleneck" is the necked mapping
neck = Dense(1, activation='relu')(encoded)
# "decoded" is the lossy reconstruction of the input
decoded = Dense(8, activation='relu')(encoded)
# "decoded" is the lossy reconstruction of the input
output_data = Dense(3, activation='relu')(decoded)

# this model maps an input to its reconstruction
autoencoder = Model(input_data, output_data)

autoencoder.compile(loss='mse', # Cross-entropy
                optimizer='adam', # Root Mean Square Propagation
                metrics=['accuracy']) # Accuracy performance metric

x_train, x_test = und_norm[0:40,:], und_norm[40:50,:]
y_train, y_test = und_norm[0:40,:3], und_norm[40:50,:3]

#show th  model
#plot_model(autoencoder, to_file='model_plot.png', show_shapes=True, show_layer_names=True)
print(autoencoder.summary())

early_stopping = EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='auto', baseline=None)

autoencoder.fit(x_train, y_train,
                epochs=3000,
                batch_size=100,
                shuffle=True,
                validation_data=(x_test, y_test),
                callbacks=[early_stopping],
                verbose=0)

#predict result
und_fit=autoencoder.predict(und_norm)
d1_fit=autoencoder.predict(d1_norm)
d2_fit=autoencoder.predict(d2_norm)
d3_fit=autoencoder.predict(d3_norm)
d4_fit=autoencoder.predict(d4_norm)

#attach normalized temp back to predicted values
und_fit = np.hstack((und_fit,und_norm[:,3:]))
d1_fit = np.hstack((d1_fit,d1_norm[:,3:]))
d2_fit = np.hstack((d2_fit,d2_norm[:,3:]))
d3_fit = np.hstack((d3_fit,d3_norm[:,3:]))
d4_fit = np.hstack((d4_fit,d4_norm[:,3:]))

# inverse norm
und_fit = scaler.inverse_transform(und_fit)
d1_fit = scaler.inverse_transform(d1_fit)
d2_fit = scaler.inverse_transform(d2_fit)
d3_fit = scaler.inverse_transform(d3_fit)
d4_fit = scaler.inverse_transform(d4_fit)

NI0a = np.linalg.norm(und[:,:3]-und_fit[:,:3], axis=-1)
NI1a = np.linalg.norm(d1[:,:3]-d1_fit[:,:3], axis=-1)
NI2a = np.linalg.norm(d2[:,:3]-d2_fit[:,:3], axis=-1)
NI3a = np.linalg.norm(d3[:,:3]-d3_fit[:,:3], axis=-1)
NI4a = np.linalg.norm(d4[:,:3]-d4_fit[:,:3], axis=-1)

#from sklearn.metrics import mean_squared_error
#NI = mean_squared_error(x_train[0:1,1:], B) # hich is basically MSE
fig2 = plt.figure(figsize=(8,6))
plt.plot(np.arange(0, 50)+1, NI0a)
plt.plot(np.arange(50, 99)+1, NI1a)
plt.plot(np.arange(99, 149)+1, NI2a)
plt.plot(np.arange(149, 199)+1, NI3a)
plt.plot(np.arange(199, 244)+1, NI4a)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 245, 0, 22])
plt.grid()
plt.savefig('AE-modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance with Mode Shapes:')
NI0a_x = np.repeat(NI0a[40:50], 5)
print(np.linalg.norm(NI0a_x[0:40]-NI0a[0:40])/np.mean(NI0a_x[0:40]))
print(np.linalg.norm(NI0a_x[0:49]-NI1a)/np.mean(NI0a_x[0:49]))
print(np.linalg.norm(NI0a_x-NI2a)/np.mean(NI0a_x))
print(np.linalg.norm(NI0a_x-NI3a)/np.mean(NI0a_x))
print(np.linalg.norm(NI0a_x[0:45]-NI4a)/np.mean(NI0a_x[0:45]))