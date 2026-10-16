% SETUP  Add the figure-plotting code and the simulation wrapper to the MATLAB path.
%
% Run once per MATLAB session from the repository root, then
%   - run any figure script by name, e.g.  Fig2_TMP_dynamics  or
%     S15ab_Fig_pore_radius_SAP_EP. Panels are shown on screen; call
%     save_figures(true) to also save them as PDF.
%   - simulate your own pulse:  out = run_HHK(V_stim, tp);  plot_HHK(out)
%
% Only the top level of model/ is added (run_HHK, plot_HHK). The RC
% subfolders are intentionally NOT added: each one defines functions with
% the same names for a different RC value; run_HHK selects the right one.

root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'figures_code', 'main'));
addpath(fullfile(root, 'figures_code', 'SI'));
addpath(fullfile(root, 'figures_code', 'utils'));
addpath(fullfile(root, 'model'));
if ~isappdata(groot, 'HHK_save_figures')
    setappdata(groot, 'HHK_save_figures', false);
end
fprintf('HHK repository paths set (root: %s)\n', root);
