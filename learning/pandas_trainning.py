"""
2022.4.26
"""
from pylab import mpl
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import scipy

print(pd.__version__)
print(np.__version__)
print(plt.__version__)
# generate random data
data=np.random.randint(0,100,size=(10000,5))
# give column names
df=pd.DataFrame(data,columns=['a','b','c','d','e'])
df.to_csv('./data.csv')

# read data from csv file
# a=pd.read_csv('./data.csv', index_col=0)

print(df.describe())
print(df.info())
print(df.shape)
print(df.nlargest(5,'a'))
print(df[['a','d']])
print(df.loc[5:8,['a','d']])
df.corr()

from scipy import stats
t,p=stats.ttest_ind(df['a'],df['b'])
print(t,p)
F,p=stats.f_oneway(df['a'],df['b'],df['c'],df['d'],df['e'])
# column means
df.mean(0)
# row means
df.mean(1)

# chinese font
mpl.rcParams['font.sans-serif'] = ['Microsoft YaHei']
df = pd.DataFrame(data, columns=['第一列','第二列','第三列','第四列','第五列'])
df.mean(0).plot(kind='bar')
plt.show()
plt.scatter(df['第一列'],'第二列')
plt.show()

arr1=np.array([[1,2],[4,5],[7,8]])
print(arr1)
print(arr1.shape)
print(arr1.size)

my_arr=np.arange(10)#0-9
my_arr=np.arange(1,10)
np.ones([2,2])

# random seed
print(np.random.RandomState(0).rand(5))
print(np.random.RandomState(2).randint(1,5,10))
print(np.random.RandomState(2).randint(1,5,[5,3]))

# trial list from trial1 to trial6
trial_list = ['trial1', 'trial2', 'trial3', 'trial4', 'trial5', 'trial6']
import random
random.sample(trial_list,3)
arr1.dtype
arr2=np.random.RandomState(2).randint(1,5,10)
arr2.dtype

# create series
rt=pd.Series([1,2,3,4],name='rt')
rt=pd.Series({'trial1':0.88,'trial2':0.82,'trial3':0.9},name='rt')

# create dataframe from series
rt=pd.DataFrame({'rt1':rt,'rt2':rt})

df=pd.read_csv('/Volumes/WD_D/share/document/001.txt',sep='\t',header=None)
df.columns=['time','x','y']
plt.plot(df.x,df.y)
plt.show()
df.set_index('time',inplace=True)
# set index starting from 1
df.set_index(np.arange(1,df.shape[0]+1),inplace=True)
# time series
pd.date_range('1/1/2000',periods=10,freq='D')
# dataframe index
df = pd.DataFrame(data, columns=list('abcde'),index=["a", "b", "c", "d", "e"]*2000)
df.index.unique()
df.index.name='index'
df.index.rename('index_new',inplace=True)
print(df.index.name)
print(df.index.where(df.index<3))
# calculate rank
rt.rank(method='dense',ascending=False)
rt.rank(method='average',ascending=False)
# select by name or index
rt.loc['trial2']
rt.loc[['trial1','trial2'],['rt1']]
rt.iloc[0]
rt.iloc[[0],[0]]
rt.sort_values(by='rt1',ascending=False)
# replace values
rt[rt>=0.9]=1
rt.replace(0.88,1)
rt.replace({0.88:1,0.82:2})
# fill na value
rt[rt>=0.9]=np.nan
rt.fillna(method='ffill',inplace=True)
# add new column
rt['rt_average']=(rt.rt1+rt.rt2)/3
rt.insert(0,'rt_a',(rt.rt1+rt.rt2)/6)
rt=rt.assign(rt_avg=(rt.rt1+rt.rt2)/4,var='-')
# concatenate
pd.concat([rt,rt])
# pop
rt.pop('rt1')
# drop
rt.drop('trial1')
rt.drop('rt2',axis=1)