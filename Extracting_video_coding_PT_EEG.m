%% Extract video oding information needed for pre-processing of the data

% Check if variable Video_Codes_perP exists already. If yes, load it.
if exist([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP.mat']) == 2
    load([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP'],'Video_Codes_perP');
end

for subj = 1:length(Participants_coded)
    subject = Participants_coded{subj};
    video_file = [subject '_SessionInfo.csv'];
    % video_file = [subject '_Onset_only.csv'];
    
    
    disp(['%%%%%%%%%%%%%%%% Participant is ' Participants_coded{subj} ' ONLY ONSET %%%%%%%%%%%%%%'])
    [NUM,TXT,RAW] = xlsread([input_dir 'video_coding\' video_file]);
    
    % reset variables
    Video_Codes = [];
    Video_Code_Names = {};
    Video_Codes_Interference_start = [];
    Video_Codes_Interference_end = [];
    Video_Code_Names_Interference = {};
    Video_Code_Names_LED = [];
    Video_Codes_LED = [];
    
    
    %% extract timing test codes
    %    TimingTest_codes = {'S','T','W','C', 'X', 'NaN'};
    
    idx_code = find(ismember(RAW(:,2), TimingTest_codes));
    current_codes = RAW(idx_code,2);
    start_t = cell2mat(RAW(idx_code,1));
    
    
    Video_Code_Names = [Video_Code_Names; current_codes];
    Video_Codes = [Video_Codes; start_t];
    
    Timing_test_names = Video_Code_Names;
    Timing_test_times = Video_Codes;
    % double-check: do the names and numbers have the same lengths?
    if length(Video_Code_Names)~= length(Video_Codes)
        warning('-----------ATTENTION: Video codes and times are not equally long-----------')
    end
    clear('idx_code','start_t','current_codes')
    
    
    %% extract experimental codes
    % Experimental_codes = {'Yellow', 'NotYellow', 'CanSee', 'DoesNot', 'Correct', 'Incorrect', 'CAPS'}; % NOTE: ,add here 'Both', 'Neither', 'Mixedup' % NOTE: potentially add a code to cut off beginning of recording
    % Interference_codes_onset= {'PSpeechTrial', 'PSpeechTask', 'CSpeechUncoop'}; % NOTE: add here 'ExpError' with correct label for it from video coding
    % All_Experimental_codes = [Experimental_codes, Interference_codes_onset];
    
    idx_code = find(ismember(RAW(:,2), All_Experimental_codes));
    current_codes = RAW(idx_code,2);
    start_t = cell2mat(RAW(idx_code,1));
    
    Video_Code_Names = [Video_Code_Names; current_codes];
    Video_Codes = [Video_Codes; start_t];
    
    % double-check: do the names and numbers have the same lengths?
    if length(Video_Code_Names)~= length(Video_Codes)
        warning('-----------ATTENTION: Video codes and times are not equally long-----------')
    end
    clear('idx_code','start_t','current_codes')
    
    
    %% extract LED codes
    %     LED_codes = {'LEDTop', 'LEDBack', 'LEDFront', 'xxxTop', 'xxxBack', 'xxxFront'};
    
    idx_code = find(ismember(RAW(:,2), LED_codes));
    current_codes = RAW(idx_code,2);
    start_t = cell2mat(RAW(idx_code,1));
    
    if isempty(idx_code)
        Video_Code_Names_LED = [Video_Code_Names_LED; {'no_LEDS_present'}];
        Video_Codes_LED = [Video_Codes_LED; 0];
    else
        Video_Code_Names_LED = [Video_Code_Names_LED; current_codes];
        Video_Codes_LED = [Video_Codes_LED; start_t];
        
    end
    
    % double-check: do the names and numbers have the same lengths?
    if length(Video_Code_Names_LED)~= length(Video_Codes_LED)
        warning('-----------ATTENTION: Video codes and times are not equally long-----------')
    end
    clear('idx_code','idx_end','start_t','current_codes'
    
    clear('video_file','NUM','TXT','RAW')
    video_file = [subject '_ChildBehavior.csv'];
    % video_file = [subject '_OnsetOffsetcsv'];
    
    
    disp(['%%%%%%%%%%%%%%%% Participant is ' Participants_coded{subj} ' ONSET & OFFSET %%%%%%%%%%%%%%'])
    [NUM,TXT,RAW] = xlsread([input_dir 'video_coding\' video_file]);
    
    
    %% extract codes with onset and offset:
    % Interference_codes_onsetoffset= {'CMove', 'CSpeech', 'CTurn', 'PSpeech'};
    % for t = 1:32
    %     TrialDur_codes(t)={['Trial' int2str(t)]};
    % end
    % LookingTime_codes = {'LookR','LookL', 'LookE'};
    % All_Experimental_codes = [Experimental_codes, Interference_codes_onset];
    % All_Subject_codes = [Interference_codes_onsetoffset, LookingTime_codes, TrialDur_codes];
    
    idx_code = find(ismember(RAW(:,3), All_Subject_codes));
    current_codes = RAW(idx_code,3);
    start_t = cell2mat(RAW(idx_code,1));
    end_t =  cell2mat(RAW(idx_code,2));
    
    Video_Code_Names_Interference = [Video_Code_Names_Interference; current_codes];
    Video_Codes_Interference_start = [Video_Codes_Interference_start; start_t];
    Video_Codes_Interference_end = [Video_Codes_Interference_end; end_t];
    
    % double-check: do the names and numbers have the same lengths?
    if length(Video_Code_Names_Interference)~= length(Video_Codes_Interference_start)|| ...
            length(Video_Codes_Interference_end)~= length(Video_Codes_Interference_start)
        warning('-----------ATTENTION: Video codes and times are not equally long-----------')
    end
    clear('idx_code','idx_end','start_t','current_codes')
    
    idx_code = find(ismember(RAW(:,3), All_Experimental_codes));
    current_codes = RAW(idx_code,3);
    start_t = cell2mat(RAW(idx_code,1));
    
    Video_Code_Names = [Video_Code_Names; current_codes];
    Video_Codes = [Video_Codes; start_t];
    
    if length(Video_Code_Names)~= length(Video_Codes)
        warning('-----------ATTENTION: Video codes and times are not equally long-----------')
    end
    
    clear('idx_code','idx_end','start_t','end_t','idx_code_txt','current_codes')
    
    
    %% Save all in one variable
    Video_Codes_perP.(Participants_coded{subj}(1:12)).Markup(:,1) = num2cell(Video_Codes);
    Video_Codes_perP.(Participants_coded{subj}(1:12)).Markup(:,2) = Video_Code_Names;
    
    Video_Codes_perP.(Participants_coded{subj}(1:12)).Interference(:,1) = num2cell(Video_Codes_Interference_start(:,1));
    Video_Codes_perP.(Participants_coded{subj}(1:12)).Interference(:,2) = num2cell(Video_Codes_Interference_end(:,1));
    Video_Codes_perP.(Participants_coded{subj}(1:12)).Interference(:,3) = Video_Code_Names_Interference;
    
    Video_Codes_perP.(Participants_coded{subj}(1:12)).TimingTest_only(:,1) = num2cell(Timing_test_times);
    Video_Codes_perP.(Participants_coded{subj}(1:12)).TimingTest_only(:,2) = Timing_test_names;
    
    if strcmp(Video_Code_Names_LED, 'no_LEDS_present')
        Video_Codes_perP.(Participants_coded{subj}(1:12)).LED(1) = {Video_Code_Names_LED};
    else
        Video_Codes_perP.(Participants_coded{subj}(1:12)).LED(:,1) = num2cell(Video_Codes_LED);
        Video_Codes_perP.(Participants_coded{subj}(1:12)).LED(:,2) = Video_Code_Names_LED;
    end
    
    
end

save([output_dir output_general 'VideoBasedMarkers\Video_Codes_perP'],'Video_Codes_perP');