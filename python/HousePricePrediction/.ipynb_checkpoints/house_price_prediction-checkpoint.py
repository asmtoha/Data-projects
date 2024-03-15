#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import plotly.express as px
import seaborn as sns
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')
import numpy as np
from sklearn.linear_model import LinearRegression
import math
from sklearn import metrics
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split


# In[2]:


df = pd.read_csv('C:/Users/psys0/Desktop/Projects/HousePricePrediction/USA_Housing.csv')
df


# In[3]:


df = df.drop(['Address'],axis=1)


# In[4]:


df.info()


# In[5]:


df.corr()


# In[6]:


fig = px.histogram(df, x='Avg. Area Income', marginal='box', title='Avg. Area Income Distribution')
fig.update_layout(bargap=0.3)
fig.show()


# In[7]:


fig = px.histogram(df,x='Avg. Area House Age', marginal='box', title='Avg. Area House Age Distribution',color_discrete_sequence=['red'])
fig.update_layout(bargap=0.3)
fig.show()


# In[8]:


fig = px.histogram(df, x='Avg. Area Number of Rooms', title='Avg. Area Number of Rooms Distribution', marginal='box',color_discrete_sequence=['green'])
fig.update_layout(bargap=0.3)
fig.show()


# In[9]:


fig = px.histogram(df, x='Avg. Area Number of Bedrooms', title='Avg. Area Number of Bedrooms Distribution',nbins=round(6.5-2+1),color_discrete_sequence=['tomato'], marginal='box')
fig.update_layout(bargap=0.3)
fig.show()


# In[10]:


fig=px.histogram(df, x='Area Population', marginal='box', title='Area Population Distribution',color_discrete_sequence=['black'])
fig.update_layout(bargap=0.3)
fig.show()


# In[11]:


df.describe()


# In[12]:


fig = px.scatter(df,x='Avg. Area Income', y='Price', title='Avg. Area Income Vs Price')
fig.update_traces(marker_size=3.5)
fig.show()


# In[13]:


print('Correlation Between Avg. Area Income And Price =',df['Price'].corr(df['Avg. Area Income']))


# In[14]:


fig=px.scatter(df, x='Avg. Area House Age', y='Price', title='Avg. Area House Age Vs Price')
fig.update_traces(marker_size=3.5)
fig.show()


# In[15]:


print('Correlation Between Avg. Area House Age And Price =',df['Price'].corr(df['Avg. Area House Age']))


# In[16]:


fig = px.scatter(df, x='Avg. Area Number of Rooms', y='Price', title='Avg. Area Number of Rooms Vs Price')
fig.update_traces(marker_size=3.5)
fig.show()


# In[17]:


print('Correlation Between Avg. Area House Age And Price =',df['Price'].corr(df['Avg. Area Number of Rooms']))


# In[18]:


fig=px.violin(df, x='Avg. Area Number of Bedrooms', y='Price', title='Avg. Area Number of Bedrooms Vs Price')
fig.update_traces(marker_size=3.5)
fig.show()


# In[19]:


print('Correlation Between Avg. Area House Age And Price =',df['Price'].corr(df['Avg. Area Number of Bedrooms']))


# In[20]:


df.corr()


# In[21]:


sns.heatmap(df.corr(), annot=True, cmap='Greens')
plt.title('Correlation Matrix')


# In[22]:


#Linear regression
df.info()


# In[23]:


X = np.array(df[['Avg. Area Income','Avg. Area House Age','Avg. Area Number of Rooms',
               'Avg. Area Number of Bedrooms','Area Population']])
Y = np.array(df['Price'])


# In[24]:


model = LinearRegression().fit(X,Y)


# In[25]:


Y_pred = model.predict(X)


# In[26]:


print('Mean Squared Error =',math.sqrt(metrics.mean_squared_error(Y, Y_pred)))


# In[27]:


scaler = StandardScaler()
X = scaler.fit_transform(df)
Y = np.array(df['Price'])


# In[28]:


model = LinearRegression().fit(X, Y)


# In[29]:


Y_pred = model.predict(X)


# In[30]:


print('Mean Squared Error =',math.sqrt(metrics.mean_squared_error(Y, Y_pred)))


# In[31]:


#Test data


# In[32]:


X = np.array(df)
Y = np.array(df['Price'])
X_train,X_test,Y_train,Y_test = train_test_split(X,Y,test_size=0.3)


# In[33]:


model = LinearRegression().fit(X_train, Y_train)


# In[34]:


Y_train_pred = model.predict(X_train)
Y_test_pred = model.predict(X_test)


# In[35]:


print('Mean Squared Training Error =',math.sqrt(metrics.mean_squared_error(Y_train, Y_train_pred)))
print('Mean Squared Testing Error =',math.sqrt(metrics.mean_squared_error(Y_test, Y_test_pred)))


# In[ ]:




