function root = project_root()
% PROJECT_ROOT  Absolute path of the repository root (folder containing setup.m).
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
end
