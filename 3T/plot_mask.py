# Basic set-up 
import gl
gl.resetdefaults()
# set data directory
data_dir = '/Volumes/WD_F/gufei/3T_cw/group/plotmask/'
# Open background image
# bgimage = 'MNI152_T1_2009c+tlrc'
bgimage = '../colin27.nii'
# combine data_dir and background image name
gl.loadimage(data_dir + bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)
# rois
rois = ['Amy', 'OFC_AAL']
for roi in rois:    
    # Open overlay
    namelist = ['inter3', 'visinv', 'visodo', 'invodo']
    # get length of namelist
    namelen=len(namelist)
    # for n from 1 to length of namelist
    for n in range(namelen):
        gl.overlaycloseall()
        print(n)
        name=namelist[n]
        # ovimage = 'sm_'+name+'+tlrc'
        ovimage = 'sm_'+roi+'_'+name+'.nii'
        gl.overlayload(data_dir + ovimage)            
        cname='1red'
        # Set overlay display parameters; 1 indicates 1st overlay
        gl.colorname(1,cname)
        gl.minmax(1, 0, 1)
        gl.opacity(1, 80)
        gl.zerointensityinvisible(1, 1)
        # Set the color bar options 
        gl.colorbarposition(0)
        gl.colorbarsize(0.05)
        # Set mosaic slices 
        if roi == 'Amy':
            gl.mosaic("C H 0 V 0 -5")
        elif roi == 'OFC_AAL':
            gl.mosaic("A H 0 V 0 -15")

        # Save the image 
        gl.savebmp(data_dir + 'cplot_' + roi + '_' + name + '.png')
        
# plot percentage of
import gl
gl.resetdefaults()
# set data directory
data_dir = '/Volumes/WD_F/gufei/3T_cw/group/plotmask/'
# Open background image
# bgimage = 'MNI152_T1_2009c+tlrc'
bgimage = '../colin27.nii'
# combine data_dir and background image name
gl.loadimage(data_dir + bgimage)
# Jagged (0) or smooth (1) interpolation of overlay  
gl.overlayloadsmooth(0)
gl.smooth(0)  
# Open overlay
namelist = ['Amy', 'OFC_AAL']
# array for cutoff
cutoff = [0.15, 0.15]
# get length of namelist
namelen=len(namelist)
# for n from 1 to length of namelist
for n in range(namelen):
    gl.overlaycloseall()
    print(n)
    name=namelist[n]
    ovimage = '../mvpa/'+'sm_percent_'+name+'+tlrc'
    gl.overlayload(data_dir + ovimage)      
    gl.generateclusters(1, cutoff[n], 1, 2, 0)      
    cname='4hot'
    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(1,cname)
    gl.minmax(1, 0.1, cutoff[n]+0.05)
    gl.opacity(1, 80)
    gl.zerointensityinvisible(1, 1)
    # Set the color bar options 
    gl.colorbarsize(0.05)
    # Set mosaic slices 
    if name == 'Amy':
        gl.colorbarposition(2)
        gl.mosaic("C H 0 V 0 -5")
    elif name == 'OFC_AAL':
        gl.colorbarposition(0)
        gl.mosaic("A H 0 V 0 -15")

    # Save the image 
    gl.savebmp(data_dir + 'cplot_' + name + '_' + 'percent' + '.png')
    
# # Basic set-up 
# import gl
# gl.resetdefaults()
# # set data directory
# data_dir = '/Volumes/WD_F/gufei/3T_cw/group/plotmask/'
# # Open background image
# bgimage = 'MNI152_T1_2009c+tlrc'
# # combine data_dir and background image name
# gl.loadimage(data_dir + bgimage)
# # Jagged (0) or smooth (1) interpolation of overlay  
# gl.overlayloadsmooth(0)
# gl.smooth(0)
# # Open overlay
# # namelist=['Amy_odor_all_t','Amy_face_inv_t','Amy_face_vis_t']
# namelist = ['Amy_face_vis', 'Amy_face_inv',  'Amy_odor_all']
# # get length of namelist
# namelen=len(namelist)
# # for n from 1 to length of namelist
# for n in range(namelen):
#     print(n)
#     name=namelist[n]
#     # ovimage = 'sm_'+name+'+tlrc'
#     ovimage = 'sm_'+name+'_0.001.nii'
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
#     gl.minmax(n+1, 0, 1)
#     gl.opacity(n+1, 80)
#     gl.zerointensityinvisible(n+1, 1)
# gl.overlayload(data_dir + 'Amy_inter_inv.nii')
# gl.colorname(4, 'Plasma')
# gl.minmax(n, 0, 1)
# gl.opacity(n, 80)
# gl.zerointensityinvisible(n, 1)
# # Set the color bar options 
# gl.colorbarposition(0)
# gl.colorbarsize(0.05)

# # Set mosaic slices 
# gl.mosaic("C H 0 V 0 -5")

# # Save the image 
# gl.savebmp(data_dir + 'aplot_Amy_mask.png')
# # OFC_AAL
# gl.overlaycloseall()
# namelist = ['OFC_AAL_face_vis', 'OFC_AAL_face_inv',  'OFC_AAL_odor_all']
# # get length of namelist
# namelen=len(namelist)
# # for n from 1 to length of namelist
# for n in range(namelen):
#     print(n)
#     name=namelist[n]
#     # ovimage = 'sm_'+name+'+tlrc'
#     ovimage = 'sm_'+name+'_0.001.nii'
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
#     gl.minmax(n+1, 0, 1)
#     gl.opacity(n+1, 80)
#     gl.zerointensityinvisible(n+1, 1)

# # Set the color bar options 
# gl.colorbarposition(0)
# gl.colorbarsize(0.05)

# # Set mosaic slices 
# gl.mosaic("A H 0 V 0 -15")

# # Save the image 
# gl.savebmp(data_dir + 'aplot_OFC_AAL_mask.png')
