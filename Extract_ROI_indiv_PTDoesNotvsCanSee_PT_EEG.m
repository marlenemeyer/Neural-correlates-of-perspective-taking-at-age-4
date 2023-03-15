Condition_Name = cond_labels;
Channels = cluster_labels;

   
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
tf_all_PTDoesNotMinCanSee = (tf_all_PT_DoesNot-tf_all_PT_Can)./(tf_all_PT_Can+tf_all_PT_DoesNot);

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
tf_all_Norm_PT = (tf_all_PT)./(tf_all_PT+tf_all_Color);
tf_all_Norm_Color = (tf_all_Color)./(tf_all_PT+tf_all_Color);

% get indices for channel cluster of interest
count=1;
for i=1:length(right_temporal_parietal)
    if isempty(find(strcmp({channel_location.labels}, right_temporal_parietal{i})))
        warning(['Warning: no electrode: ' right_temporal_parietal{i}]);
    else
        right_temporal_parietal_idx (count)= find(strcmp({channel_location.labels}, right_temporal_parietal{i}));
        length_right_temporal_parietal = count;
        count=count+1;
    end
end


%% Average PT vs. Average Color
chan = 3; % right temporal-parietal

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
extract_diff = [];
extract_diff = tf_all_PTDoesNotMinCanSee(:,idx_time_used,:,:);
% PT vs. Color
extract_ROI_indiv_PTDoesNotSeevsCanSee = squeeze(squeeze(mean(mean(mean(extract_diff(ROI_freq_range_idx(1):ROI_freq_range_idx(2),ROI_time_range_idx(1):ROI_time_range_idx(2),right_temporal_parietal_idx,:),1), 2),3)));

save([Export_data 'ROI_results_DoesNotSeeCanSee'],'extract_ROI_indiv_PTDoesNotSeevsCanSee');