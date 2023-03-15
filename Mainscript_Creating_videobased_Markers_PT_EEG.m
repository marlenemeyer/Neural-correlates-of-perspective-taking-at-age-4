%% Prepare Vidoe-based markers

%% extract video coding information from coded csv files
Extracting_video_coding_PT_EEG();

%% extract timing info from EEG and video coding and align them
Extracting_EEG_timingtest_PT_EEG();

%% Align EEG and video and create new video-based marker file
EEG_video_alignment_PT_EEG();

clc
clear all

% this should save all new markers in a variable called 'New_EventCodes'
% Now look at the "How to create video-based event lists" guide to create
% the video-based marker files for the pre-processing pipeline