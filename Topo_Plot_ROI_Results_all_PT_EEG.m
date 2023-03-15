Condition_Name = cond_labels;
Channels = cluster_labels;

chan=3; % right temporal parietal
    
%% Load all data
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(1)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_Can = zeros([size(tf_data_1) length(subject_list)]);
    end
    tf_all_PT_Can(:,:,:,sub) = tf_data_1;
end

for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(2)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_DoesNot = zeros([size(tf_data_2) length(subject_list)]);
    end
    tf_all_PT_DoesNot(:,:,:,sub) = tf_data_2;
end

tf_all_PT = (tf_all_PT_Can+tf_all_PT_DoesNot)/2;
tf_all_PTCanMinDoesNot = (tf_all_PT_DoesNot-tf_all_PT_Can)./(tf_all_PT_Can+tf_all_PT_DoesNot);

%%
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(3)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_Y = zeros([size(tf_data_3) length(subject_list)]);
    end
    tf_all_Color_Y(:,:,:,sub) = tf_data_3;
end

for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(4)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_R = zeros([size(tf_data_4) length(subject_list)]);
    end
    tf_all_Color_R(:,:,:,sub) = tf_data_4;
end

tf_all_Color = (tf_all_Color_R+tf_all_Color_Y)/2;
tf_all_ColorYMinR = tf_all_Color_Y-tf_all_Color_R;
tf_all_Diff_PTMinColor = (tf_all_PT-tf_all_Color)./(tf_all_PT+tf_all_Color);

%% Average PT vs. Average Color

data_file = ['compare_mean_PT_vs_mean_Color_tf_signif_', Channels{chan}, '.mat'];
disp(['Load channel cluster ' Channels{chan}]);
load([Stats_data data_file])
clear data_file

idx_time_used = ismember(times, times_used4analysis);
[rows,cols,vals] =    find(tf_data_pvals{1} < 0.05);

% freq x times
ROI_freq_range_idx = [min(rows) max(rows)];
disp(['Freqency range results: ' num2str(freqs(ROI_freq_range_idx(1))) ' to ' num2str(freqs(ROI_freq_range_idx(2)))]);
ROI_time_range_idx = [min(cols) max(cols)];
disp(['Time range results: ' num2str(times_used4analysis(ROI_time_range_idx(1))) ' to ' num2str(times_used4analysis(ROI_time_range_idx(2)))]);


%% Determine ROI based on FDR results
plot_diff = [];
plot_diff = tf_all_Diff_PTMinColor(:,idx_time_used,:,:);

figure; clf
set(gcf,'name','Theta: PT - Color')

% make topomap
subplot(1,2,1)
topoplot(squeeze(mean(mean(mean(plot_diff(ROI_freq_range_idx(1):ROI_freq_range_idx(2),ROI_time_range_idx(1):ROI_time_range_idx(2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','on','numcontour',0);
title([ 'PT vs. Color (' num2str(times_used4analysis(ROI_time_range_idx(1))) ' ' num2str(times_used4analysis(ROI_time_range_idx(2))) 'ms; ' num2str(freqs(ROI_freq_range_idx(1))) '-' num2str(freqs(ROI_freq_range_idx(2))) 'Hz)' ]);
set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
colorbar
       
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
% saveas(gcf, [Figures 'Topo_FDR_Results_PT_Min_Color'], 'png')
clear tf_signif tf_data_pvals

%%
%% PT Can See vs. Does Not See
data_file = ['compare_PT_CanSee_vs_DoesNotSee_tf_signif_', Channels{chan}, '.mat'];
disp(['Load channel cluster ' Channels{chan}]);
load([Stats_data data_file])
clear data_file

idx_time_used = ismember(times, times_used4analysis);
[rows,cols,vals] =    find(tf_data_pvals{1} < 0.05);

% freq x times
ROI_freq_range_idx = [min(rows) max(rows)];
disp(['Freqency range results: ' num2str(freqs(ROI_freq_range_idx(1))) ' to ' num2str(freqs(ROI_freq_range_idx(2)))]);
ROI_time_range_idx = [min(cols) max(cols)];
disp(['Time range results: ' num2str(times_used4analysis(ROI_time_range_idx(1))) ' to ' num2str(times_used4analysis(ROI_time_range_idx(2)))]);


%% Determine ROI based on FDR results
plot_diff = [];
plot_diff = tf_all_PTCanMinDoesNot(:,idx_time_used,:,:);


set(gcf,'name','Theta: PT Does Not See - Can See')

% make topomap
subplot(1,2,2)
topoplot(squeeze(mean(mean(mean(plot_diff(ROI_freq_range_idx(1):ROI_freq_range_idx(2),ROI_time_range_idx(1):ROI_time_range_idx(2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','on','numcontour',0);
title([ 'PT Does Not See vs. Can See (' num2str(times_used4analysis(ROI_time_range_idx(1))) ' ' num2str(times_used4analysis(ROI_time_range_idx(2))) 'ms; ' num2str(freqs(ROI_freq_range_idx(1))) '-' num2str(freqs(ROI_freq_range_idx(2))) 'Hz)' ]);
set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
colorbar
       
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
% saveas(gcf, [Figures 'Topo_FDR_Results_PT_DoesNotSee_Min_CanSee'], 'png')
clear tf_signif tf_data_pvals
saveas(gcf, [Figures 'Topo_FDR_Results_Summary'], 'png')