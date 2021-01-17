% setup shell
setenv('MATLAB_SHELL', '/bin/bash' );
setenv('DYLD_LIBRARY_PATH','/Applications/freesurfer/7.1.1/lib/gcc/lib:/opt/X11/lib/flat_namespace');
setenv('PATH','/usr/local/sbin:/usr/local/opt/ruby/bin:/Applications/freesurfer/7.1.1/bin:/Applications/freesurfer/7.1.1/fsfast/bin:/Applications/freesurfer/7.1.1/mni/bin:/Users/mac/anaconda3/condabin:/opt/ANTs/bin:/usr/local/fsl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Applications/VMware Fusion.app/Contents/Public:/Library/TeX/texbin:/Applications/MATLAB_R2016b.app/bin:/Users/mac/Library/Python/2.7/bin:/Users/mac/nethack4:/Users/mac/anaconda3/envs/psychopy/lib/python3.6/site-packages/mripy/scripts:/Users/mac/laynii:/Users/mac/go/bin:/Users/mac/abin:/Users/mac/.rvm/bin:/usr/local/lib/ruby/gems/2.7.0/gems/jekyll-4.0.0/exe:/Users/mac/.cargo/bin:/usr/local/opt/fzf/bin');
setenv('FREESURFER_HOME','/Applications/freesurfer/7.1.1')
% FSL Setup
setenv( 'FSLDIR', '/usr/local/fsl' );
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    addpath(genpath(fsmatlab));
end
clear fshome fsmatlab;
fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;

ft_defaults;
