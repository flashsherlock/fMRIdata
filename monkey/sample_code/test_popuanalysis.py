from NeoAnalysis import PopuAnalysis  
import matplotlib.pyplot as plt     
                                                                         
workspace = '../population_data.h5'     
pg = PopuAnalysis(workspace)                                                                                                
pg.plot_line(store_key = 'reaction_time', conditions=[('a','A'), ('a','B'), ('a','C'),
                                                    ('b','A'), ('b','B'), ('b','C'),
                                                    ('c','A'), ('c','B'), ('c','C')])      

pg.plot_spike(store_key = 'firing_rate', conditions = [('a','A'), ('a','B'), ('b','A'), ('b','B')], 
            normalize = True, fig_mark = [0,1000], err_style = 'ci_band', ci = 68)

plt.show()