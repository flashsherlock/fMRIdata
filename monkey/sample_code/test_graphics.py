from NeoAnalysis import Graphics
import matplotlib.pyplot as plt                                                                                                               # line 2


filename = "../graphics_data.h5"

                                                                     
sg = Graphics(filename = filename, trial_start_mark = '64715', comment_expr = 'key:value')                                                                                                               
print(sg.data_df)                                                                                   
sg.to_numeric(['patch_direction'])                                                                                     
firingRate = sg.plot_spike(channel = 'spike_26_1', sort_by = ['patch_direction'], align_to = 'event_64721', 
                            pre_time = -300, post_time = 2000, bin_size = 30, overlap = 2, Mean=3, Sigma=1, 
                            filter_nan =['event_64721','event_64722'], fig_column = 4, fig_marker = [0,500])     

# spk_count = sg.plot_spike_count(channel = 'spike_26_1', sort_by = ['patch_direction'], 
                                # align_to = 'event_64721', timebin=[0,1000])  




# sptm = sg.plot_spectrogram(channel='analog_26', sort_by=['patch_direction'], align_to='event_64721',    
                            # pre_time=-100, post_time=1000, filter_nan=['event_64722','patch_direction'], color_bar=True) 
                                                                                  
plt.show()      