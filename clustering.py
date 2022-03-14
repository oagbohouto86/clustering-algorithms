#!/usr/bin/env python
# coding: utf-8

# In[2]:


import os, pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats
from sklearn.cluster import KMeans
from sklearn.preprocessing import scale
from sklearn_extra.cluster import KMedoids
from collections import Counter
import yellowbrick


# In[3]:


data = pd.read_csv('D:/STDV 1/ANALYSEDEDONNEES/PROJET CLUSTERING/states.csv')


# #### Data exploration, vizualisation and preparation

# In[5]:


data.head(n=10)


# In[4]:


data.columns =['State','Pop_Total','Immigration_dom_net','Am_migration_avec_etranger',
               'Immigration_inter_net','Taux_naissance','Taux_mortalite','Pop_moins_65','Pop_plus_65'] #changer le nom des colonnes


# In[5]:


data.index=data['State'] #Changer le nom des lignes


# In[6]:


data.info()


# In[34]:


data.describe()


# In[33]:


fig, axes = plt.subplots(2,4,figsize=(10,5)) 
columns = ['Pop_Total','Immigration_dom_net','Am_migration_avec_etranger',
               'Immigration_inter_net','Taux_naissance','Taux_mortalite','Pop_moins_65','Pop_plus_65']
for i,col in enumerate(list(columns)):
    plot = sns.histplot(data=data[col], kde=True, stat='density', ax=axes.flatten()[i])
plt.tight_layout() 
plt.show()


# In[35]:


corr_data = data.corr(method='spearman')
plt.figure(figsize=(8, 6))
sns.heatmap(corr_data, annot=True)
plt.show()


# In[60]:


data.head()


# In[32]:


data1=data.drop(['State','Pop_Total'],axis=1)


# In[33]:


datascale=pd.DataFrame(scale(data1))
datascale.columns =['Immigration_dom_net','Am_migration_avec_etranger',
               'Immigration_inter_net','Taux_naissance','Taux_mortalite','Pop_moins_65','Pop_plus_65']


# In[34]:


datascale.head()


# In[35]:


datascale.index=data['State']


# #### Clustering using k-means

# Ressource:
# https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html

# In[9]:


from yellowbrick.cluster import KElbowVisualizer
from yellowbrick.cluster import SilhouetteVisualizer
model_kmeans = KMeans(max_iter=1000)
datascale_kmean = KElbowVisualizer(model_kmeans, k=(1,12)).fit(datascale)
datascale_kmean.show()


# In[10]:


datascale_kmean = KMeans(n_clusters=2, init='k-means++', random_state=0).fit(datascale)


# In[11]:


datascale_kmean.labels_
Counter(datascale_kmean.labels_)


# In[73]:


datascale_kmean_label=pd.DataFrame(data['State'])
datascale_kmean_label['label']=datascale_kmean.labels_
datascale_kmean_label[datascale_kmean_label['label']==1]
datascale_kmean_label[datascale_kmean_label['label']==0]


# #### Clustering using k-medoid

# Ressources:
# k-medoids using python:
# https://scikit-learn-extra.readthedocs.io/en/stable/generated/sklearn_extra.cluster.KMedoids.html
# 
# Silhouette and Elbow method for number of cluster optimal:
# https://www.scikit-yb.org/en/latest/api/cluster/elbow.html

# In[34]:


model_kmedo = KMedoids()
datascale_kmedo = KElbowVisualizer(model_kmedo, k=(2,12)).fit(datascale)
datascale_kmedo.show()


# In[37]:


model_kmedo = KMedoids(method='pam',n_clusters=2)
datascale_kmedo = model_kmedo.fit(datascale)
datascale_kmedo.labels_
Counter(datascale_kmedo.labels_)


# #### Clustering using Hierarchical Ascending Classification (CAH)

# Ressource: Hierarchical Ascending Classification using python
# 
# https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AgglomerativeClustering.html#sklearn.cluster.AgglomerativeClustering.fit_predict

# In[14]:


import scipy.cluster.hierarchy as sch
from sklearn.cluster import AgglomerativeClustering as ac


# In[36]:


datascale['State']=datascale.index


# In[37]:


datascale.head()


# In[38]:


dendrogram = sch.dendrogram(sch.linkage(datascale.iloc[:,0:6], method  = "ward"))
plt.title('Clustering Dendrogramme')
plt.xlabel('State')
plt.show()


# In[41]:


model_cah=AgglomerativeClustering(n_clusters=2, affinity='euclidean',compute_full_tree='auto', linkage='ward', 
                                     compute_distances=False)


# In[45]:


datascale_ag=model_cah.fit(datascale.iloc[:,0:6])


# In[47]:


datascale_ag.labels_
Counter(datascale_ag.labels_)

