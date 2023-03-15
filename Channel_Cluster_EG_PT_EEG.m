       
% Data location
data_location = TFR_Data;
save_data_location = TFR_Clustered_Data;

% Find indices of the channels
count=1;
for i=1:length(midfrontal)
    if isempty(find(strcmp({channel_location.labels}, midfrontal{i})))
        warning(['Warning: no electrode: ' midfrontal{i}]);
    else
        midfrontal_idx (count)= find(strcmp({channel_location.labels}, midfrontal{i}));
        length_midfrontal = count;
        count=count+1;
    end
end

count=1;
for i=1:length(left_temporal_parietal)
    if isempty(find(strcmp({channel_location.labels}, left_temporal_parietal{i})))
        warning(['Warning: no electrode: ' left_temporal_parietal{i}]);
    else
        left_temporal_parietal_idx (count)= find(strcmp({channel_location.labels}, left_temporal_parietal{i}));
        length_left_temporal_parietal = count;
        count=count+1;
    end
end

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

count=1;
for i=1:length(left_sensorimotor)
    if isempty(find(strcmp({channel_location.labels}, left_sensorimotor{i})))
        warning(['Warning: no electrode: ' left_sensorimotor{i}]);
    else
        left_sensorimotor_idx (count)= find(strcmp({channel_location.labels}, left_sensorimotor{i}));
        length_left_sensorimotor = count;
        count=count+1;
    end
end

count=1;
for i=1:length(right_sensorimotor)
    if isempty(find(strcmp({channel_location.labels}, right_sensorimotor{i})))
        warning(['Warning: no electrode: ' right_sensorimotor{i}]);
    else
        right_sensorimotor_idx (count)= find(strcmp({channel_location.labels}, right_sensorimotor{i}));
        length_right_sensorimotor = count;
        count=count+1;
    end
end



%% 
% Load all data for Can See condition in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(1)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_Can = zeros([size(tf_data_1) length(subject_list)]);
    end
    tf_all_PT_Can(:,:,:,sub) = tf_data_1;
end


% Load all data for Does Not See condition in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(2)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_DoesNot = zeros([size(tf_data_2) length(subject_list)]);
    end
    tf_all_PT_DoesNot(:,:,:,sub) = tf_data_2;
end

%%
% Load all Color Yellow condition data in a matrix freq x time x channel x subjects

for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(3)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_Y = zeros([size(tf_data_3) length(subject_list)]);
    end
    tf_all_Color_Y(:,:,:,sub) = tf_data_3;
end


% Load all Color Not Yellow condition data in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(4)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_R = zeros([size(tf_data_4) length(subject_list)]);
    end
    tf_all_Color_R(:,:,:,sub) = tf_data_4;
end

%% 

% Make cluster
for i=1:length_midfrontal
PT_Can_tf_midfrontal   (:,:,i,:)   =   tf_all_PT_Can(:,:,midfrontal_idx(i),:); 
PT_DoesNot_tf_midfrontal   (:,:,i,:)   =   tf_all_PT_DoesNot(:,:,midfrontal_idx(i),:); 
Color_Y_tf_midfrontal   (:,:,i,:)   =   tf_all_Color_Y(:,:,midfrontal_idx(i),:); 
Color_R_tf_midfrontal   (:,:,i,:)   =   tf_all_Color_R(:,:,midfrontal_idx(i),:); 
end

for i=1:length_left_temporal_parietal
PT_Can_tf_left_temporal_parietal   (:,:,i,:)   =   tf_all_PT_Can(:,:,left_temporal_parietal_idx(i),:); 
PT_DoesNot_tf_left_temporal_parietal   (:,:,i,:)   =   tf_all_PT_DoesNot(:,:,left_temporal_parietal_idx(i),:); 
Color_Y_tf_left_temporal_parietal   (:,:,i,:)   =   tf_all_Color_Y(:,:,left_temporal_parietal_idx(i),:); 
Color_R_tf_left_temporal_parietal   (:,:,i,:)   =   tf_all_Color_R(:,:,left_temporal_parietal_idx(i),:); 
end

for i=1:length_right_temporal_parietal
PT_Can_tf_right_temporal_parietal   (:,:,i,:)   =   tf_all_PT_Can(:,:,right_temporal_parietal_idx(i),:); 
PT_DoesNot_tf_right_temporal_parietal   (:,:,i,:)   =   tf_all_PT_DoesNot(:,:,right_temporal_parietal_idx(i),:); 
Color_Y_tf_right_temporal_parietal   (:,:,i,:)   =   tf_all_Color_Y(:,:,right_temporal_parietal_idx(i),:); 
Color_R_tf_right_temporal_parietal   (:,:,i,:)   =   tf_all_Color_R(:,:,right_temporal_parietal_idx(i),:); 
end

for i=1:length_left_sensorimotor
PT_Can_tf_left_sensorimotor   (:,:,i,:)   =   tf_all_PT_Can(:,:,left_sensorimotor_idx(i),:); 
PT_DoesNot_tf_left_sensorimotor   (:,:,i,:)   =   tf_all_PT_DoesNot(:,:,left_sensorimotor_idx(i),:); 
Color_Y_tf_left_sensorimotor   (:,:,i,:)   =   tf_all_Color_Y(:,:,left_sensorimotor_idx(i),:); 
Color_R_tf_left_sensorimotor   (:,:,i,:)   =   tf_all_Color_R(:,:,left_sensorimotor_idx(i),:); 
end

for i=1:length_right_sensorimotor
PT_Can_tf_right_sensorimotor   (:,:,i,:)   =   tf_all_PT_Can(:,:,right_sensorimotor_idx(i),:); 
PT_DoesNot_tf_right_sensorimotor   (:,:,i,:)   =   tf_all_PT_DoesNot(:,:,right_sensorimotor_idx(i),:); 
Color_Y_tf_right_sensorimotor   (:,:,i,:)   =   tf_all_Color_Y(:,:,right_sensorimotor_idx(i),:); 
Color_R_tf_right_sensorimotor   (:,:,i,:)   =   tf_all_Color_R(:,:,right_sensorimotor_idx(i),:); 
end

for cond = 1:length(cond_labels)
    for clust = 1:length(cluster_labels)
        current_condset = eval([cond_labels{cond} '_tf_' cluster_labels{clust}]);
        
        tf_data = [];
        mean_tf_data = [];
        tf_data = squeeze(mean(current_condset, 3));
        mean_tf_data = squeeze(mean(mean(current_condset, 3), 4));
        save ([save_data_location [cond_labels{cond} '_tf_' cluster_labels{clust}]], 'tf_data', 'mean_tf_data', 'times', 'freqs');
        
    end
end
