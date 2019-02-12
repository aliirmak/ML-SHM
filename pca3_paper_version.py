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

und = np.loadtxt('und.txt', delimiter=' ', usecols=list(range(7))); und = und[0:2000, :]
d1 = np.loadtxt('d1.txt', delimiter=' ', usecols=list(range(7))); d1 = d1[0:1000, :]
d2 = np.loadtxt('d2.txt', delimiter=' ', usecols=list(range(7))); d2 = d2[0:1000, :]

fig1 = plt.figure(figsize=(8,6))
plt.plot(np.arange(1, 2001), und[:, 1:7], '#1f77b4')
plt.plot(np.arange(2001, 3001), d1[:, 1:7], '#ff7f0e')
plt.plot(np.arange(3001, 4001), d2[:, 1:7], '#2ca02c')
plt.ylabel('Frequency (Hz)')
plt.xlabel('Sample No.')
plt.axis([1, 4001, 0, 20])
plt.grid()
plt.savefig('frequency_health_damaged.png', format='png', dpi=300)
plt.show()

###############
# the same configuration with the new data
und = np.loadtxt('und.txt', delimiter=' '); und = und[0:2000, :]
d1 = np.loadtxt('d1.txt', delimiter=' '); d1 = d1[0:1000, :]
d2 = np.loadtxt('d2.txt', delimiter=' '); d2 = d2[0:1000, :]

X=und[0:1000, :]
std_clf = make_pipeline(StandardScaler(), PCA(n_components=100))
std_clf.fit(X)
X_pca = std_clf.transform(und)
X_new = std_clf.inverse_transform(X_pca)

X=d1
X_pca1 = std_clf.transform(d1)
X_new1 = std_clf.inverse_transform(X_pca1)

X=d2
X_pca2 = std_clf.transform(d2)
X_new2 = std_clf.inverse_transform(X_pca2)

NI0a = np.linalg.norm(und[:, 1:7]-X_new[:, 1:7], axis=-1)
NI1a = np.linalg.norm(d1[:, 1:7]-X_new1[:, 1:7], axis=-1)
NI2a = np.linalg.norm(d2[:, 1:7]-X_new2[:, 1:7], axis=-1)

fig222 = plt.figure(figsize=(8,6))
plt.plot(np.arange(1, 2001, 1), NI0a)
plt.plot(np.arange(2001, 3001, 1), NI1a)
plt.plot(np.arange(3001, 4001, 1), NI2a)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 4001, 0, 0.10])
plt.grid()
plt.savefig('PCA-modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance with Mode Shapes:')
print(np.linalg.norm(NI0a[1000:2000]-NI0a[0:1000])/np.mean(NI0a[1000:2000]))
print(np.linalg.norm(NI0a[1000:2000]-NI1a)/np.mean(NI0a[1000:2000]))
print(np.linalg.norm(NI0a[1000:2000]-NI2a)/np.mean(NI0a[1000:2000]))

und = np.loadtxt('und.txt', delimiter=' ', usecols=list(range(7))); und = und[0:2000, :]
d1 = np.loadtxt('d1.txt', delimiter=' ', usecols=list(range(7))); d1 = d1[0:1000, :]
d2 = np.loadtxt('d2.txt', delimiter=' ', usecols=list(range(7))); d2 = d2[0:1000, :]

X=und[0:1000, :]
std_clf = make_pipeline(StandardScaler(), PCA(n_components=3))
std_clf.fit(X)
X_pca = std_clf.transform(und)
X_new = std_clf.inverse_transform(X_pca)

X=d1
X_pca1 = std_clf.transform(d1)
X_new1 = std_clf.inverse_transform(X_pca1)

X=d2
X_pca2 = std_clf.transform(d2)
X_new2 = std_clf.inverse_transform(X_pca2)

NI0 = np.linalg.norm(und[:, 1:7]-X_new[:, 1:7], axis=-1)
NI1 = np.linalg.norm(d1[:, 1:7]-X_new1[:, 1:7], axis=-1)
NI2 = np.linalg.norm(d2[:, 1:7]-X_new2[:, 1:7], axis=-1)

fig2222 = plt.figure(figsize=(8,6))
plt.plot(np.arange(1, 2001, 1), NI0)
plt.plot(np.arange(2001, 3001, 1), NI1)
plt.plot(np.arange(3001, 4001, 1), NI2)
plt.ylabel('Novelty Index')
plt.xlabel('Sample No.')
plt.axis([1, 4001, 0, 0.30])
plt.grid()
plt.savefig('PCA-n0_modeshape.png', format='png', dpi=300)
plt.show()

print('Euclidean Distance without Mode Shapes:')
print(np.linalg.norm(NI0[1000:2000]-NI0[0:1000])/np.mean(NI0[1000:2000]))
print(np.linalg.norm(NI0[1000:2000]-NI1)/np.mean(NI0[1000:2000]))
print(np.linalg.norm(NI0[1000:2000]-NI2)/np.mean(NI0[1000:2000]))