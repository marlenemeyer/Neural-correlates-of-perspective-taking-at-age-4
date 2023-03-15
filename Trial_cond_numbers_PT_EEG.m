% Determine trials for each condition
% Check if variable Exclusion_Info exists already. If yes, load it.
if exist([output_dir output_specific 'Exclusion_Info.mat']) == 2
    load([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');
end


for s=1:length(subject_list)
    
    subject = subject_list{s};
    
    % Load pre-processed dataset
    
    EEG = pop_loadset('filename' ,[subject '_Referenced_Epoched_'  trial_type{2} '.set'],'filepath', Epoched_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG_exp =EEG;
    
    %%
    count_cond(1:4)=0;
    for x=1:length({EEG_exp.event(:).type}) 
       if strcmp(EEG_exp.event(x).type(1:2), 'CY')
           count_cond(1)=count_cond(1)+1;
       elseif strcmp(EEG_exp.event(x).type(1:2), 'CR')
           count_cond(2)=count_cond(2)+1;
       elseif strcmp(EEG_exp.event(x).type(1:2), 'PC')
           count_cond(3)=count_cond(3)+1;
       elseif strcmp(EEG_exp.event(x).type(1:2), 'PD')
           count_cond(4)=count_cond(4)+1;
       end

    end
    Condition_Split_Info.(subject).trls_left = count_cond;
    Condition_Split_Info.(subject).trls_left_header = {'Color_Y','Color_R', 'PT_Can', 'PT_DoesNot'};
    
    Exclusion_Info.(subject).RemainingTrials_perCond = count_cond;
    Exclusion_Info.(subject).RemainingTrials_perCondheader = {'Color_Y','Color_R', 'PT_Can', 'PT_DoesNot'};
    
end

save([output_dir output_specific 'Condition_Split_Info'],'Condition_Split_Info');
save([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');
