# Find respiration points in the acq file

## respir[number][.m/.fig]
A GUI programm to mark respiration points (start peak stop).

Important variables in this programm.

| handles.      | Meaning                                   |
| ---------     | -------                                   |
| workingpath   | working directory                         |
| datatype      | 'acq' or 'mat'                            |
| choosetype    | which kind of point(start,peak,stop)      |
| filename      | current filename                          |
| savename      | filename of the file to be saved          |
| findpara      | initial(dfault) parameters for findres    |
| usepara       | parameters saved when use for findres     |
| plotnum       | index of current respiration(plot)        |
| resnum        | total number of respirations              |
| tempdata      | data edited in this GUI                   |
| points        | a matrix storing respiration points       |
| guisave       | initial data loaded                       |

Range to find local minimum values for choosing points manually is 15.

Objects on the GUI

| handles.   | Object                       | handles.   | Object                               |
| ---------  | -------                      | ---------  | -------                              |
| path       | enter working path           | clear      | delete current respiration           |
| setpath    | set workingpath with GUI     | add        | add a respiration (start,peak,stop)  |
| data       | data files in current folder | choose     | choose point manually (press 'v' key)|
| mat        | toggle data type for .mat    | name       | filename for saving                  |
| acq        | toggle data type for .acq    | save       | save data (press 's' key)            |
| load       | load data                    | start      | change mode to find start            |
| smoothtype | function used to smooth data | peak       | change mode to find peaks            |
| winsize    | window size for smoothing    | stop       | change mode to find stop             |
| smooth     | do smooth                    | position   | scroll bar to set position           |
| seconds    | interval between peaks       | left       | previous respiration (press 'd' key) |
| rate       | percent of height            | right      | next respiration (press 'f' key)     |
| chmin      | whether find local minimum   | currentnum | current respiration number           |
| rangestart | range for finding start      | allnum     | the number of total respiration      |
| rangestop  | range for finding stop       | plot       | the axes                             |
| find       | find points automatically    | plotall    | plot all data                        | 

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