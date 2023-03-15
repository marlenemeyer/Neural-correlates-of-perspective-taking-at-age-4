

% Data location
data_location = TFR_Clustered_Data;
save_data_location = TFR_Clustered_Data;

% Condition name
Condition_Name = cond_labels;

% Channel list
Channels = cluster_labels;

%% PT vs. Color
% 
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
    
    % Average PT vs. Average Color
    data_file = ['compare_mean_PT_vs_mean_Color_tf_signif_', Channels{chan}, '.mat'];
    disp(['Load channel cluster ' Channels{chan}]);
    load([Stats_data data_file])
    clear data_file tf_signif
    
    data_file1 = [data_location Condition_Name{1} , '_tf_', Channels{chan}];
    load(data_file1)
    mean_tf_data_PT_Can = mean_tf_data;
    clear mean_tf_data tf_data
    
    data_file2 = [data_location Condition_Name{2} , '_tf_', Channels{chan}];
    load(data_file2)
    mean_tf_data_PT_DoesNot = mean_tf_data;
    clear mean_tf_data tf_data
    
    data_file3 = [data_location Condition_Name{3} , '_tf_', Channels{chan}];
    load(data_file3)
    mean_tf_data_Color_Y = mean_tf_data;
    clear mean_tf_data tf_data
    
    data_file4 = [data_location Condition_Name{4} , '_tf_', Channels{chan}];
    load(data_file4)
    mean_tf_data_Color_R = mean_tf_data;
    clear mean_tf_data tf_data
    
    
    mean_PT = (mean_tf_data_PT_Can + mean_tf_data_PT_DoesNot) ./2;
    mean_Color = (mean_tf_data_Color_Y + mean_tf_data_Color_R) ./2;
    
    diff_mean_tf_data3 = (mean_PT - mean_Color)./(mean_PT + mean_Color);
    idx_time_used = ismember(times, times_used4analysis);
    diff_mask = diff_mean_tf_data3(:,idx_time_used);
    diff_mask(tf_data_pvals{1} > 0.05) = 0;
    clear tf_data_pvals
    
    subplot(3,5,idx_subplot(chan))
    contourf(times_used4analysis, freqs, diff_mask, 20,'linecolor','none');
    set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
    set(gca,'FontName','Times New Roman', 'FontSize', 14);
    title(['PT - Color ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
        
    if  chan==1
        colorbar('eastoutside' )
    end
    
    
    ylabel ('Frequency (Hz)')
    colormap('jet')
    
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% To create a colorbar
%cbar('vert',0);
set(gca,'FontName','Times New Roman', 'FontSize', 14);

saveas(gcf, [Figures 'TFR_signifMask_Avg_PT_vs_Color_Contrasts'], 'png')
saveas(gcf, [Figures 'TFR_signifMask_Avg_PT_vs_Color_Contrasts'], 'fig')

%% PT Can See vs. Does Not See
% 
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
    
    % load results from stats contrasting PT Can See and Does Not See
    data_file = ['compare_PT_CanSee_vs_DoesNotSee_tf_signif_', Channels{chan}, '.mat'];
    disp(['Load channel cluster ' Channels{chan}]);
    load([Stats_data data_file])
    clear data_file tf_signif

    data_file1 = [data_location Condition_Name{1} , '_tf_', Channels{chan}];
    load(data_file1)
    mean_tf_data_PT_Can = mean_tf_data;
    clear mean_tf_data tf_data
    
    data_file2 = [data_location Condition_Name{2} , '_tf_', Channels{chan}];
    load(data_file2)
    mean_tf_data_PT_DoesNot = mean_tf_data;
    clear mean_tf_data tf_data
    
    diff_mean_tf_data3 = (mean_tf_data_PT_DoesNot - mean_tf_data_PT_Can)./(mean_tf_data_PT_Can + mean_tf_data_PT_DoesNot);
    idx_time_used = ismember(times, times_used4analysis);
    diff_mask = diff_mean_tf_data3(:,idx_time_used);
    diff_mask(tf_data_pvals{1} > 0.05) = 0;
    clear tf_data_pvals
    
    subplot(3,5,idx_subplot(chan))
    contourf(times_used4analysis, freqs, diff_mask, 20,'linecolor','none');
    set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
    set(gca,'FontName','Times New Roman', 'FontSize', 14);
    title(['PT Can See - Does Not See ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
    
    if  chan==1
        colorbar('eastoutside' )
    end
        
    ylabel ('Frequency (Hz)')
    colormap('jet')
    
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% To create a colorbar
%cbar('vert',0);
set(gca,'FontName','Times New Roman', 'FontSize', 14);

saveas(gcf, [Figures 'TFR_signifMask_PTCanSee_vs_DoesNotSee_Contrasts'], 'png')
saveas(gcf, [Figures 'TFR_signifMask_PTCanSee_vs_DoesNotSee_Contrasts'], 'fig')

%% Color Not Yellow vs. Yellow
% 
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
    
    % load results from stats contrasting PT Can See and Does Not See
    data_file = ['compare_Color_Y_vs_R_tf_signif_', Channels{chan}, '.mat'];
    disp(['Load channel cluster ' Channels{chan}]);
    load([Stats_data data_file])
    clear data_file tf_signif

    data_file1 = [data_location Condition_Name{3} , '_tf_', Channels{chan}];
    load(data_file1)
    mean_tf_data_Color_Y = mean_tf_data;
    clear mean_tf_data tf_data
    
    data_file2 = [data_location Condition_Name{4} , '_tf_', Channels{chan}];
    load(data_file2)
    mean_tf_data_Color_NotY = mean_tf_data;
    clear mean_tf_data tf_data
    
    diff_mean_tf_data3 = (mean_tf_data_Color_NotY - mean_tf_data_Color_Y)./(mean_tf_data_Color_Y + mean_tf_data_Color_NotY);
    idx_time_used = ismember(times, times_used4analysis);
    diff_mask = diff_mean_tf_data3(:,idx_time_used);
    diff_mask(tf_data_pvals{1} > 0.05) = 0;
    clear tf_data_pvals
    
    subplot(3,5,idx_subplot(chan))
    contourf(times_used4analysis, freqs, diff_mask, 20,'linecolor','none');
    set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
    set(gca,'FontName','Times New Roman', 'FontSize', 14);
    title(['Color Not Yellow - Yellow ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
    
    if  chan==1
        colorbar('eastoutside' )
    end    
    
    ylabel ('Frequency (Hz)')
    colormap('jet')
    
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% To create a colorbar
%cbar('vert',0);
set(gca,'FontName','Times New Roman', 'FontSize', 14);

saveas(gcf, [Figures 'TFR_signifMask_ColorNotY_Y_Contrasts'], 'png')
saveas(gcf, [Figures 'TFR_signifMask_ColorNotY_Y_Contrasts'], 'fig')

