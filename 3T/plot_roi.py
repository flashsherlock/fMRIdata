# Basic set-up 
import gl
gl.resetdefaults()
# set data directory
data_dir = '/Volumes/WD_F/gufei/3T_cw/group/mask/'
# Open background image
bgimage = 'MNI152_T1_2009c+tlrc'
# combine data_dir and background image name
gl.loadimage(data_dir + bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)
# Open overlay
namelist = ['OFC_AAL', 'Amy8_align.freesurfer', 'FusiformCA']
# get length of namelist
namelen=len(namelist)
# for n from 1 to length of namelist
gl.overlaycloseall()
for n in range(namelen):
    print(n)
    name=namelist[n]
    ovimage = name+'+tlrc'
    gl.overlayload(data_dir + ovimage)
    # set cname according to n
    if n==0:
        cname = '3blue'
    elif n==1:
        cname='2green'
    elif n==2:
        cname='1red'
    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(n+1,cname)
    # gl.minmax(n+1, 0, 1)
    # gl.opacity(n+1, 80)
    gl.zerointensityinvisible(n+1, 1)
# Set the color bar options 
gl.colorbarposition(0)
gl.colorbarsize(0.05)

# Set mosaic slices 
gl.mosaic("A H 0 V 0 0.33")
# Save the image 
gl.savebmp(data_dir + 'ROIs.png')

# # individual
# import gl
# gl.resetdefaults()
# # set data directory
# subject = 'S03'
# data_dir = '/Volumes/WD_F/gufei/3T_cw/'+subject+'/'
# # Open background image
# bgimage = subject+'.de.results/anat_final.'+subject+'.de+orig'
# # combine data_dir and background image name
# gl.loadimage(data_dir + bgimage)
# # Jagged (0) or smooth (1) interpolation of overlay  
# gl.overlayloadsmooth(0)
# gl.smooth(0)
# # Open overlay
# namelist = ['OFC_AAL', 'Amy8_align.freesurfer', 'FFV_CA_max2vdo']
# # get length of namelist
# namelen=len(namelist)
# # for n from 1 to length of namelist
# gl.overlaycloseall()
# for n in range(namelen):
#     print(n)
#     name=namelist[n]
#     ovimage = 'mask/'+name+'+orig'
#     gl.overlayload(data_dir + ovimage)
#     # set cname according to n
#     if n==0:
#         cname = '3blue'
#     elif n==1:
#         cname='2green'
#     elif n==2:
#         cname='1red'
#     # Set overlay display parameters; 1 indicates 1st overlay
#     gl.colorname(n+1,cname)
#     # gl.minmax(n+1, 0, 1)
#     # gl.opacity(n+1, 80)
#     gl.zerointensityinvisible(n+1, 1)
# # Set the color bar options 
# gl.colorbarposition(0)
# gl.colorbarsize(0.05)
# # Set mosaic slices 
# gl.mosaic("A H 0 V 0 0.3 0.4; 0.55 0.60")