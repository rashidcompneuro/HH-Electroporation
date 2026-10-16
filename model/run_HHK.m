function out = run_HHK(V_stim, tp, varargin)
% RUN_HHK  Simulate the HHK model for one rectangular pulse of your choice.
%
%   out = run_HHK(V_stim, tp)
%   out = run_HHK(V_stim, tp, 'RC', 1e-8, 'tf', 20000, 'SaveAs', 'my_run.mat')
%
%   Inputs
%     V_stim   pulse amplitude (mV), e.g. 1500
%     tp       pulse duration in **ms**: 1e-6 = 1 ns, 1e-4 = 100 ns,
%              1e-3 = 1 us, 1 = 1 ms
%
%   Options (name-value)
%     'RC'       cell time constant in seconds, as in the paper:
%                1e-8 (default, main text), 1e-7, or 1e-6 (SI)
%     'tf'       total simulated time (ms), default 20000. The pulse starts
%                at 5 ms; a shorter tf runs faster if you only need the
%                first action potentials.
%     'SaveAs'   .mat file to save the result to (default: not saved)
%     'Verbose'  true to show the solver's own progress messages (default false)
%
%   Output: a structure with
%     t                time (ms)
%     V1, V2           transmembrane potential, depolarised (DP) and
%                      hyperpolarised (HP) side (mV)
%     m1 n1 h1 m2 n2 h2  gating variables (1 = DP, 2 = HP)
%     N1, N2           small-pore density (1/m^2)
%     gep1, gep2       electroporation (shunt) conductance (mS/cm^2)
%     FPA1, FPA2       fractional pore area
%     radius           large-pore radii: .t (ms), .DP and .HP (m), one column
%                      per launched pore group (NaN before launch / no pores)
%     pores            number of large pores in each group: .DP, .HP
%     status           'completed', or what stopped the run (e.g. cell death)
%     params, runtime_s, log
%
%   Plot the result with plot_HHK(out). Example:
%     out = run_HHK(1500, 1e-4);     % 1500 mV, 100 ns, RC = 1e-8 s
%     plot_HHK(out)
%
%   How it works: this runs the unchanged model script
%   model/RC_<...>ms/HHK_single_pulse.m (the code used for the paper) on a
%   temporary copy in which only V_stim, tp and tf are replaced.

p = inputParser;
p.addRequired('V_stim', @(x) isnumeric(x) && isscalar(x));
p.addRequired('tp', @(x) isnumeric(x) && isscalar(x) && x > 0);
p.addParameter('RC', 1e-8, @(x) isnumeric(x) && isscalar(x));
p.addParameter('tf', 20000, @(x) isnumeric(x) && isscalar(x) && x > 5);
p.addParameter('SaveAs', '', @(x) ischar(x) || isstring(x));
p.addParameter('Verbose', false, @(x) islogical(x) || isnumeric(x));
p.parse(V_stim, tp, varargin{:});
opt = p.Results;

%% Pick the model folder for this RC
switch sprintf('%.0e', opt.RC)
    case '1e-08', folder = 'RC_1e-5ms'; script = 'HHK_single_pulse.m';
    case '1e-07', folder = 'RC_1e-4ms'; script = 'HHK_single_pulse.m';
    case '1e-06', folder = 'RC_1e-3ms'; script = 'HHK_single_pulse.m';
    otherwise
        error('run_HHK:RC', 'RC must be 1e-8, 1e-7 or 1e-6 (seconds).');
end
modelDir = fullfile(fileparts(mfilename('fullpath')), folder);

%% Temporary copy of the model script with the requested pulse
src = fileread(fullfile(modelDir, script));
src = set_value(src, 'V_stim', opt.V_stim);
src = set_value(src, 'tp', opt.tp);
src = set_value(src, 'tf', opt.tf);
% keep the user's open figures and command window
src = regexprep(src, '(?m)^close all; clear all; clc;', 'clear all;', 'once');

tmpDir = tempname;
mkdir(tmpDir);
tmpFile = fullfile(tmpDir, 'HHK_single_pulse_run.m');
fid = fopen(tmpFile, 'w');
fwrite(fid, src);
fclose(fid);

% Use this folder's model functions: run from the temporary folder (so the
% current folder cannot shadow them) with modelDir first on the path.
oldDir = cd(tmpDir);
oldPath = addpath(modelDir);
cleanup = onCleanup(@() restore(oldDir, oldPath, tmpDir));

fprintf('HHK run: V_stim = %g mV, pulse = %s, RC = %g s, %g ms simulated ...\n', ...
    opt.V_stim, duration_str(opt.tp), opt.RC, opt.tf);
tic;
[S, logText] = run_model_script(tmpFile, opt.Verbose);
runtime = toc;

%% Collect the results
out = collect_HHK(S);
out.params = struct('V_stim_mV', opt.V_stim, 'tp_ms', opt.tp, 'RC_s', opt.RC, ...
    'tf_ms', opt.tf, 'ton_ms', 5, 'model', fullfile('model', folder, script));
out.status = run_status(S, logText);
out.runtime_s = runtime;
out.log = logText;

fprintf('Done in %.0f s. Status: %s\n', runtime, out.status);

if strlength(string(opt.SaveAs)) > 0
    save(opt.SaveAs, 'out');
    fprintf('Saved to %s\n', opt.SaveAs);
end
end


%% ------------------------------------------------------------------------
function src = set_value(src, name, value)
% Replace the line "name = <number>; ..." of the model script.
pat = ['(?m)^' name '\s*=\s*[^;\n]+;'];
if numel(regexp(src, pat)) ~= 1
    error('run_HHK:script', 'Could not find a unique "%s = ...;" line in the model script.', name);
end
src = regexprep(src, pat, sprintf('%s = %.17g;', name, value), 'once');
end


function [S, logText] = run_model_script(file, verbose)
% Runs the script in this function's own workspace (it starts with
% "clear all") and returns all variables it leaves behind.
if verbose
    logFile = [tempname '.txt'];
    diary(logFile);
    run(file);
    diary('off');
    logText = fileread(logFile);
    delete(logFile);
else
    logText = evalc('run(file)');
end
vars = who;
S = struct();
for k = 1:numel(vars)
    if ~any(strcmp(vars{k}, {'logText', 'logFile', 'S', 'k', 'vars'}))
        S.(vars{k}) = eval(vars{k});
    end
end
end


function s = run_status(S, logText)
if contains(logText, 'Cell destruction: A_p1 or A_p2')
    s = 'stopped: cell death by supra-electroporation (pore area above 1.26 %)';
elseif contains(logText, 'Cell destruction1') || contains(logText, 'Cell destruction2')
    s = 'stopped: cell death by irreversible electroporation (a pore radius above 100 nm)';
elseif contains(logText, 'Radius of a pore reached 100 nm') || contains(logText, 'Irreversible electroporation')
    s = 'irreversible electroporation detected (a pore radius reached 100 nm)';
elseif contains(logText, 'Error occurred')
    line = regexp(logText, 'Error occurred[^\n]*', 'match', 'once');
    s = ['solver error: ' line];
elseif ~isfield(S, 't_tot')
    s = 'stopped early';
else
    s = 'completed';
end
end


function s = duration_str(tp)
if tp < 1e-3
    s = sprintf('%g ns', tp * 1e6);
elseif tp < 1
    s = sprintf('%g us', tp * 1e3);
else
    s = sprintf('%g ms', tp);
end
end


function restore(oldDir, oldPath, tmpDir)
path(oldPath);
cd(oldDir);
if exist(tmpDir, 'dir')
    rmdir(tmpDir, 's');
end
end
