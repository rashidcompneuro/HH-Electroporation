addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% ================================================================
%  Extract spike latency / T50% / T90% / V_AP from your already-saved runs
%
%  Matches the ACTUAL save format of HHK_array_of_pulse.m: a single .mat
%  file per sweep, saved via bare `save(fullpath)`, containing
%  V_stim_values (vector) and all_t_tot{v} / all_y_tot{v} (cell arrays,
%  one entry per V_stim). One "source" entry below therefore expands
%  into many rows of the results table -- not a one-file-per-V_stim list.
%
%  Also supports your standalone-HH sweep format (Vstim_list / t_all /
%  V_all, as produced by HH_Vstim_sweep.m) and, for older/other files,
%  a plain single-run t_tot/y_tot or name-embedded convention.
%
%  T90% is included alongside T50% as a cross-check on whether an
%  EP-driven duration increase is concentrated in the early/fast
%  repolarization phase or the late tail.
%
%  Requires: compute_AP_metrics.m on path.
%% ================================================================
clear; clc;

ton = 5;   % pulse onset (ms) -- same for all these runs

%% -------------------- List your saved sweep files here --------------------
% Each entry: path, model label, and which save-format it uses:
%   'array'    -- V_stim_values + all_t_tot{v}/all_y_tot{v}   (HHK_array_of_pulse.m)
%   'sweepmat' -- Vstim_list + t_all{k}/V_all{k}               (HH_Vstim_sweep.m)
%   'single'   -- one run per file: t_tot/y_tot, OR names starting
%                 with t_tot_.../y_tot_...  (older per-run saves)
%                 -- needs V_stim given explicitly since the file has no sweep vector.
SOURCES = {
    struct('path', [project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_SAPs_EP_noEP.mat'], ...
           'model', 'HHK', 'type', 'array'), ...
    struct('path', [project_root '/data/raw/HH_model_Boin/HH_Vstim_sweep_results.mat'], 'model', 'HH', 'type', 'sweepmat'), ...
};

%% -------------------- Loop over sources, expand each into rows --------------------
Vstim   = [];
model   = strings(0,1);
latency = [];
T50     = [];
T90     = [];
V_AP    = [];

for s = 1:numel(SOURCES)
    src = SOURCES{s};
    S = load(src.path);

    switch src.type
        case 'array'
            % HHK_array_of_pulse.m convention
            Vlist = S.V_stim_values(:);
            for v = 1:numel(Vlist)
                t = S.all_t_tot{v};
                V = S.all_y_tot{v}(:,1);   % column 1 = V1 (DP side)
                m = compute_AP_metrics(t, V, ton);
                Vstim(end+1,1)   = Vlist(v);            %#ok<SAGROW>
                model(end+1,1)   = src.model;            %#ok<SAGROW>
                latency(end+1,1) = m.spike_latency;      %#ok<SAGROW>
                T50(end+1,1)     = m.T50;                %#ok<SAGROW>
                T90(end+1,1)     = m.T90;                %#ok<SAGROW>
                V_AP(end+1,1)    = m.V_AP;               %#ok<SAGROW>
                fprintf('%-6s V_stim=%5g mV: latency=%.4f ms, T50=%.4f ms, T90=%.4f ms, V_AP=%.3f mV\n', ...
                        src.model, Vlist(v), m.spike_latency, m.T50, m.T90, m.V_AP);
            end

        case 'sweepmat'
            % HH_Vstim_sweep.m convention
            Vlist = S.Vstim_list(:);
            for k = 1:numel(Vlist)
                t = S.t_all{k};
                V = S.V_all{k};
                m = compute_AP_metrics(t, V, ton);
                Vstim(end+1,1)   = Vlist(k);             %#ok<SAGROW>
                model(end+1,1)   = src.model;            %#ok<SAGROW>
                latency(end+1,1) = m.spike_latency;      %#ok<SAGROW>
                T50(end+1,1)     = m.T50;                %#ok<SAGROW>
                T90(end+1,1)     = m.T90;                %#ok<SAGROW>
                V_AP(end+1,1)    = m.V_AP;               %#ok<SAGROW>
                fprintf('%-6s V_stim=%5g mV: latency=%.4f ms, T50=%.4f ms, T90=%.4f ms, V_AP=%.3f mV\n', ...
                        src.model, Vlist(k), m.spike_latency, m.T50, m.T90, m.V_AP);
            end

        case 'single'
            % One run per file -- V_stim must be supplied on the struct
            if isfield(S, 't_tot') && isfield(S, 'y_tot')
                t = S.t_tot;
                V = S.y_tot(:,1);
            else
                fn = fieldnames(S);
                t_name = fn{startsWith(fn, 't_tot')};
                y_name = fn{startsWith(fn, 'y_tot')};
                t = S.(t_name);
                V = S.(y_name)(:,1);
            end
            m = compute_AP_metrics(t, V, ton);
            Vstim(end+1,1)   = src.Vstim;                %#ok<SAGROW>
            model(end+1,1)   = src.model;                %#ok<SAGROW>
            latency(end+1,1) = m.spike_latency;          %#ok<SAGROW>
            T50(end+1,1)     = m.T50;                    %#ok<SAGROW>
            T90(end+1,1)     = m.T90;                    %#ok<SAGROW>
            V_AP(end+1,1)    = m.V_AP;                   %#ok<SAGROW>
            fprintf('%-6s V_stim=%5g mV: latency=%.4f ms, T50=%.4f ms, T90=%.4f ms, V_AP=%.3f mV\n', ...
                    src.model, src.Vstim, m.spike_latency, m.T50, m.T90, m.V_AP);

        otherwise
            error('Unknown source type: %s', src.type);
    end
end

%% -------------------- Save summary --------------------
results = table(Vstim, model, latency, T50, T90, V_AP);
save([project_root '/data/processed/AP_metrics_summary.mat'], 'results', 'Vstim', 'model', 'latency', 'T50', 'T90', 'V_AP');
disp(results);

%% -------------------- Quick T50 vs T90 sanity check --------------------
% If T90/T50 stays roughly constant across V_stim (within a model), EP is
% prolonging the whole repolarization phase proportionally and T50 alone
% is a fine signature. If the ratio grows with V_stim -- especially past
% the EP-onset threshold (1784 mV) -- the prolongation is concentrated in
% the late tail and T90 is the more diagnostic metric.
ratio = T90 ./ T50;
fprintf('\nT90/T50 ratio by run:\n');
for k = 1:numel(Vstim)
    fprintf('  %-6s V_stim=%5g mV: T90/T50 = %.3f\n', model(k), Vstim(k), ratio(k));
end
