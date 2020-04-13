# -*- coding: utf-8 -*-

from NeoAnalysis import TransFile
from NeoAnalysis import Graphics
import matplotlib.pyplot as plt
import os
import h5py as hp
## -----------------------------Transfile-----------------------------------##
root = "/Volumes/WD_D/gufei/monkey_data/"
fl = "200107_testo4_rm033_2-01"
test =4

filename = root+fl
# TransFile.transfile(filename,"plexon",True)

## ------------------------------mapping -----------------------------------##
# comments:
# digitals events
# 9: trial start
# 18: trial end
filename = filename + '.h5'
#for block1
if test == 1:
    TransFile.generate_comments(filename,'map',True,mapping={"Strobed/31":["olf:1"],
                                                             "Strobed/32":["olf:4"],
                                                             "Strobed/33":["olf:2"],
                                                             "Strobed/34":["olf:5"],
                                                             "Strobed/35":["olf:3"],
                                                             "Strobed/36":["olf:4"],
                                                             "Strobed/37":["olf:1"],
                                                             "Strobed/38":["olf:5"],
                                                             "Strobed/39":["olf:2"],
                                                             "Strobed/40":["olf:4"],
                                                             "Strobed/41":["olf:3"],
                                                             "Strobed/42":["olf:5"],
                                                             "Strobed/43":["olf:2"],
                                                             "Strobed/44":["olf:1"],
                                                             "Strobed/45":["olf:3"]})


#for block2
if test == 2:
    TransFile.generate_comments(filename,'map',True,mapping={"Strobed/31":["olf:5"],
                                                             "Strobed/32":["olf:1"],
                                                             "Strobed/33":["olf:4"],
                                                             "Strobed/34":["olf:3"],
                                                             "Strobed/35":["olf:5"],
                                                             "Strobed/36":["olf:3"],
                                                             "Strobed/37":["olf:1"],
                                                             "Strobed/38":["olf:4"],
                                                             "Strobed/39":["olf:2"],
                                                             "Strobed/40":["olf:1"],
                                                             "Strobed/41":["olf:2"],
                                                             "Strobed/42":["olf:5"],
                                                             "Strobed/43":["olf:3"],
                                                             "Strobed/44":["olf:4"],
                                                             "Strobed/45":["olf:2"]})

##for block3
if test == 3:
    TransFile.generate_comments(filename,'map',True,mapping={"Strobed/31":["olf:3"],
                                                             "Strobed/32":["olf:4"],
                                                             "Strobed/33":["olf:1"],
                                                             "Strobed/34":["olf:2"],
                                                             "Strobed/35":["olf:5"],
                                                             "Strobed/36":["olf:3"],
                                                             "Strobed/37":["olf:4"],
                                                             "Strobed/38":["olf:2"],
                                                             "Strobed/39":["olf:1"],
                                                             "Strobed/40":["olf:5"],
                                                             "Strobed/41":["olf:1"],
                                                             "Strobed/42":["olf:2"],
                                                             "Strobed/43":["olf:4"],
                                                             "Strobed/44":["olf:3"],
                                                             "Strobed/45":["olf:5"]})

##for block4
if test == 4:    
    TransFile.generate_comments(filename,'map',True,mapping={"Strobed/31":["olf:4"],
                                                             "Strobed/32":["olf:3"],
                                                             "Strobed/33":["olf:1"],
                                                             "Strobed/34":["olf:5"],
                                                             "Strobed/35":["olf:2"],
                                                             "Strobed/36":["olf:1"],
                                                             "Strobed/37":["olf:5"],
                                                             "Strobed/38":["olf:3"],
                                                             "Strobed/39":["olf:4"],
                                                             "Strobed/40":["olf:2"],
                                                             "Strobed/41":["olf:5"],
                                                             "Strobed/42":["olf:3"],
                                                             "Strobed/43":["olf:1"],
                                                             "Strobed/44":["olf:2"],
                                                             "Strobed/45":["olf:4"]})


TransFile.generate_events(filename,"map",True,mapping={"Strobed/9":"9",
                                               "Strobed/18":"18",
                                               "Strobed/23":"23",
                                               "Strobed/24":"24",
                                               "Strobed/25":"25",
                                               "Strobed/26":"26",
                                               "Strobed/27":"27"})
    
## ------------------------------ PSTH -------------------------------------##
# 192: AI1,x
# 193: AI2,y
# 194: AI3,pupil x
# analog_3: spike 4, raw data
# 131: spike4, LFP
# event_20: hold fix
# 21: target show
# 23:  target off, memory start
# 25: start respons

gf = Graphics(filename,trial_start_mark="9",comment_expr="key:value",analog_to_load="none")
# gf.to_numeric(['type'])

df = gf.data_df
chan_list = range(33,65)
for chan in chan_list:
    gf.plot_spike(channel="spike_"+str(chan)+"_1",sort_by=["olf"],align_to="event_23",pre_time=-1000,post_time=7000,fig_column=3)
    figname = fl+" Channnel= "+str(chan)+'1.jpg'
    savename = os.path.join(root,figname)
    plt.savefig(savename);
    plt.suptitle(fl+" Channnel= "+str(chan))
#print(fl);



