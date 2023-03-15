%% exclude trials based on video coding
all_markers = [experimental_markers, baseline_markers];
videobased_exclusion_overview = 0;
videobased_count_overview = 0;
total_trials_exp = 0;
total_trials_base = 0;
for x=1:length(EEG.event)
    if sum(strcmp(EEG.event(x).type,experimental_markers))==1
        total_trials_exp = total_trials_exp+1;
    elseif sum(strcmp(EEG.event(x).type,baseline_markers))==1
        total_trials_base = total_trials_base+1;
    end
end
Exclusion_Info.(subject).BeforeExl_EXP =total_trials_exp;
Exclusion_Info.(subject).BeforeExl_BASE =total_trials_base;

% create empty new field for exclusion check
EEG.event(1).exclusion = [];
EEG.event(1).count = [];
EEG.event(1).count_type = [];

%% Exclude entire trial if needed based on video-coding (e.g. parental interference)
% first based on these: interference_markers_entiretrial

for xc = 1:size(interference_markers_entiretrial,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,TrialDur_codes))==1 % if this marker is part of any marker of interest
            start_seg = [];
            end_seg = [];
            

            start_seg = EEG.event(i).latency; % calculate onset of entire trial segment
            end_seg = (EEG.event(i).duration/1000)*EEG.srate; % calculate offset of entire trial segment

            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_entiretrial{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf >= start_seg && start_interf <= end_seg % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];
                            idx_trial = find(start_seg<=latency_column & end_seg>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_entiretrial{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end    
                        end
                    end
                end
            end
        end
    end
end

%% add the information about how many trials per exclusion criterion are rejected to the overview variable
videobased_exclusion_overview(1,1:size(interference_markers_entiretrial,2))=0;

for xc = 1:size(interference_markers_entiretrial,2) % go through all possible intertference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x} '_Excl_' interference_markers_entiretrial{xc}]))==1
               count_trl = count_trl+1;
              videobased_exclusion_overview(1,xc) = count_trl;
             
          end

        end
    end
end

%% Exclude entire trial if needed based on video-coding (e.g. children handing over both toys)
% first based on these: interference_markers_entiretrial_ChoiceBehav

for xc = 1:size(interference_markers_entiretrial_ChoiceBehav,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,TrialDur_codes))==1 % if this marker is part of any marker of interest
            start_seg = [];
            end_seg = [];
            

            start_seg = EEG.event(i).latency; % calculate onset of entire trial segment
            end_seg = (EEG.event(i).duration/1000)*EEG.srate; % calculate offset of entire trial segment

            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_entiretrial_ChoiceBehav{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf >= start_seg && start_interf <= end_seg % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];
                            idx_trial = find(start_seg<=latency_column & end_seg>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_entiretrial_ChoiceBehav{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end    
                        end
                    end
                end
            end
        end
    end
end
idx_overview = size(interference_markers_entiretrial,2);
videobased_exclusion_overview(1,idx_overview+1:idx_overview+size(interference_markers_entiretrial_ChoiceBehav,2))=0;

for xc = 1:size(interference_markers_entiretrial_ChoiceBehav,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x} '_Excl_' interference_markers_entiretrial_ChoiceBehav{xc}]))==1
               count_trl = count_trl+1;
              videobased_exclusion_overview(1,xc+idx_overview) = count_trl;
             
          end

        end
    end
end



for xc = 1:size(interference_markers_b_p_d,2) % go through all possible interference markers/reasons separately


    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,baseline_markers))==1 % if this marker is part of any marker of interest
            start_seg = [];
            end_seg = [];
            

            start_seg = EEG.event(i).latency-1000; % calculate onset of time window segment
            find_end_idx = i+1;
            while sum(strcmp(EEG.event(find_end_idx).type,experimental_markers))==0
                find_end_idx = find_end_idx+1;
            end
            
           
            if sum(strcmp(EEG.event(find_end_idx).type,experimental_markers))==1
            else
                disp(['------------------> WARNING: check what window of interest ends on!']);
            end
            end_seg = EEG.event(find_end_idx).latency+2000; % calculate offset time segment

            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_b_p_d{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    end_interf =  (EEG.event(j).duration/1000)*EEG.srate;
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf <= start_seg && end_interf >= start_seg % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_p_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        elseif start_interf >= start_seg && start_interf <= end_seg
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_p_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        end
                    end
                end
            end
        end
    end
end

idx_overview = idx_overview+size(interference_markers_entiretrial_ChoiceBehav,2);
videobased_exclusion_overview(1,idx_overview+1:idx_overview+size(interference_markers_b_p_d,2))=0;

for xc = 1:size(interference_markers_b_p_d,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x} '_Excl_' interference_markers_b_p_d{xc}]))==1
               count_trl = count_trl+1;
              videobased_exclusion_overview(1,xc+idx_overview) = count_trl;
             
          end

        end
    end
