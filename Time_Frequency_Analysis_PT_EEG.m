%% Extract frequency information
% Perform time frequency calculation

% Check if variable Exclusion_Info exists already. If yes, load it.
if exist([output_dir output_specific 'Exclusion_Info.mat']) == 2
    load([output_dir output_specific 'Exclusion_Info'],'Exclusion_Info');
end


for s=1:length(subject_list)
    
    subject = subject_list{s};
    
    EEGa = []; % Initialize variable for each condition
    EEGb = []; 
    EEGc = [];
    EEGd = [];
    
    % Load pre-processed dataset and make separate condition from loaded dataset
    EEG=pop_loadset('filename',[subject '_Epoched_Matched_CSD_' trial_type{2} '.set'], 'filepath', CSD_Data);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    EEG_exp=EEG;
    EEG_exp1 = pop_selectevent( EEG_exp, 'type', DC_experimental_PT_Can,'deleteevents','off','deleteepochs','on','invertepochs','off');
    EEG_exp2 = pop_selectevent( EEG_exp, 'type', DC_experimental_PT_DoesNot,'deleteevents','off','deleteepochs','on','invertepochs','off');
    EEG_exp3 = pop_selectevent( EEG_exp, 'type', DC_experimental_Color_Y,'deleteevents','off','deleteepochs','on','invertepochs','off');
    EEG_exp4 = pop_selectevent( EEG_exp, 'type', DC_experimental_Color_R,'deleteevents','off','deleteepochs','on','invertepochs','off');
    
    channel_location = EEG.chanlocs; % Channel location is required for topograpic plot
    
    % Conduct frequency analysis
    for elec = 1:EEG_exp.nbchan
        
		%% Condition 1
		
        [ersp, itc, powbase, times, freqs] = newtimef(EEG_exp1.data(elec,:,:), EEG_exp1.pnts, [EEG_exp1.xmin EEG_exp1.xmax]*1000,...
            EEG_exp1.srate,[3 0.5], 'baseline', NaN, 'freqs', freqOI,'nfreqs', 150,...
            'plotersp','off', 'plotitc', 'off', 'plotphase', 'off', 'padratio', 8);
        
        tf_data_1(:,:,elec)=ersp;
        
        %% Condition 2
       
        [ersp, itc, powbase, times, freqs] = newtimef(EEG_exp2.data(elec,:,:), EEG_exp2.pnts, [EEG_exp2.xmin EEG_exp2.xmax]*1000,...
            EEG_exp2.srate,[3 0.5], 'baseline', NaN, 'freqs', freqOI,'nfreqs', 150,...
            'plotersp','off', 'plotitc', 'off', 'plotphase', 'off', 'padratio', 8);
        
        tf_data_2(:,:,elec)=ersp;
        
        
        %% Condition 3
        
        [ersp, itc, powbase, times, freqs] = newtimef(EEG_exp3.data(elec,:,:), EEG_exp3.pnts, [EEG_exp3.xmin EEG_exp3.xmax]*1000,...
            EEG_exp3.srate,[3 0.5], 'baseline', NaN, 'freqs', freqOI,'nfreqs', 150,...
            'plotersp','off', 'plotitc', 'off', 'plotphase', 'off', 'padratio', 8);
        
        tf_data_3(:,:,elec)=ersp;
        
        
        %% Condition 4

        [ersp, itc, powbase, times, freqs] = newtimef(EEG_exp4.data(elec,:,:), EEG_exp4.pnts, [EEG_exp4.xmin EEG_exp4.xmax]*1000,...
            EEG_exp4.srate,[3 0.5], 'baseline', NaN, 'freqs', freqOI,'nfreqs', 150,...
            'plotersp','off', 'plotitc', 'off', 'plotphase', 'off', 'padratio', 8);
        
        tf_data_4(:,:,elec)=ersp;
    end
    
    %% Save data
    save_data1=[subject, '_tf_data_1'];
    save ([TFR_Data save_data1], 'tf_data_1', 'times', 'freqs', 'channel_location', '-v7.3');
    
    save_data2=[subject, '_tf_data_2'];
    save ([TFR_Data save_data2], 'tf_data_2', 'times', 'freqs', 'channel_location','-v7.3');
    
    save_data3=[subject, '_tf_data_3'];
    save ([TFR_Data save_data3], 'tf_data_3', 'times', 'freqs', 'channel_location','-v7.3');
    
    save_data4=[subject, '_tf_data_4'];
    save ([TFR_Data save_data4], 'tf_data_4', 'times', 'freqs', 'channel_location','-v7.3');
    
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    save([output_dir 'Exclusion_Info'],'Exclusion_Info');
end
