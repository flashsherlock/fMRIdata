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
# for each name in namelist
for name in namelist:
    gl.overlaycloseall()
    ovimage = 'sm_'+name+'+tlrc'
    gl.overlayload(data_dir + ovimage)

    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(1,"4hot")
    gl.minmax(1, 2.5, 6.5)
    gl.opacity(1, 100)

    # Set the color bar options
    if name == namelist[0]:
        gl.colorbarposition(2)
    else:
        gl.colorbarposition(0)
    gl.colorbarsize(0.05)

    # Set mosaic slices 
    gl.mosaic("C H 0 V 0 -4")

    # Save the image 
    gl.savebmp(data_dir + 'aplot'+ name +'.png')
# Open overlay
namelist = ['OFC_AAL_odor_all_t', 'OFC_AAL_face_inv_t', 'OFC_AAL_face_vis_t']
# for each name in namelist
for name in namelist:
    gl.overlaycloseall()
    ovimage = 'sm_'+name+'+tlrc'
    gl.overlayload(data_dir + ovimage)

    # Set overlay display parameters; 1 indicates 1st overlay
    gl.colorname(1, "4hot")
    gl.minmax(1, 2.5, 6.5)
    gl.opacity(1, 100)

    # Set the color bar options
    if name == namelist[0]:
        gl.colorbarposition(2)
    else:
        gl.colorbarposition(0)
    gl.colorbarsize(0.05)

    # Set mosaic slices
    gl.mosaic("A H 0 V 0 -15")

    # Save the image
    gl.savebmp(data_dir + 'aplot' + name + '.png')