end


for xc = 1:size(interference_markers_b_d,2) % go through all possible interference markers/reasons separately


    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,baseline_markers))==1 % if this marker is part of any marker of interest
            start_seg_b = [];
            end_seg_b = [];
            start_seg_d = [];
            end_seg_d = [];

            start_seg_b = EEG.event(i).latency-1000; % calculate onset of time window segment
            end_seg_b = EEG.event(i).latency; % calculate offset time segment

            find_start_idx = i+1;
            while sum(strcmp(EEG.event(find_start_idx).type,experimental_markers))==0
                find_start_idx = find_start_idx+1;
            end
            
           
            if sum(strcmp(EEG.event(find_start_idx).type,experimental_markers))==1
            else
                disp(['------------------> WARNING: check what window of interest ends on!']);
            end

            start_seg_d = EEG.event(find_start_idx).latency; % calculate onset of time window segment
            end_seg_d = EEG.event(find_start_idx).latency+2000; % calculate offset time segment
            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_b_d{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    end_interf =  (EEG.event(j).duration/1000)*EEG.srate;
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf <= start_seg_b && end_interf >= start_seg_b % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        elseif start_interf >= start_seg_b && start_interf <= end_seg_b
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end
                            
    
      
                        elseif start_interf <= start_seg_d && end_interf >= start_seg_d % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        elseif start_interf >= start_seg_d && start_interf <= end_seg_d
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
      
                            
                        end
                    end
                end
            end
        end
    end
end

idx_overview = idx_overview+size(interference_markers_b_p_d,2);
videobased_exclusion_overview(1,idx_overview+1:idx_overview+size(interference_markers_b_d,2))=0;

for xc = 1:size(interference_markers_b_d,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x} '_Excl_' interference_markers_b_d{xc}]))==1
               count_trl = count_trl+1;
              videobased_exclusion_overview(1,xc+idx_overview) = count_trl;
             
          end

        end
    end
end


for xc = 1:size(interference_markers_p,2) % go through all possible interference markers/reasons separately


    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,baseline_markers))==1 % if this marker is part of any marker of interest
            start_seg = [];
            end_seg = [];
            

            start_seg = EEG.event(i).latency; % calculate onset of time window segment
            find_end_idx = i+1;
            while sum(strcmp(EEG.event(find_end_idx).type,experimental_markers))==0
                find_end_idx = find_end_idx+1;
            end
            
           
            if sum(strcmp(EEG.event(find_end_idx).type,experimental_markers))==1
            else
                disp(['------------------> WARNING: check what window of interest ends on!']);
            end
            end_seg = EEG.event(find_end_idx).latency; % calculate offset time segment

            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_p{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    end_interf =  (EEG.event(j).duration/1000)*EEG.srate;
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf <= start_seg && end_interf >= start_seg % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_p{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        elseif start_interf >= start_seg && start_interf <= end_seg
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_p{xc}];
                                EEG.event(idx_trial(entire_t)).exclusion = 1;

                            end  
                        end
                    end
                end
            end
        end
    end
end

idx_overview = idx_overview+size(interference_markers_b_d,2);
videobased_exclusion_overview(1,idx_overview+1:idx_overview+size(interference_markers_p,2))=0;

for xc = 1:size(interference_markers_p,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x} '_Excl_' interference_markers_p{xc}]))==1
               count_trl = count_trl+1;
              videobased_exclusion_overview(1,xc+idx_overview) = count_trl;
             
          end

        end
    end
end

