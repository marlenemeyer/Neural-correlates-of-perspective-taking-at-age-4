% This script performs second level of preprocessing after ICA. This level
% of preprocessing includes for instance removing artifacted ICA
% components

% Check if variable Exclusion_Info exists already. If yes, load it.
if exist([output_dir 'Exclusion_Info.mat']) == 2
    load([output_dir 'Exclusion_Info'],'Exclusion_Info');
end

% remove identified independent components (ICs) based on ICA from data
for s=1:length(subject_list)
    
    subject = subject_list{s};
    
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    % Load the dataset in which Adjust was done and subsequently visually
    % inspected and artifactual components were identified
    EEG=pop_loadset('filename',[subject '_Adjust_checked.set'], 'filepath', Adjust_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % Find ICs to be removed
    ICs_To_Remove=find(EEG.reject.gcompreject);
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
    % Load original dataset in which ICA weights were transfered from copied dataset
    EEG=pop_loadset('filename',[subject '_ICA_Original.set'], 'filepath', ICA_original_data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        
    % Remove ICs from dataset
    EEG = eeg_checkset( EEG );
    EEG = pop_subcomp( EEG, ICs_To_Remove, 0);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % Give a name to the dataset and save on hard drive
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'setname', [subject '_Component_Removed']);
    EEG = pop_saveset( EEG, 'filename',[subject '_Component_Removed.set'],'filepath', Comp_Rem_Data);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end


for s=1:length(subject_list)

    subject = subject_list{s};
    
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    % Load the component removed dataset
    EEG=pop_loadset('filename',[subject '_Component_Removed.set'], 'filepath', Comp_Rem_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    Label_events_PT_EEG(); % this adds information on the trial number before excluding further trials
    
    if ~isempty(Mark_Bad_Trials)
        eval(Mark_Bad_Trials{1})
    end   
    
    % Give a name to the dataset and save on hard drive
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'setname', [subject '_Component_Removed_and_VideobasedExcl']);
    EEG = pop_saveset( EEG, 'filename',[subject '_Component_Removed_and_VideobasedExcl.set'],'filepath', Comp_Rem_Data);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
     STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end
save([output_dir 'Exclusion_Info'],'Exclusion_Info');

for s=1:length(subject_list)
    subject = subject_list{s};
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    % Load the component removed dataset in which the movement and
    % not-looking are excluded based on the video
    EEG=pop_loadset('filename',[subject '_Component_Removed_and_VideobasedExcl.set'], 'filepath', Comp_Rem_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % round latencies to integers
    for i = 1:length(EEG.event)
        EEG.event(i).latency = round(EEG.event(i).latency);
    end
    
    % Give a name to the dataset and save on hard drive
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'setname', [subject '_Component_Removed_and_VideobasedExcl_rounded']);
    EEG = pop_saveset( EEG, 'filename',[subject '_Component_Removed_and_VideobasedExcl_rounded.set'],'filepath', Comp_Rem_Data);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end
    
         