%% Extracting EEG timing test

%% Open EEGlab
eeglab; % run EEGLAB

% Check if variable EEG_timingtest_video_align exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align'],'EEG_timingtest_video_align');
end

% Check if variable Video_Codes_perP exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP'],'Video_Codes_perP');
end

for s=1:length(subject_list)
       
    subject=subject_list{s}; % Dataset ID is string. So, no need for num2str
    
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    % Load dataset in eeglab
    EEG=pop_loadset('filename',[subject '.set'], 'filepath', data_location);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    
    
    % find all indices of where a reference tag (here 'LtIm') is located in the
    % event file
    idx_ref_tag = find(strcmp({EEG.urevent(:).type},'LtIm')==1);
    
    for i=1:length(idx_ref_tag)
        current_idx = idx_ref_tag(i);
        if strcmp(EEG.urevent(1).type, 'break cnt')
            EEG_timingtest_video_align.(subject).EEGtimingtest(i,1) = EEG.urevent(current_idx).latency - EEG.urevent(1).latency ;
        else
            EEG_timingtest_video_align.(subject).EEGtimingtest(i,1) = EEG.urevent(current_idx).latency;
        end
    end
       
    % Remove the saved dataset from EEGLAB memory
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end

save([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align'],'EEG_timingtest_video_align');