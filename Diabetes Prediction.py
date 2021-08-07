#!/usr/bin/env python
# coding: utf-8

# In[13]:


#import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')
diabetes = pd.read_csv("diabetes.csv")
print(diabetes.columns)


# In[14]:


pwd


# In[15]:


diabetes.head()


# In[16]:


print("Dimensions of diabetes dataset:{}".format(diabetes.shape))


# In[17]:


print(diabetes.groupby('Outcome').size())


# In[18]:


import seaborn as sns
sns.countplot (diabetes["Outcome"],label="Count")


# In[19]:


diabetes.info()


# 
# 

# # K-N Nearest Neighbors 

# In[20]:


from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(diabetes.loc[:,diabetes.columns !='Outcome'],diabetes["Outcome"],stratify=diabetes["Outcome"],random_state=66)
from sklearn.neighbors import KNeighborsClassifier
training_accuracy = []
test_accuracy = []
neighbors_settings = range(1,11)
for n_neighbors in neighbors_settings:
    #Build the Model
    knn = KNeighborsClassifier(n_neighbors=n_neighbors)
    knn.fit(X_train, y_train)
    # record training set accuracy
    training_accuracy.append(knn.score(X_train, y_train))
    #record testing set accuracy
    test_accuracy.append(knn.score(X_test, y_test))
plt.plot(neighbors_settings, training_accuracy, label="training accuracy") 
plt.plot(neighbors_settings, test_accuracy, label="test accuracy") 
plt.ylabel("ACCURACY")
plt.xlabel("n_neighbors")
plt.legend()


# In[22]:


#checking accuracy of the algorithm:
knn=KNeighborsClassifier(n_neighbors=9)
knn.fit(X_train, y_train)
print('Accuracy of K-NN classifier on training set: {:.2f}'. format(knn.score(X_train, y_train)))
print('Accuracy of K-NN classifier on test set: {:.2f}'. format(knn.score(X_test, y_test)))


# In[ ]:





# In[ ]:





# In[ ]:




