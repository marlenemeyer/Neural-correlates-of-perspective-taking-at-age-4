%% Output folders for different analysis steps

% Check if the folder to save clean data exists, if not, create it
if exist([output_dir output_general 'Filter_Faster/'], 'dir') == 0
    mkdir([output_dir output_general 'Filter_Faster/'])
end

filtered_data = [output_dir output_general 'Filter_Faster/'];

% Check if the folder to save copied data exists, if it doesn't exist, create it
if exist([output_dir output_general 'Copied_Data/'], 'dir') == 0
    mkdir([output_dir output_general 'Copied_Data/'])
end

% Location of folder created above to save the copied dataset
copied_data=[output_dir output_general 'Copied_Data/'];

% Check if the folder to save bad channel files exists, if not, create it
if exist([output_dir output_general 'Bad_Channels/'], 'dir') == 0
    mkdir([output_dir output_general 'Bad_Channels/'])
end

% % Indicate the location of folder created above to save the bad channel files
bad_channels = [output_dir output_general 'Bad_Channels/'];


% Check if the folder to save copied data after ICA exists, if not, create it
if exist([output_dir output_general 'ICA_Copied_Data/'], 'dir') == 0
    mkdir([output_dir output_general 'ICA_Copied_Data/'])
end

% Location of folder created above to save the copied data after ICA
ICA_copied_data = [output_dir output_general 'ICA_Copied_Data/'];

% Check if the folder to save original data with ICA weights exists, if not, create it
if exist([output_dir output_general 'ICA_Original_Data/'], 'dir') == 0
    mkdir([output_dir output_general 'ICA_Original_Data/'])
end

% Location of folder created above to save the ICA dataset
ICA_original_data = [output_dir output_general 'ICA_Original_Data/'];


% Check if the folder to save Adjust data exists, if not, create it
if exist([output_dir output_general 'Adjust_Data/'], 'dir') == 0
    mkdir([output_dir output_general 'Adjust_Data/'])
end

% % Location of folder created above to save the ICA dataset
Adjust_Data = [output_dir output_general 'Adjust_Data/'];

% Check if the folder to component removed data exsits, if not, create it
if exist([output_dir output_general  'Component_Removed/'], 'dir') == 0
    mkdir([output_dir output_general  'Component_Removed/'])
end

% Location of folder to save component removed dataset
Comp_Rem_Data = [output_dir output_general  'Component_Removed/'];


% Check if the folder to save epoched data exsits, if not, create it
if exist([output_dir output_specific 'Epoch_Data/'], 'dir') == 0
    mkdir([output_dir output_specific 'Epoch_Data/'])
end

% Location of folder to save epoched dataset
Epoched_Data = [output_dir output_specific 'Epoch_Data/'];

% Check if the folder to save epoched matched data exsits, if not, create it
if exist([output_dir output_specific 'Epoch_Matched/'], 'dir') == 0
    mkdir([output_dir output_specific 'Epoch_Matched/'])
end

% Location of folder to save epoched dataset
Epoched_Matched_Data = [output_dir output_specific 'Epoch_Matched/'];

% Check if the folder to save CSD transformed data exsits, if not, create it
if exist([output_dir output_specific 'Epoch_Matched_CSD/'], 'dir') == 0
    mkdir([output_dir output_specific 'Epoch_Matched_CSD/'])
end

% Location of folder to save epoched dataset
CSD_Data = [output_dir output_specific 'Epoch_Matched_CSD/'];

% Check if the folder to save non epoch-mathced CSD transformed data exsits, if not, create it
if exist([output_dir output_specific 'CSD_avgbase/'], 'dir') == 0
    mkdir([output_dir output_specific 'CSD_avgbase/'])
end

% Location of folder to save epoched dataset
CSD_avgbase = [output_dir output_specific 'CSD_avgbase/'];

% Check if the folder to save fft data exsits, if not, create it
if exist([output_dir output_specific 'FFT_data/'], 'dir') == 0
    mkdir([output_dir output_specific 'FFT_data/'])
end

% Location of folder to save epoched dataset
FFT_data = [output_dir output_specific 'FFT_data/'];


% Check if the folder to save CSD transformed data exsits, if not, create it
if exist([output_dir output_specific 'Time_Frequency_Data/'], 'dir') == 0
    mkdir([output_dir output_specific 'Time_Frequency_Data/'])
end

% Location of folder to save epoched dataset
TFR_Data = [output_dir output_specific 'Time_Frequency_Data/'];

% Check if the folder to save CSD transformed data exsits, if not, create it
if exist([output_dir output_specific 'Flex_Time_Frequency_Data/'], 'dir') == 0
    mkdir([output_dir output_specific 'Flex_Time_Frequency_Data/'])
end

% Location of folder to save epoched dataset
Flex_TFR_Data = [output_dir output_specific 'Flex_Time_Frequency_Data/'];

% Check if the folder to save TFR clustered data exsits, if not, create it
if exist([TFR_Data 'Clustered/'], 'dir') == 0
    mkdir([TFR_Data 'Clustered/'])
end

% Location of folder to save TFR clustered dataset
TFR_Clustered_Data = [TFR_Data 'Clustered/'];

% Check if the folder to save stats data exists, if not, create it
if exist([TFR_Data 'StatsTest/'], 'dir') == 0
    mkdir([TFR_Data 'StatsTest/'])
end

% Location of folder to save stats tests
Stats_data = [TFR_Data 'StatsTest/'];

% Check if the folder to save figures exists, if not, create it
if exist([output_dir output_specific 'Figures/'], 'dir') == 0
    mkdir([output_dir output_specific 'Figures/'])
end

% Location of folder to save figures
Figures = [output_dir output_specific 'Figures/'];

% Folder to save text file
 if exist([output_dir output_specific 'Export_data/'], 'dir') == 0
    mkdir([output_dir output_specific 'Export_data/'])
 end

 % Location of folder to save figures
Export_data = [output_dir output_specific 'Export_data/'];

% Folder to save text file
 if exist([output_dir output_specific 'Peak_frequency/'], 'dir') == 0
    mkdir([output_dir output_specific 'Peak_frequency/'])
 end

 % Location of folder to save figures
Peak_freq = [output_dir output_specific 'Peak_frequency/'];
