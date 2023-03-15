%% Individualized_Info

%% Specify Paths
% Locate relevant folders
path_root = 'D:\PT_EEG_Analysis\';

% Makes use of folders "Data", "Output" "Output_General" "Output_Specific"
% in the same analysis folder. Make sure to create these folders if not yet
% present
data_location = [path_root 'Data\'];
output_dir = [path_root 'Output\'];
output_general = 'Output_General\';
output_specific = 'Output_Specific\DirectContrast\';
input_dir = [path_root 'Input\'];

% Initialize channel locations
ch129_locations = [path_root 'GSN-HydroCel-129.sfp'];
ch104_locations = [path_root 'ch104_locations.mat'];
load( [path_root 'channel104_location.mat']); % file specifying channel locations

% Event marker location
event_location = [path_root 'Input'];

% Set directories for output (if not yet present, create these folders will
% be created
Directories_Variable_Info_PT_EEG();

%% Participants
% Video coding files

 Participants_coded ={'P2_PTEEG_P01', 'P2_PTEEG_P03', 'P2_PTEEG_P04', 'P2_PTEEG_P05', 'P2_PTEEG_P07', 'P2_PTEEG_P08', ...
     'P2_PTEEG_P09', 'P2_PTEEG_P10', 'P2_PTEEG_P11', 'P2_PTEEG_P12', 'P2_PTEEG_P13', 'P2_PTEEG_P14', ...
     'P2_PTEEG_P15', 'P2_PTEEG_P16', 'P2_PTEEG_P17', 'P2_PTEEG_P19', 'P2_PTEEG_P20', 'P2_PTEEG_P22', ...
     'P2_PTEEG_P23', 'P2_PTEEG_P24', 'P2_PTEEG_P25', 'P2_PTEEG_P26', 'P2_PTEEG_P27', 'P2_PTEEG_P28', ...
     'P2_PTEEG_P29', 'P2_PTEEG_P30', 'P2_PTEEG_P31', 'P2_PTEEG_P32', 'P2_PTEEG_P33', 'P2_PTEEG_P34', ...
     'P2_PTEEG_P35', 'P2_PTEEG_P36', 'P2_PTEEG_P37', 'P2_PTEEG_P38', 'P2_PTEEG_P39', 'P2_PTEEG_P41', ...
     'P2_PTEEG_P43', 'P2_PTEEG_P44', 'P2_PTEEG_P45', 'P2_PTEEG_P46', 'P2_PTEEG_P47', 'P2_PTEEG_P48', ...
     'P2_PTEEG_P49', 'P2_PTEEG_P50', 'P2_PTEEG_P51', 'P2_PTEEG_P52', 'P2_PTEEG_P54', 'P2_PTEEG_P55', ...
     'P2_PTEEG_P56', 'P2_PTEEG_P58', 'P2_PTEEG_P59', 'P2_PTEEG_P60', 'P2_PTEEG_P61', 'P2_PTEEG_P64', ...
     'P2_PTEEG_P65', 'P2_PTEEG_P66', 'P2_PTEEG_P67', 'P2_PTEEG_P68', 'P2_PTEEG_P69', 'P2_PTEEG_P70'};

% Make a list of all datasets to be included in the analysis
% EEG files

 %% Subject list
cd(Comp_Rem_Data)
subnum=dir('*.set');
sub_list={subnum.name};
for i =1:length(sub_list)
    sub = sub_list{i};
    subject_list{i}= sub(1:12);
end

subject_list = subject_list(1:end); % original subject list

% exclude these subjects due to not having enough trials before running preprocessing 2: 17, 49
% (during preprocessing 2 errors were found because pariticipants didn't have enough
% trials remaining - exclude BEFORE running pp2 otherwise errors will
% appear again)
excl_subj_pp3 = {'P2_PTEEG_P17','P2_PTEEG_P49'};
updated_subject_list_1 = setdiff(subject_list,excl_subj_pp3);
subject_list = updated_subject_list_1;

% list of participants who are supbset of a longitudinal project
subject_list_long_beh = {'P2_PTEEG_P08'	'P2_PTEEG_P09'	'P2_PTEEG_P10'	'P2_PTEEG_P11'	'P2_PTEEG_P12'	'P2_PTEEG_P13'	'P2_PTEEG_P14'	...
    'P2_PTEEG_P15'	'P2_PTEEG_P16'	'P2_PTEEG_P17'	'P2_PTEEG_P19'	'P2_PTEEG_P20'	'P2_PTEEG_P23'	'P2_PTEEG_P25'	'P2_PTEEG_P26'	'P2_PTEEG_P28'	...
    'P2_PTEEG_P29'	'P2_PTEEG_P32'	'P2_PTEEG_P35'	'P2_PTEEG_P36'	'P2_PTEEG_P37'	'P2_PTEEG_P38'	'P2_PTEEG_P39'	'P2_PTEEG_P41'	'P2_PTEEG_P46'};

% check for sufficient trials
count = 0;
count_2 = 0;
if exist([output_dir output_specific 'Condition_Split_Info.mat']) == 2
    load([output_dir output_specific 'Condition_Split_Info'],'Condition_Split_Info');
    for s = 1:length(subject_list)
        subject = subject_list{s};
       if sum(Condition_Split_Info.(subject).trls_left(1:2))>4 && sum(Condition_Split_Info.(subject).trls_left(3:4))>4
            % as preregistered we check wether each condition (Color and
            % PT) have at least 5 trials
            count = count+1;
            updated_subject_list_2(count) =subject_list(s);
       else
            count_2 = count_2+1;
            deleted_subject_list_2(count_2) =subject_list(s);
       end
    end
    subject_list = updated_subject_list_2;
end



%% Variables for extracting video coding
TimingTest_codes = {'S','T','W','C', 'X', 'NAN'};
Experimental_codes = {'Yellow', 'NotYellow', 'CanSee', 'DoesNot', 'Correct', 'Incorrect', 'Both', 'None', 'Mixed Up', 'CAPS', 'ExpError', 'TechError'}; 
LED_codes = {'LEDTop', 'LEDBack', 'LEDFront', 'xxxTop', 'xxxBack', 'xxxFront'};
Interference_codes_onset= {'PSpeechTrial', 'PSpeechTask', 'CUncooperative'};
Interference_codes_onsetoffset= {'CMove', 'CSpeech', 'CTurn', 'PSpeech'};
for t = 1:32
    TrialDur_codes(t)={['Trial' int2str(t)]};
end
LookingTime_codes = {'LookR','LookL', 'LookE'};
All_Experimental_codes = [Experimental_codes, Interference_codes_onset];
All_Subject_codes = [Interference_codes_onsetoffset, LookingTime_codes, TrialDur_codes];

%% Initialize all other variables for first preprocessing step
EGI_AATF = 36; % EGI anti-aliasing time offset depends on sampling rate and amplifier.
TASK_TF = 0; % task related offset
% Check your apmlifier version and data sample and adjust the time offset accordingly
sampling_rate = 500; % We use 500Hz sampling rate

%% Delete outerlayer of the channels in infants data
delete_outlyr = 'yes'; % yes||no, requires answer

% Initialize filters
highpass = 0.3;
lowpass  = 50;

%% Initialize variables for preparation of ICA on copied data

hp_fl_4ICA = 1; % 1 Hz highpass filter
event_time_window = 1; % epoch length is 1 second
event_type = '999'; % 999 is temporary event marker
delete_chan='no'; % Delete channel if > XX% are artifacted? yes|no. If you say yes here, specify cutoff percent below
cutoff_pcnt=20; % If > 20% epochs are bad in a channel, that channel will be removed. Change cutoff percent as required   

% File to write number of rejected epochs in copied data
reject_copied_data = 'Num_trials_copied_data.csv';

%% For second preprocessing step
Mark_Bad_Trials={'Mark_Bad_Trials_Video_PT_EEG'}; % specify script that excludes trials based on pre-registered video-coding parameters

starttrial_markers = {'BPC1' , 'BPD1', 'BCY1', 'BCR1',...
                    'BPC2' , 'BPD2', 'BCY2', 'BCR2',...
                    'BPC3' , 'BPD3', 'BCY3', 'BCR3',...
                    'BPC4' , 'BPD4', 'BCY4', 'BCR4'};

% types of trials
trial_type = {'baseline','experimental'}; % NOTE: in the final analysis reported in the manuscript, activity for the conditions (PT vs. Control) during
% the experimental window were contrasted directly instead of
% baseline-correcting them. See manuscript for detailed explanation.

% define baseline trials
baseline_markers = {'SPC1' , 'SPD1', 'SCY1', 'SCR1',...
                    'SPC2' , 'SPD2', 'SCY2', 'SCR2',...
                    'SPC3' , 'SPD3', 'SCY3', 'SCR3',...
                    'SPC4' , 'SPD4', 'SCY4', 'SCR4'};

% define baseline epoch length
epoch_length_baseline=[-1 0];

% define longer baseline epoch to take into account as data padding for the
% frequency analysis
extended_epoch_length_baseline = [-2 1];

% define experimental trials
experimental_markers = {'PC1-' , 'PD1-', 'CY1-', 'CR1-',...
                    'PC2-' , 'PD2-', 'CY2-', 'CR2-',...
                    'PC3-' , 'PD3-', 'CY3-', 'CR3-',...
                    'PC4-' , 'PD4-', 'CY4-', 'CR4-'};

% Define epoch length in second
epoch_length_experimental=[-1 2];

% define longer baseline epoch to take into account as data padding for the
% frequency analysis
extended_epoch_length_experimental = [-2 3];

% define interference markers needed for excluding and/or count trials based on
% video-coding (e.g. child hands both toys or caregiver interferes)
interference_markers_entiretrial = {'PSpeechTask', 'PSpeechTrial', 'CUncooperative', 'TechError', 'ExpError'}; 
interference_markers_entiretrial_ChoiceBehav = {'Both', 'None', 'Mixed Up'}; 
interference_markers_b_p_d = {'PSpeech','CSpeech'}; %find the time window where baseline starts until decision ends (This was originally PSpeech only - see note below about CSpeech)
interference_markers_b_d = {'CTurn'}; %find time during baseline and decision only
interference_markers_p = {'CSpeech'}; %find time during prompt only
interference_markers_count_b_d = {'CSpeech', 'CMove'}; %baseline and prompt only


%% Artifact rejection
% Step 1 eyelblink: detect and reject based on front six frontal channels
% ('E1', 'E8', 'E14', 'E21', 'E25', 'E32') for voltage only. no
% interpolation
interp_chan = 'yes';
volthrs_low = -250;
volthrs_up  = 250;

% If more than 10% of channels in a epoch were interpolated in a epoch, reject that epoch
percent_chan = 10;

% File to write number of epochs before and after artifact rejection
numtrl_bfafartrej = 'Num_Trials_BefAft_ArtRej.csv';

%% Rereference to average of all channels
reref = [];

%% For third processing step

% Match baseline with experimental marker
for i=1:length(baseline_markers)
    baseline_exp_markers{1,i}={baseline_markers{i},experimental_markers{i}};
    base_exp_match_marker{1,i}={[baseline_markers{i} '_MTH'],[experimental_markers{i} '_MTH']};
    all_match_exp_markers(1,i)={[experimental_markers{i} '_MTH']};
    all_match_base_markers(1,i)={[baseline_markers{i} '_MTH']};
end


%% for CSD transform
%% Paths to CSD toolbox and EEGLab
addpath(genpath(([path_root 'Scripts\CSDtoolbox'])));   % Point folder of the CSDToolbox

current_montage_path = [path_root 'Scripts\CSDtoolbox\resource\GSN-HydroCel-104.csd'];

%% for Time-Frequency Analysis
substract_baseline = [-1000 0];
freqOI = [3 30];

% NOTE: these were used in the initial analysis using a baseline, using
% those trials only for which both a baseline and experimental window was
% present and not excluded due to artifact rejection

% baselines_PT_Can = {'SPC1_MTH','SPC2_MTH','SPC3_MTH','SPC4_MTH'};
% baselines_PT_DoesNot = {'SPD1_MTH','SPD2_MTH','SPD3_MTH','SPD4_MTH'};
% baselines_Color_Y = {'SCY1_MTH','SCY2_MTH','SCY3_MTH','SCY4_MTH'};
% baselines_Color_R = {'SCR1_MTH','SCR2_MTH','SCR3_MTH','SCR4_MTH'};
% 
% experimental_PT_Can = {'PC1-_MTH','PC2-_MTH','PC3-_MTH','PC4-_MTH'};
% experimental_PT_DoesNot = {'PD1-_MTH','PD2-_MTH','PD3-_MTH','PD4-_MTH'};
% experimental_Color_Y = {'CY1-_MTH','CY2-_MTH','CY3-_MTH','CY4-_MTH'};
% experimental_Color_R = {'CR1-_MTH','CR2-_MTH','CR3-_MTH','CR4-_MTH'};

% Direct Contrast (DC) used in final analysis to determine differences
% between the PT and Control (i.e. Color) conditions
DC_experimental_PT_Can = {'PC1-','PC2-','PC3-','PC4-'}; 
DC_experimental_PT_DoesNot = {'PD1-','PD2-','PD3-','PD4-'};
DC_experimental_Color_Y = {'CY1-','CY2-','CY3-','CY4-'};
DC_experimental_Color_R = {'CR1-','CR2-','CR3-','CR4-'};


%% for Topoplot
% Time bins
% if you have more than 20 time windows adjust in the script
% subplot(4,5,ti)
time_windows = [ 0 2000];

% frequency ranges
mu_freq_windows = [8 12];
beta_freq_windows = [13 20];
theta_freq_windows = [4 7];

% standardize axis - centered around 0, same axis for all graphs
clim        = [ -20 20 ];
clim_diff   = [ -0.01 0.01 ];

%% Channel clusters
midfrontal =                {'E11','E16', 'E19', 'E12', 'E5', 'E4', 'E6'};
left_temporal_parietal=     {'E30','E36','E37','E41','E42','E46','E47','E52','E53'};
right_temporal_parietal =   {'E86','E87','E92','E93','E98','E102','E103','E104','E105'};
left_sensorimotor =         {'E29','E30','E35','E36','E37','E41','E42'};
right_sensorimotor =        {'E87','E93','E103','E104','E105','E110','E111'};

%% for TFR plot
freq2plot=[3 20];
time2plot=[0 2000];

%% for Writing data in text file

% Text file name
textfile='Main_Results_theta.txt';
time2analyze = [0 2000];


%%For Channel Cluster
cond_labels = {'PT_Can', 'PT_DoesNot', 'Color_Y', 'Color_R'};
SPLIT_cond_labels = {'PT_Correct', 'PT_Correct_subset', 'PT_Incorrect'};
cluster_labels = {'midfrontal', 'left_temporal_parietal', 'right_temporal_parietal', 'left_sensorimotor', 'right_sensorimotor'};