%% Align EEG and video codes

% Check if variable EEG_timingtest_video_align exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align'],'EEG_timingtest_video_align');
end

% Check if variable Video_Codes_perP exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP'],'Video_Codes_perP');
end

% Check if variable New_EventCodes exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\New_EventCodes.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\New_EventCodes'],'New_EventCodes');
end

for s=1:length(subject_list)
      
    subject=subject_list{s}; 
    
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);

    % import the timing test results based on the video
    EEG_timingtest_video_align.(subject).Videotimingtest = cell2mat(Video_Codes_perP.(subject).TimingTest_only(:,1));

    % Calculate the difference between Video and EEG timing test results
    EEG_timingtest_video_align.(subject).Diff_Video_EEG_timing = EEG_timingtest_video_align.(subject).Videotimingtest -  EEG_timingtest_video_align.(subject).EEGtimingtest;
    
    % Calculate whether that difference changes between the first 5 and
    % last 5 letters presented (i.e. at beginning vs. end of experiment)
    avg_firsthalf = mean(EEG_timingtest_video_align.(subject).Diff_Video_EEG_timing(1:5));
    avg_secondhalf = mean(EEG_timingtest_video_align.(subject).Diff_Video_EEG_timing(6:end)); 
    EEG_timingtest_video_align.(subject).Compare_Diff_1st_vs_2ndHalf = avg_secondhalf - avg_firsthalf;
    
    % Calculate the Average difference for the first 5 letters and take
    % this value to align the video with the EEG markers
    EEG_timingtest_video_align.(subject).AvgDiff_1stHalf = round(avg_firsthalf);
    
    % Calculate difference between Video and EEG codes to align the video
    % with the EEG
    New_EventCodes.(subject).Experimental_Codes(:,1) = num2cell(round(cell2mat(Video_Codes_perP.(subject).Markup(:,1)) - avg_firsthalf));
    New_EventCodes.(subject).Experimental_Codes(:,2) = Video_Codes_perP.(subject).Markup(:,2);
    
    New_EventCodes.(subject).Interference_Codes(:,1) = num2cell(round(cell2mat(Video_Codes_perP.(subject).Interference(:,1)) - avg_firsthalf));
    New_EventCodes.(subject).Interference_Codes(:,2) = num2cell(round(cell2mat(Video_Codes_perP.(subject).Interference(:,2)) - avg_firsthalf));
    New_EventCodes.(subject).Interference_Codes(:,3) = Video_Codes_perP.(subject).Interference(:,3);
end

save([output_dir output_general 'VideoBasedMarkers\EEG_timingtest_video_align'],'EEG_timingtest_video_align');
save([output_dir output_general 'VideoBasedMarkers\New_EventCodes'],'New_EventCodes');
