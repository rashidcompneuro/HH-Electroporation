function out = collect_HHK(S)
% COLLECT_HHK  Gather the results of an HHK_single_pulse.m run into one structure.
%
%   out = collect_HHK(S)
%
%   S is a structure holding the variables the model script leaves behind
%   (t_tot, y_tot, gshunt_1, A_p1_full, Pore1_formed, solutions1, t4, y4, ...).
%   Used by run_HHK and by plot_HHK (when called right after running
%   HHK_single_pulse.m directly). See run_HHK for the fields of out.

if isfield(S, 't_tot')
    t = S.t_tot; y = S.y_tot;
else  % the model stopped early (e.g. cell destruction): keep what was computed
    t = [S.t1; S.t2_full; S.t3_full];
    y = [S.y1; S.y2_full; S.y3_full];
end
out = struct();
out.t = t;
names = {'V1','V2','m1','n1','h1','m2','n2','h2','N1','N2'};
for k = 1:numel(names)
    out.(names{k}) = y(:, k);
end
n = numel(t);
out.gep1 = fit_length(S.gshunt_1, n);
out.gep2 = fit_length(S.gshunt_2, n);
out.FPA1 = fit_length(S.A_p1_full / S.A1, n);
out.FPA2 = fit_length(S.A_p2_full / S.A2, n);

if isfield(S, 'Pore1_formed')
    out.pores = struct('DP', S.Pore1_formed(:), 'HP', S.Pore2_formed(:));
else
    out.pores = struct('DP', S.Pore1(:), 'HP', S.Pore2(:));
end
out.radius = pore_radii(S, out.pores);
end


function x = fit_length(x, n)
% Conductance and pore area are stored per solver step; align with t.
x = x(:);
if numel(x) >= n
    x = x(1:n);
else
    x = [x; nan(n - numel(x), 1)];
end
end


function R = pore_radii(S, pores)
% Large-pore radius of every launched pore group versus time. Each group is
% a pair of state variables (DP, HP) appended at its launch time.
segT = {S.t1};
segY = {zeros(numel(S.t1), 10)};
for c = {'solutions1', 'solutions2'}
    if isfield(S, c{1})
        for k = 1:numel(S.(c{1}))
            M = S.(c{1}){k};
            if ~isempty(M)
                segT{end+1} = M(:, 1); %#ok<AGROW>
                segY{end+1} = M(:, 2:end); %#ok<AGROW>
            end
        end
    end
end
if isfield(S, 't4') && isfield(S, 'y4')
    segT{end+1} = S.t4;
    segY{end+1} = S.y4;
end

G = max(cellfun(@(Y) (size(Y, 2) - 10) / 2, segY));
R.t = vertcat(segT{:});
R.DP = nan(numel(R.t), G);
R.HP = nan(numel(R.t), G);
row = 0;
for s = 1:numel(segT)
    Y = segY{s};
    rows = row + (1:size(Y, 1));
    g = (size(Y, 2) - 10) / 2;   % groups launched by this segment
    R.DP(rows, 1:g) = Y(:, 11:2:end);
    R.HP(rows, 1:g) = Y(:, 12:2:end);
    row = rows(end);
end
% groups in which no large pores formed carry no physical radius
R.DP(:, no_pores(pores.DP, G)) = NaN;
R.HP(:, no_pores(pores.HP, G)) = NaN;
end


function mask = no_pores(counts, G)
mask = false(1, G);
m = min(G, numel(counts));
mask(1:m) = counts(1:m)' == 0;
end
