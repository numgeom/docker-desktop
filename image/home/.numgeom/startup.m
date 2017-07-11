run ~/fastsolve/ilupack4m/startup.m
run ~/fastsolve/paracoder/startup.m
run ~/fastsolve/petsc4m/startup.m
run ~/numgeom2/ahf-plus/matlab/startup.m

if ~exist('OCTAVE_VERSION', 'builtin')
    % Set up MBeautifier in MATLAB
    addpath('~/numgeom2/MBeautifier')
    MBeautifier.setup
end
