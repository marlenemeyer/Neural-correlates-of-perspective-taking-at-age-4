
data_location = TFR_Clustered_Data;
save_data_location = Stats_data;

condition_label = cond_labels;
% Channel list
Channels = cluster_labels;

%% PT vs. Color
for chan=1:length(Channels)

    
    %% load 1st condition
    tf_data = [];
    data_file1 = [data_location condition_label{1} , '_tf_', Channels{chan}, '.mat']; % PT Can See
    
    load(data_file1)
    % find indices for the time range to analyze
    idx_time = find(times>=time2analyze(1) & times<=time2analyze(2));

    cond1_data = tf_data;
    cond1_data = squeeze(cond1_data(:,idx_time,:));
    
    %% load 2nd condition
    tf_data = [];
    data_file2 = [data_location condition_label{2} , '_tf_', Channels{chan}, '.mat']; % PT DoesNot See
    load(data_file2)
    cond2_data = tf_data;
    cond2_data = squeeze(cond2_data(:,idx_time,:));
    
    %% load 3rd condition
    tf_data = [];
    data_file3 = [data_location condition_label{3} , '_tf_', Channels{chan}, '.mat']; % Color Y
    
    load(data_file3)
    cond3_data = tf_data;
    cond3_data = squeeze(cond3_data(:,idx_time,:));
    
    
    %% load 4th condition
    tf_data = [];
    data_file4 = [data_location condition_label{4} , '_tf_', Channels{chan}, '.mat']; % Color R
    load(data_file4)
    cond4_data = tf_data;
    cond4_data = squeeze(cond4_data(:,idx_time,:));
    
    %% Average
    mean_PT = (cond1_data + cond2_data) ./2;
    mean_Color = (cond3_data + cond4_data) ./2;
    
    %% Normalized Average Difference
    mean_PTMinColor = (mean_PT - mean_Color) ./(mean_PT + mean_Color);
    

    tf_data_pvals = std_stat({ mean_PT mean_Color }', 'method', 'permutation', 'condstats', 'on', 'correctm', 'fdr');
    tf_signif = mean(mean_PTMinColor,3);
    tf_signif(tf_data_pvals{1} > 0.05) = 0;
    
    %% save data
    save_data = ['compare_mean_PT_vs_mean_Color_tf_signif_', Channels{chan}, '.mat'];
    times_used4analysis = times(idx_time);
    save ([save_data_location save_data], 'tf_signif', 'times', 'times_used4analysis', 'tf_data_pvals', 'freqs');
    
end

 %% PT CanSee vs. DoesNotSee   
for chan=1:length(Channels)
    
%% load 1st condition
    tf_data = [];
    data_file1 = [data_location condition_label{1} , '_tf_', Channels{chan}, '.mat']; % PT Can See
    
    load(data_file1)
    % find indices for the time range to analyze
    idx_time = find(times>=time2analyze(1) & times<=time2analyze(2));

    cond1_data = tf_data;
    cond1_data = squeeze(cond1_data(:,idx_time,:));
    
    %% load 2nd condition
    tf_data = [];
    data_file2 = [data_location condition_label{2} , '_tf_', Channels{chan}, '.mat']; % PT DoesNot See
    load(data_file2)
    cond2_data = tf_data;
    cond2_data = squeeze(cond2_data(:,idx_time,:));
    
      
    %% Normalized Average Difference
    mean_PTCanMinDoesNotSee = (cond1_data - cond2_data) ./(cond1_data + cond2_data);
    
    tf_data_pvals = std_stat({ cond1_data cond2_data }', 'method', 'permutation', 'condstats', 'on', 'correctm', 'fdr');
    tf_signif = mean(mean_PTCanMinDoesNotSee,3);
    tf_signif(tf_data_pvals{1} > 0.05) = 0;
      
    %% save data
    save_data = ['compare_PT_CanSee_vs_DoesNotSee_tf_signif_', Channels{chan}, '.mat'];
    times_used4analysis = times(idx_time);
    save ([save_data_location save_data], 'tf_signif', 'times', 'times_used4analysis', 'tf_data_pvals', 'freqs');
        
end

%% Color Yellow vs. Not Yellow   
for chan=1:length(Channels)
    
    % load 1st condition
    tf_data = [];
    data_file1 = [data_location condition_label{3} , '_tf_', Channels{chan}, '.mat']; % PT Can See
    
    load(data_file1)
    % find indices for the time range to analyze
    idx_time = find(times>=time2analyze(1) & times<=time2analyze(2));

    cond1_data = tf_data;
    cond1_data = squeeze(cond1_data(:,idx_time,:));
    
    %% load 2nd condition
    tf_data = [];
    data_file2 = [data_location condition_label{4} , '_tf_', Channels{chan}, '.mat']; % PT DoesNot See
    load(data_file2)
    cond2_data = tf_data;
    cond2_data = squeeze(cond2_data(:,idx_time,:));
    
      
    %% Normalized Average Difference
    mean_ColorNotYminY= (cond2_data - cond1_data) ./(cond1_data + cond2_data);
    
    tf_data_pvals = std_stat({ cond1_data cond2_data }', 'method', 'permutation', 'condstats', 'on', 'correctm', 'fdr');
    tf_signif = mean(mean_ColorNotYminY,3);
    tf_signif(tf_data_pvals{1} > 0.05) = 0;
      
    %% save data
    save_data = ['compare_Color_Y_vs_R_tf_signif_', Channels{chan}, '.mat'];
    times_used4analysis = times(idx_time);
    save ([save_data_location save_data], 'tf_signif', 'times', 'times_used4analysis', 'tf_data_pvals', 'freqs');
        
end
