function p = fig_path(rel)
% FIG_PATH  Output path under <repo>/figures/ (e.g. 'main/Fig2a.pdf').
p = fullfile(project_root, 'figures', rel);
end
