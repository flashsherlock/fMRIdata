from NeoAnalysis import SpikeSorting

# if want to display 3-D view for the first three dimension of PCA, please set pca_3d = True
# the 3-D view is well tested on mac, ubuntu and win 10
# However, it is not work will on win 7, which may be due to some incompatibility of dependent packages
# However, this does not affect automatically and manually sorting. And uses can also use PCA view, which 
# also provide 1-2, 1-3, and 2-3 PCA components views separately.

# you can load spike_sorting_data.h5 for testing
# SpikeSorting(pca_3d=False)

SpikeSorting(pca_3d = True)