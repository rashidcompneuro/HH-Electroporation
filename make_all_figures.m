function make_all_figures()
% MAKE_ALL_FIGURES  Regenerate every figure panel of the paper and SI and save
% them as PDF to figures/main and figures/SI.

root = fileparts(mfilename('fullpath'));
run(fullfile(root, 'setup.m'));
save_figures(true);

scripts = {
    'Fig2_TMP_dynamics'
    'Fig3a_SD_1ns_to_1ms'
    'Fig3b_SD_10ns_to_1us'
    'Fig3c_SD_1ns_to_20ns'
    'Fig3_legend'
    'Fig4_pore_conductance'
    'Fig5_channel_conductance'
    'Fig6a_TMP_1ns'
    'Fig6bcd_AP_features_1ns'
    'Fig6ef_currents_1ns'
    'Fig7a_thresholds_vs_RC'
    'Fig7bcd_safety_factor'
    'Fig8_supra_EP'
    'Fig9_IRE'
    'Fig10_energy_landscape'
    'S02_Fig_Smith_benchmark'
    'S05_Fig_Boinagrov_TMP_benchmark'
    'S06_Fig_HH_SD_benchmark'
    'S07_Fig_HH_vs_HHK_benchmark'
    'S09_Fig_excitation_10us'
    'S10_Fig_excitation_1us'
    'S11_Fig_excitation_1ns'
    'S12_S13_Fig_gating_variables'
    'S14ab_Fig_pores_RC10ns'
    'S14cd_Fig_pores_RC1us'
    'S15ab_Fig_pore_radius_SAP_EP'
    'S15cd_Fig_pore_radius_RS'
    'S15ef_Fig_pore_radius_DB'
    'S16_Fig_ionic_currents'
    'S17_Fig_AP_features'
    'S18a_Fig_SD_10ns_to_1ms'
    'S18bc_Fig_SD_10ns_to_3us'
    'S19a_Fig_relative_SD_RC10ns'
    'S19b_Fig_relative_SD_RC1us'
    'S20_Fig_supra_EP_DP'
    'S21_Fig_IRE_DP'
    };

failed = {};
for k = 1:numel(scripts)
    fprintf('[%2d/%d] %s\n', k, numel(scripts), scripts{k});
    if ~run_isolated(scripts{k})
        failed{end+1} = scripts{k}; %#ok<AGROW>
    end
    close all force
end

if isempty(failed)
    fprintf('All %d scripts finished. PDFs are in %s\n', numel(scripts), fullfile(root, 'figures'));
else
    fprintf(2, 'Failed: %s\n', strjoin(failed, ', '));
end
end

function ok = run_isolated(name)
% The figure scripts start with "clear all", so each one runs in this
% function's own workspace and reports back through appdata.
setappdata(groot, 'HHK_last_ok', false);
try
    run(name);
    setappdata(groot, 'HHK_last_ok', true);
catch err
    fprintf(2, '  failed: %s\n', err.message);
end
ok = getappdata(groot, 'HHK_last_ok');
end
