%Initializing Script

clear
clc

cd 'D:\PT_EEG_Analysis\'% go to the folder that contains all the scripts current directory

%% Initialize all variables that are specific to this project
Individualized_Info_PT_EEG();

cd 'D:\PT_EEG_Analysis\'

addpath(genpath('D:\PT_EEG_Analysis\eeglab14_0_0b\eeglab14_0_0b')); % add the path with the EEGlab toolbox

eeglab; % launch EEGlab toolbox

cd 'D:\PT_EEG_Analysis\'

