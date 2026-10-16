function save_figures(on)
% SAVE_FIGURES  Turn saving of figure panels as PDF on or off.
%   save_figures(true)   % panels are also written to figures/main and figures/SI
%   save_figures(false)  % panels are only shown on screen (default)
if nargin < 1
    on = true;
end
setappdata(groot, 'HHK_save_figures', logical(on));
if on
    fprintf('Figure panels will be saved as PDF under %s\n', fullfile(project_root, 'figures'));
else
    fprintf('Figure panels will be shown only (not saved)\n');
end
end
