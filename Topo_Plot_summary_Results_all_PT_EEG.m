Condition_Name = cond_labels;
Channels = cluster_labels;

%% Define variables for ROI topoplot
ROI_plot_t = [1200 1700];
ROI_plot_f = [4 7];


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
tf_all_ColorNotYMinY = (tf_all_Color_R - tf_all_Color_Y) ./ (tf_all_Color_Y + tf_all_Color_R);
tf_all_Diff_PTMinColor = (tf_all_PT-tf_all_Color)./(tf_all_PT+tf_all_Color);

%% Average PT vs. Average Color
data_file = ['compare_PT_CanSee_vs_DoesNotSee_tf_signif_', Channels{chan}, '.mat'];% NOTE this is just to load the time_used4analysis so it does not matter which comparison contrast is used to load it
disp(['Load channel cluster ' Channels{chan}]);
load([Stats_data data_file])
clear data_file tf_signif tf_data_pvals

idx_time_used = ismember(times, times_used4analysis);

%% Determine ROI based on FDR results
plot_diff = [];
plot_diff = tf_all_Diff_PTMinColor(:,idx_time_used,:,:);

figure; clf
set(gcf,'name','Theta: PT - Color')

c = 1;
% make topomap
for f = ROI_plot_f(1):1:ROI_plot_f(end)-1
    
    idx_range_f = find(freqs >= f & freqs <= f+1);
    for t = ROI_plot_t(1):100:ROI_plot_t(end)-1
        idx_range_t = find(times_used4analysis >=t & times_used4analysis <=t+100);
        
        subplot(2,5,c)
        topoplot(squeeze(mean(mean(mean(plot_diff(idx_range_f,idx_range_t,:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','on','numcontour',0, 'maplimits', clim_diff);
        title(['PTvsColor' num2str(t) ' ' num2str(t +100) 'ms; ' num2str(f) '-' num2str(f+1) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        colorbar
        c=c+1;
    end
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_TimeCourse_PT_Min_Color'], 'png')

%% PT Does Not See vs. Can See
plot_diff = [];
plot_diff = tf_all_PTCanMinDoesNot(:,idx_time_used,:,:);

figure; clf
set(gcf,'name','Theta: Does Not See - Can See')
%% if more or less than two conditions add/remove (lines 133-137)
c = 1;
% make topomap
for f = ROI_plot_f(1):1:ROI_plot_f(end)-1
    
    idx_range_f = find(freqs >= f & freqs <= f+1);
    for t = ROI_plot_t(1):100:ROI_plot_t(end)-1
        idx_range_t = find(times_used4analysis >=t & times_used4analysis <=t+100);
        
        subplot(2,5,c)
        topoplot(squeeze(mean(mean(mean(plot_diff(idx_range_f,idx_range_t,:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','on','numcontour',0, 'maplimits', clim_diff);
        title(['DoesNotvsCanSee' num2str(t) ' ' num2str(t +100) 'ms; ' num2str(f) '-' num2str(f+1) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        colorbar
        c=c+1;
    end
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_TimeCourse_PT_DoesNotSee_Min_CanSee'], 'png')

%% Color Not Yellow vs. Yellow
plot_diff = [];
plot_diff = tf_all_ColorNotYMinY(:,idx_time_used,:,:);

figure; clf
set(gcf,'name','Theta: Not Yellow vs. Yellow')

c = 1;
% make topomap
for f = ROI_plot_f(1):1:ROI_plot_f(end)-1
    
    idx_range_f = find(freqs >= f & freqs <= f+1);
    for t = ROI_plot_t(1):100:ROI_plot_t(end)-1
        idx_range_t = find(times_used4analysis >=t & times_used4analysis <=t+100);
        
        subplot(2,5,c)
        topoplot(squeeze(mean(mean(mean(plot_diff(idx_range_f,idx_range_t,:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','on','numcontour',0, 'maplimits', clim_diff);
        title(['NotYvsY' num2str(t) ' ' num2str(t +100) 'ms; ' num2str(f) '-' num2str(f+1) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        colorbar
        c=c+1;
    end
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_TimeCourse_Color_NotY_min_Y'], 'png')

