# -*- coding: utf-8 -*-
"""
Created on Wed Aug  1 16:48:42 2018

@author: Ali
"""

from __future__ import print_function
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from sklearn.pipeline import make_pipeline
print(__doc__)

# the same configuration with the new data
tot = np.loadtxt('data_4dof.txt', delimiter=',', usecols=list(range(4)));
stat = tot[:, 0]
und = tot[0:50, 1:]
d1 = tot[50:99, 1:]
d2 = tot[99:149, 1:]
d3 = tot[149:199, 1:]
d4 = tot[199:244, 1:]

fig1 = plt.figure(figsize=(8,6))
plt.plot(np.arange(0, 50)+1, und, '#1f77b4')
plt.plot(np.arange(50, 99)+1, d1, '#ff7f0e')
plt.plot(np.arange(99, 149)+1, d2, '#2ca02c')
plt.plot(np.arange(149, 199)+1, d3, '#d62728')
plt.plot(np.arange(199, 244)+1, d4, '#9467bd')
plt.ylabel('Frequency (Hz)')
plt.xlabel('Sample No.')
plt.axis([1, 245, 0, 80])
plt.grid()
plt.savefig('frequency_health_damaged.png', format='png', dpi=300)
plt.show()

############
#
X=und[0:40, :]
std_clf = make_pipeline(StandardScaler(), PCA(n_components=2))
std_clf.fit(X)
X_pca = std_clf.transform(und)
X_new = std_clf.inverse_transform(X_pca)

X_pca1 = std_clf.transform(d1)
X_new1 = std_clf.inverse_transform(X_pca1)

X_pca2 = std_clf.transform(d2)
X_new2 = std_clf.inverse_transform(X_pca2)

X_pca3 = std_clf.transform(d3)
X_new3 = std_clf.inverse_transform(X_pca3)

X_pca4 = std_clf.transform(d4)
X_new4 = std_clf.inverse_transform(X_pca4)

NI0 = np.linalg.norm(und[:, 1:3]-X_new[:, 1:3], axis=-1)
NI1 = np.linalg.norm(d1[:, 1:3]-X_new1[:, 1:3], axis=-1)
NI2 = np.linalg.norm(d2[:, 1:3]-X_new2[:, 1:3], axis=-1)
NI3 = np.linalg.norm(d3[:, 1:3]-X_new3[:, 1:3], axis=-1)
NI4 = np.linalg.norm(d4[:, 1:3]-X_new4[:, 1:3], axis=-1)

fig2222 = plt.figure(figsize=(8,6))
plt.plot(np.arange(0, 50)+1, NI0)
plt.plot(np.arange(50, 99)+1, NI1)
plt.plot(np.arange(99, 149)+1, NI2)
plt.plot(np.arange(149, 199)+1, NI3)
plt.plot(np.arange(199, 244)+1, NI4)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 245, 0, 3.00])
plt.grid()
plt.savefig('PCA-no_modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance without Mode Shapes:')
NI0_x = np.repeat(NI0[40:50], 5)
print(np.linalg.norm(NI0_x[0:40]-NI0[0:40])/np.mean(NI0_x[0:40]))
print(np.linalg.norm(NI0_x[0:49]-NI1)/np.mean(NI0_x[0:49]))
print(np.linalg.norm(NI0_x-NI2)/np.mean(NI0_x))
print(np.linalg.norm(NI0_x-NI3)/np.mean(NI0_x))
print(np.linalg.norm(NI0_x[0:45]-NI4)/np.mean(NI0_x[0:45]))

###############
# the same configuration with the new data
tot = np.loadtxt('data_4dof.txt', delimiter=',');
stat = tot[:, 0]
und = tot[0:50, 1:]
d1 = tot[50:99, 1:]
d2 = tot[99:149, 1:]
d3 = tot[149:199, 1:]
d4 = tot[199:244, 1:]

X=und[0:40, :]
std_clf = make_pipeline(StandardScaler(), PCA(n_components=6))
std_clf.fit(X)
X_pca = std_clf.transform(und)
X_new = std_clf.inverse_transform(X_pca)

X_pca1 = std_clf.transform(d1)
X_new1 = std_clf.inverse_transform(X_pca1)

X_pca2 = std_clf.transform(d2)
X_new2 = std_clf.inverse_transform(X_pca2)

X_pca3 = std_clf.transform(d3)
X_new3 = std_clf.inverse_transform(X_pca3)

X_pca4 = std_clf.transform(d4)
X_new4 = std_clf.inverse_transform(X_pca4)

NI0a = np.linalg.norm(und[:, 1:3]-X_new[:, 1:3], axis=-1)
NI1a = np.linalg.norm(d1[:, 1:3]-X_new1[:, 1:3], axis=-1)
NI2a = np.linalg.norm(d2[:, 1:3]-X_new2[:, 1:3], axis=-1)
NI3a = np.linalg.norm(d3[:, 1:3]-X_new3[:, 1:3], axis=-1)
NI4a = np.linalg.norm(d4[:, 1:3]-X_new4[:, 1:3], axis=-1)

fig222 = plt.figure(figsize=(8,6))
plt.plot(np.arange(0, 50)+1, NI0a)
plt.plot(np.arange(50, 99)+1, NI1a)
plt.plot(np.arange(99, 149)+1, NI2a)
plt.plot(np.arange(149, 199)+1, NI3a)
plt.plot(np.arange(199, 244)+1, NI4a)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 245, 0, 8.00])
plt.grid()
plt.savefig('PCA-modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance with Mode Shapes:')
NI0a_x = np.repeat(NI0a[40:50], 5)
print(np.linalg.norm(NI0a_x[0:40]-NI0a[0:40])/np.mean(NI0a_x[0:40]))
print(np.linalg.norm(NI0a_x[0:49]-NI1a)/np.mean(NI0a_x[0:49]))
print(np.linalg.norm(NI0a_x-NI2a)/np.mean(NI0a_x))
print(np.linalg.norm(NI0a_x-NI3a)/np.mean(NI0a_x))
print(np.linalg.norm(NI0a_x[0:45]-NI4a)/np.mean(NI0a_x[0:45]))
