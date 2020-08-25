# Find respiration points in the acq file

## respir[number][.m/.fig]
A GUI programm to mark respiration points (start peak stop).

Important variables in this programm.

|  handles.   | Meaning  |
|  ---------  | -------  |
| workingpath  | working directory |
| datatype  | 'acq' or 'mat'    |
| choosetype| which kind of point(start,peak,stop)|
| filename  | current filename  |
| savename  | filename of the file to be saved |
| findpara  | initial(dfault) parameters for findres |
| usepara   | parameters saved when use for findres  |
| plotnum   | index of current respiration(plot) |
| resnum    | total number of respirations |
| tempdata  | data edited in this GUI   |
| points    | a matrix storing respiration points|
| guisave   | initial data loaded   | 

## load_acq.m
Load acq files.

## marker_trans.m
Translate markers.

## findres.m
Find respiration points automatically.

## res_analyze.m
Analyze data in acq format(for debug).

## resmat_amalyze.m
Analyze data in mat format(for debug).

## others

### example.m
A script I found to analyze data in breath.mat 

### MovingAverageFilter.m
Examples of filters.