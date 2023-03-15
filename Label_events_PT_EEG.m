% This script puts trial number to all the event markers. It does not
% delete any event from data. It also does not mark an event as good or
% bad. It just gives an additional level to the event marker, which
% can be used to exclude unwanted trials from analysis.


% Find the index of last event marker
lastevent_idx = length(EEG.event);

% Add a new field 'TrialNum' in EEGLAB event list and assign the value 'NaN'
EEG = pop_editeventfield( EEG, 'indices',  strcat('1:', int2str(length(EEG.event))), 'TrialNum','NaN'); % based on first EEG based marker for a trial
EEG = pop_editeventfield( EEG, 'indices',  strcat('1:', int2str(length(EEG.event))), 'WholeTrialNum','NaN'); % based on a first video-based marker for a trial

%%

if ~isempty(starttrial_markers)
    k=1;
    for i=1:length(EEG.event)
        if ismember(EEG.event(i).type,starttrial_markers)
            EEG.event(i).TrialNum = k;
            k=k+1;
        end
    end
end

%% Add trial number depending on baseline
trl_num = NaN;
for i=1:length(EEG.event)
    if ~isnan(EEG.event(i).TrialNum)
        trl_num = EEG.event(i).TrialNum;
    else
        EEG.event(i).TrialNum = trl_num;
    end
    
end
%% TrialDur_codes

if ~isempty(TrialDur_codes)
    k=1;
    for i=1:length(EEG.event)
        if ismember(EEG.event(i).type,TrialDur_codes)
            EEG.event(i).WholeTrialNum = k;
            k=k+1;
        end
    end
end

%% Add trial number depending on baseline
trl_num = NaN;
for i=1:length(EEG.event)
    if ~isnan(EEG.event(i).WholeTrialNum)
        trl_num = EEG.event(i).WholeTrialNum;
    else
        EEG.event(i).WholeTrialNum = trl_num;
    end
    
end

%% Make a sanity check
if ~isempty(starttrial_markers)   
    for i=1:length(EEG.event)
        if ismember(EEG.event(i).type,starttrial_markers)
            if EEG.event(i).TrialNum == EEG.event(i).WholeTrialNum
            else
                disp(['$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ CAUTION: Video-based trial numbers do NOT match with EEG markers on EEG trial ' int2str(EEG.event(i).TrialNum )]);
            end
        end
    end
end
