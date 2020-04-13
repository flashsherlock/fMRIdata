#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  4 14:50:28 2020

@author: mac
"""
#%%
import h5py,os
os.getcwd()
#%%

f = h5py.File('../graphics_data.h5','r')
print(f.keys())
dset = f['events']
dset.keys()
l=dset['labels']
l.shape
l.dtype
l[671]

#原来的neo_events中的digital_input_port变成了events,comment变成了后来的comment
dneo=f['neo_events']
com=dneo['digital_input_port']
com['labels'][671]
com['times'][671]
#%%