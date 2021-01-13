function fsa = mni2fsa( mni )
% transform coordinates from MNI space (n*3) to fsaverage
% https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems

% transform matrix
M=[ 1.0022    0.0071   -0.0177    0.0528;...
   -0.0146    0.9990    0.0027   -1.5519;...
    0.0129    0.0094    1.0027   -1.2012];
% tranform by M*v
v=mni;
% add ones to the 4th column
v(:,4)=1;
% transposition to 4*n
v=v';
% 3*4 * 4*n = 3*n
v=M*v;
% transposition to n*3
fsa=v';

end

