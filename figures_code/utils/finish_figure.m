function finish_figure(h, path, mode, varargin)
% FINISH_FIGURE  Finalise one figure panel.
%   Names the window after the panel (e.g. 'Fig5a') and keeps it open without
%   later plots drawing into it. If saving is on (see save_figures), the panel
%   is also written to PATH as a PDF.
%
%   finish_figure(h, path)                     print(h, path, '-dpdf', '-r0')
%   finish_figure(h, path, 'vector', opts...)  exportgraphics(h, path, 'ContentType', 'vector', opts...)
[~, name] = fileparts(path);
if isempty(name)
    name = 'figure';
end
if isappdata(groot, 'HHK_save_figures') && getappdata(groot, 'HHK_save_figures')
    d = fileparts(path);
    if ~exist(d, 'dir')
        mkdir(d);
    end
    if nargin >= 3 && strcmp(mode, 'vector')
        exportgraphics(h, path, 'ContentType', 'vector', varargin{:});
    else
        print(h, path, '-dpdf', '-r0');
    end
end
% Detach the window so later figure(N)/gcf calls and 'close all' leave it alone
set(h, 'Name', name, 'NumberTitle', 'off', 'IntegerHandle', 'off', 'HandleVisibility', 'off');
end
