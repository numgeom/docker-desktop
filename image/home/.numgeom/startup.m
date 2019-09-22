run ~/project/fastsolve/ilupack4m/startup.m
run ~/project/fastsolve/paracoder/startup.m
run ~/project/fastsolve/petsc4m/startup.m
run ~/project/numgeom2/ahf-plus/matlab/startup.m

if ~exist('OCTAVE_VERSION', 'builtin')
    % Set up MBeautifier in MATLAB
    addpath('~/project/numgeom2/MBeautifier')
end