for xc = 1:size(interference_markers_count_b_d,2) % go through all possible interference markers/reasons separately


    for i = 1:length(EEG.event) % go through entire event list
        if  sum(strcmp(EEG.event(i).type,baseline_markers))==1 % if this marker is part of any marker of interest
            start_seg_b = [];
            end_seg_b = [];
            start_seg_d = [];
            end_seg_d = [];

            start_seg_b = EEG.event(i).latency-1000; % calculate onset of time window segment
            end_seg_b = EEG.event(i).latency; % calculate offset time segment

            find_start_idx = i+1;
            while sum(strcmp(EEG.event(find_start_idx).type,experimental_markers))==0
                find_start_idx = find_start_idx+1;
            end
            
           
            if sum(strcmp(EEG.event(find_start_idx).type,experimental_markers))==1
            else
                disp(['------------------> WARNING: check what window of interest ends on!']);
            end

            start_seg_d = EEG.event(find_start_idx).latency; % calculate onset of time window segment
            end_seg_d = EEG.event(find_start_idx).latency+2000; % calculate offset time segment
            
            for  j = 1:length(EEG.event) % go through each event again to check the current interference markers for any potential overlap
                if sum(strcmp(EEG.event(j).type,interference_markers_count_b_d{xc}))==1 % if that event is part of the interference codes
                    start_interf = round(EEG.event(j).latency);% take onset of interference period
                    end_interf =  (EEG.event(j).duration/1000)*EEG.srate;
                    
                    if isempty(EEG.event(i).exclusion)
                        if start_interf <= start_seg_b && end_interf >= start_seg_b % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                %EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).count = 1;
                                EEG.event(idx_trial(entire_t)).count_type = ['Count_' interference_markers_count_b_d{xc}];

                            end  
                        elseif start_interf >= start_seg_b && start_interf <= end_seg_b
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                %EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).count = 1;
                                EEG.event(idx_trial(entire_t)).count_type = ['Count_' interference_markers_count_b_d{xc}];


                            end
                            
    
      
                        elseif start_interf <= start_seg_d && end_interf >= start_seg_d % if this exclusion criteria is fulfilled --> add "Excl..." to current experimental marker
                            latency_column = [EEG.event(:).latency];

                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                                %EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).count = 1;
                                EEG.event(idx_trial(entire_t)).count_type = ['Count_' interference_markers_count_b_d{xc}];


                            end  
                        elseif start_interf >= start_seg_d && start_interf <= end_seg_d
                             latency_column = [EEG.event(:).latency];
                            find_end_idx_2 = i-1;
                            while sum(strcmp(EEG.event(find_end_idx_2).type,TrialDur_codes))==0
                                find_end_idx_2 = find_end_idx_2-1;
                            end
                            start_seg_trl = EEG.event(find_end_idx_2).latency; % calculate onset of entire trial segment
                            end_seg_trl = (EEG.event(find_end_idx_2).duration/1000)*EEG.srate; % calculate offset of entire trial segment
                            
                            idx_trial = find(start_seg_trl<=latency_column & end_seg_trl>=latency_column);
                            
                            for entire_t = 1:length(idx_trial)
                                
                               % EEG.event(idx_trial(entire_t)).type = [EEG.event(idx_trial(entire_t)).type '_Excl_' interference_markers_b_d{xc}];
                                EEG.event(idx_trial(entire_t)).count = 1;
                                EEG.event(idx_trial(entire_t)).count_type = ['Count_' interference_markers_count_b_d{xc}];

                            end  
      
                            
                        end
                    end
                end
            end
        end
    end
end


videobased_count_overview(1,1:size(interference_markers_count_b_d,2))=0;

for xc = 1:size(interference_markers_count_b_d,2) % go through all possible interference markers/reasons separately
    count_trl = 0;

    for i = 1:length(EEG.event) % go through entire event list
        for x = 1:size(TrialDur_codes,2)
          if sum(strcmp( EEG.event(i).type, [TrialDur_codes{x}]))==1 & EEG.event(i).count==1 & sum(strcmp( EEG.event(i).count_type, ['Count_' interference_markers_count_b_d{xc}]))==1
           
               count_trl = count_trl+1;             
             
          end
        end
    end
    videobased_count_overview(1,xc) = count_trl;
end


%Headers for the video based exclusion
Exclusion_Info.(subject).videobased_exclusion_overview = videobased_exclusion_overview;
Exclusion_Info.(subject).videobased_exclusion_overview_header = [interference_markers_entiretrial, interference_markers_entiretrial_ChoiceBehav, interference_markers_b_p_d, interference_markers_b_d, interference_markers_p];

%Headers for the video based counts
Exclusion_Info.(subject).videobased_count_overview = videobased_count_overview;
Exclusion_Info.(subject).videobased_count_overview_header = [interference_markers_count_b_d];

total_trials_exp = 0;
total_trials_base = 0;
for x=1:length(EEG.event)
    if sum(strcmp(EEG.event(x).type,experimental_markers))==1
        total_trials_exp = total_trials_exp+1;
    elseif sum(strcmp(EEG.event(x).type,baseline_markers))==1
        total_trials_base = total_trials_base+1;
    end
end
Exclusion_Info.(subject).AFTERExl_EXP =total_trials_exp;
Exclusion_Info.(subject).AFTERExl_BASE =total_trials_base;

