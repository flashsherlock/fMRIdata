# Basic set-up 
import gl
gl.resetdefaults()
# set data directory
data_dir = '/Volumes/WD_F/gufei/3T_cw/group/absplot/'
# Open background image
bgimage = '/Volumes/WD_F/gufei/3T_cw/group/colin27.nii'
# combine data_dir and background image name
gl.loadimage(bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)
rois = ['Amy', 'OFC_AAL', 'fusiformCA', 'FFV01','whole']
for roi in rois:
    # Set mosaic slices 
    if roi == 'Amy':
        gl.mosaic("C H 0 V 0 -3")
    elif roi == 'OFC_AAL':
        gl.mosaic("A H 0 V 0 -15")
    elif roi == 'fusiformCA':
        gl.mosaic("A H 0 V 0 -20")
    elif roi == 'FFV01':
        gl.mosaic("A H 0 V 0 -20")
    elif roi == 'whole':
        gl.mosaic("A H 0 V 0 -15")
    # Open overlay
    namelist = ['_odorall', '_faceinv',  '_facevis']
    cname = ['3blue', '2green', '1red']
    # get length of namelist
    namelen=len(namelist)
    nc=0
    gl.overlaycloseall()
    # for n from 1 to length of namelist
    for n in range(namelen):
        print(n)        
        name=namelist[n]
        ovimage = roi+name+'_mask+tlrc'
        status = gl.overlayload(data_dir + ovimage)
        # if file exists
        if status:
            # Set overlay display parameters; 1 indicates 1st overlay
            gl.colorname(nc+1,cname[n])
            gl.minmax(nc+1, 0, 1)
            gl.opacity(nc+1, 80)
            gl.zerointensityinvisible(n+1, 1)
            # Set the color bar options 
            gl.colorbarposition(0)
            gl.colorbarsize(0.05)
            nc=nc+1
    # Save the image 
    gl.savebmp(data_dir + roi + '_mask.png')
    
    # for n from 1 to length of namelist
    for n in range(namelen):
        print(n)        
        name=namelist[n]
        # tmap
        gl.overlaycloseall()
        # array for cutoff
        cutoff = [0.15, 0.15]
        ovimage = roi+name+'_t+tlrc'
        status = gl.overlayload(data_dir + ovimage)
        # if file exists
        if status:
            gl.colorname(1,"4hot")
            # gl.minmax(1, 1.5, 5.5)
            # gl.minmax(1, 2.5, 4.5)
            gl.minmax(1, 1.5, 4.5)
            gl.opacity(1, 100)
            gl.colorbarposition(0)
            gl.colorbarsize(0.05)
            # Save the image 
            gl.savebmp(data_dir + roi + name + '_t.png')
    
    # for n from 1 to length of namelist
    for n in range(namelen):
        print(n)        
        name=namelist[n]
        # tmap
        gl.overlaycloseall()
        # array for cutoff
        cutoff = 0.30
        ovimage = roi+name+'_prob+tlrc'
        status = gl.overlayload(data_dir + ovimage)
        # if file exists
        if status:
            gl.generateclusters(1, cutoff, 1, 2, 0)      
            cname='4hot'
            gl.colorname(1,cname)
            gl.minmax(1, cutoff-0.2, cutoff+0.2)
            gl.opacity(1, 80)
            gl.zerointensityinvisible(1, 1)
            # Set the color bar options 
            gl.colorbarposition(0)
            gl.colorbarsize(0.05)
            # Save the image 
            gl.savebmp(data_dir + roi + name + '_prob.png')