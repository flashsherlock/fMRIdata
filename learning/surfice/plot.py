# https://www.nitrc.org/plugins/mwiki/index.php/surfice:MainPage
# https://github.com/neurolabusc/surf-ice/blob/master/COMMANDS.md
# https://github.com/neurolabusc/surf-ice/issues/20
import gl
import sys
import os
fnm = os.path.expanduser("~")+os.path.sep+'myLUT.clut'
f = open(fnm, "w")
f.write("[INT]\n")
f.write("numnodes=3\n")
f.write("[BYT]\n")
f.write("nodeintensity0=0\n")
f.write("nodeintensity1=120\n")
f.write("nodeintensity2=255\n")
f.write("[RGBA255]\n")
f.write("nodergba0=255|255|180|0\n")
f.write("nodergba1=207|30|21|0\n")
f.write("nodergba2=220|0|0|0\n")
f.close()
print(sys.version)
print(gl.version())
gl.resetdefaults()
gl.meshload('/Volumes/WD_D/gufei/monkey_data/plotroi/BrainNetViewer_20191031/Data/SurfTemplate/BrainMesh_ICBM152Left.nv')
# gl.meshload('/Volumes/WD_D/gufei/monkey_data/plotroi/BrainNetViewer_20191031/Data/SurfTemplate/BrainMesh_ICBM152Left_smoothed.nv')
gl.overlayload('/Volumes/WD_D/gufei/monkey_data/plotroi/all.nii')
gl.overlaysmoothvoxelwisedata(1)
gl.meshcolor(225, 225, 225)
gl.backcolor(0, 0, 0)
gl.overlayminmax(1, 0.3, 2.6)
#gl.overlaycolor(1,255,255,180,210,0,00)
gl.overlaycolorname(1, fnm)
gl.orientcubevisible(0)
gl.viewsagittal(0)
gl.colorbarposition(1)
gl.shadername('Hemispheric')
gl.shaderadjust('Specular', 0)
#gl.shadername('Velvet')
#Phong_Matte Minimal
#gl.shaderadjust('Specular', 0.2)
gl.shaderadjust('Edge', 0)
gl.shaderambientocclusion(0.1)
gl.shaderlightazimuthelevation(1, -3)
gl.savebmp('/Volumes/WD_D/gufei/monkey_data/plotroi/test.png')