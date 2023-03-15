%% Main Script walking through the steps for EEG analysis (Project: PT_EEG)
% belongs to manuscript "Neural correlates of perspective-taking in 4-year-olds"

%Run the Initializing Script to set variables and parameters
cd 'D:\PT_EEG_Analysis\' % specify location of EEG scritpts
Initializing_Script_PT_EEG();

%% preparing video-based markers from video-coding files such that they can be added to the EEG file in preprocessing step 1 
Mainscript_Creating_videobased_Markers_PT_EEG();
% this saves all new markers in a variable called 'New_EventCodes'
% Look at the "How to create video-based event lists" guide to create
% the video-based marker files for the pre-processing pipeline

%% Preprocessing step 1 that runs the ICA and Adjust etc.
Preprocessing_step1_PT_EEG()
% IMPORTANT: after running this step --> check automatically-detected IC
% components manually (1-35) and save that step as '_Adjust_checked'

%% Preprocessing step 2 that excludes artifacts from the data etc.
% Here, participants will be excluded if they do not have enough trials
Preprocessing_step2_PT_EEG()

%% Preprocessing step 3 to epoch the data, reject artifact and rereference
Preprocessing_step3_epoching_PT_EEG()

%% Before running CSD and TFR, check how many trials are left when splitting up conditions
Trial_cond_numbers_PT_EEG();

%% calculate CSD transform
CSD_transform_PT_EEG();

%% extract frequency information
Time_Frequency_Analysis_PT_EEG()

%% create topoplot
Topo_Plot_Time_Range_PT_EEG()

%% prepare channel clusters to produce TFR plots 
Channel_Cluster_EG_PT_EEG()	

%% generate time-frequency plots of the clusters
TimeFrequency_Plot_1_ContrastConds_PT_EEG()

%% compare clusters fdr corrrected
Compute_TimeFreqs_Signif_btw_condition_PT_EEG()

%% plot TFR of clusters with significance mask
Signif_Time_Frequency_Plot_PT_EEG()

%% plot topography of effects between conditions
Topo_Plot_ROI_Results_all_PT_EEG()

%% plot topography which is time-resolved of effects between conditions
Topo_Plot_summary_Results_all_PT_EEG()

%% extract individual values for FDR results
Extract_ROI_indiv_PT_EEG()

%% extract individual values for PT CanSee vs. DoesNotSee contrast
Extract_ROI_indiv_PTDoesNotvsCanSee_PT_EEG()
