% Check if variable Exclusion_Info exists already. If yes, load it.
if exist([output_dir output_specific 'Exclusion_Info.mat']) == 2
    load([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');
end

for s=28:length(subject_list)
    subject = subject_list{s};
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    % Load the component removed dataset in which the movement and
    % not-looking are excluded based on the video
    EEG=pop_loadset('filename',[subject '_Component_Removed_and_VideobasedExcl_rounded.set'], 'filepath', Comp_Rem_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    for trl_type = 2 % go through ONLY the experimental condition

        % Keep only the time locking event markers and delete all other event markers
        if  strcmp(trial_type{trl_type},'experimental')
            EEG = eeg_checkset( EEG );
            EEG = pop_selectevent( EEG, 'type', experimental_markers, 'deleteevents','on');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            
            % create epoch of specific length and time lock to event of interest
            EEG = eeg_checkset( EEG );
            EEG = pop_epoch( EEG, experimental_markers, extended_epoch_length_experimental, 'epochinfo', 'yes');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            
        elseif strcmp(trial_type{trl_type},'baseline')
            EEG = eeg_checkset( EEG );
            EEG = pop_selectevent( EEG, 'type', baseline_markers, 'deleteevents','on');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            
            
            % create epoch of specific length and time lock to event of interest
            EEG = eeg_checkset( EEG );
            EEG = pop_epoch( EEG, baseline_markers, extended_epoch_length_baseline, 'epochinfo', 'yes');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        end
        % Count the trial numbers
        Total_Trials = EEG.trials;
        Exclusion_Info.(subject).(trial_type{trl_type}).Total_Trials = Total_Trials;
        save([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');
        
        Artifact_Rej_Reref_PT_EEG()
        
    end
end
save([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');