# individual
import gl
gl.resetdefaults()
# set data directory
subject = 'S26'
# subject = 'S27'
data_dir = '/Volumes/WD_F/gufei/3T_cw/'+subject+'/'
fig_dir = '/Volumes/WD_F/gufei/3T_cw/group/plotmask/'
# Open background image
bgimage = subject+'.de.results/anat_final.'+subject+'.de+orig'
# combine data_dir and background image name
gl.loadimage(data_dir + bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)
# Open overlay
# FFV is deobliqued by 3drefit -deoblique
# 3dcopy FFV_CA_max3v+orig FFV_CA_max3vdo
# 3drefit -deoblique FFV_CA_max3vdo+orig
namelist = ['OFC_AAL', 'Amy8_align.freesurfer', 'FFV_CA_max3vdo']
# get length of namelist
namelen=len(namelist)
# for n from 1 to length of namelist
for n in range(namelen):
    gl.overlaycloseall()
    print(n)
    name=namelist[n]
    ovimage = 'mask/'+name+'+orig'
    gl.overlayload(data_dir + ovimage)
    # set cname according to n
    # if n==0:
    #     cname = '3blue'
    # elif n==1:
    #     cname='2green'
    # elif n==2:
    #     cname='1red'
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
    if n==0:
        gl.mosaic("A H 0 V 0 29")
    elif n==1:
        gl.mosaic("C H 0 V 0 33")
    elif n==2:
        gl.mosaic("A H 0 V 0 5")  
    # cut the name to get the first 3 letters
    gl.savebmp(fig_dir + 'indiv_' + name[:3] + '.png')
