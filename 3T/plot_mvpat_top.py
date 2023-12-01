# Basic set-up 
import gl
gl.resetdefaults()
# set data directory
data_dir = '/Volumes/WD_F/gufei/3T_cw/group/plotmask/'
# Open background image
bgimage = 'MNI152_T1_2009c+tlrc'
# combine data_dir and background image name
gl.loadimage(data_dir + bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)
# Open overlay
namelist=['Amy_odor_all_t','Amy_face_inv_t','Amy_face_vis_t']
# get length of namelist
namelen=len(namelist)
gl.overlaycloseall()
cutoff = 8
# for n from 1 to length of namelist
for n in range(namelen):
    print(n)
    name=namelist[n]
    ovimage = 'sm_'+name+'+tlrc'
    gl.overlayload(data_dir + ovimage)
    gl.generateclusters(n+1, cutoff, 1, 2, 0)
    # set cname according to n
    if n==0:
        cname = '3blue'
    elif n==1:
        cname='2green'
    elif n==2:
        cname='1red'
    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(n+1,cname)
    gl.minmax(n+1, 1, cutoff)
    gl.opacity(n+1, 80)
    gl.zerointensityinvisible(n+1, 1)
    gl.colorbarposition(0)

    # Set mosaic slices 
    gl.mosaic("C H 0 V 0 -5")
    gl.view(16)
    # Save the image 
    gl.savebmp(data_dir + 'aplottop'+ name +'.png')
# Open overlay
namelist = ['OFC_AAL_odor_all_t', 'OFC_AAL_face_inv_t', 'OFC_AAL_face_vis_t']
# get length of namelist
namelen=len(namelist)
gl.overlaycloseall()
cutoff = 5
# for n from 1 to length of namelist
for n in range(namelen):
    print(n)
    name=namelist[n]
    ovimage = 'sm_'+name+'+tlrc'
    gl.overlayload(data_dir + ovimage)
    gl.generateclusters(n+1, cutoff, 1, 2, 0)
    # set cname according to n
    if n==0:
        cname = '3blue'
    elif n==1:
        cname='2green'
    elif n==2:
        cname='1red'
    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(n+1,cname)
    gl.minmax(n+1, 1, cutoff)
    gl.opacity(n+1, 80)
    gl.zerointensityinvisible(n+1, 1)
    gl.colorbarposition(0)

    # Set mosaic slices
    gl.mosaic("A H 0 V 0 -15")
    gl.view(16)
    # change coordinate
    gl.orthoviewmm(-20, 0.5, 0.5)
    # gl.gui_input('a','b','5')
    # Save the image
    gl.savebmp(data_dir + 'aplottop' + name + '.png')
