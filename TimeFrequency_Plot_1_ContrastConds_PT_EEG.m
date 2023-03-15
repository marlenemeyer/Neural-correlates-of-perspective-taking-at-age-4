  
        
% Data location
data_location = TFR_Clustered_Data;
save_data_location = TFR_Clustered_Data;

% Condition name
Condition_Name = cond_labels;

% Channel list
Channels = cluster_labels;

%% PT vs. Color
% Plot contrast
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
            
        data_file1 = [data_location Condition_Name{1} , '_tf_', Channels{chan}];
        load(data_file1)
        mean_tf_data_PT_Can = mean_tf_data;
        clear mean_tf_data tf_data
                
        data_file2 = [data_location Condition_Name{2} , '_tf_', Channels{chan}];
        load(data_file2)
        mean_tf_data_PT_DoesNot = mean_tf_data;
        clear mean_tf_data tf_data
           
        data_file3 = [data_location Condition_Name{3} , '_tf_', Channels{chan}];
        load(data_file3)
        mean_tf_data_Color_Y = mean_tf_data;
        clear mean_tf_data tf_data
                
        data_file4 = [data_location Condition_Name{4} , '_tf_', Channels{chan}];
        load(data_file4)
        mean_tf_data_Color_R = mean_tf_data;
        clear mean_tf_data tf_data
        
      
        mean_PT = (mean_tf_data_PT_Can + mean_tf_data_PT_DoesNot) ./2;
        mean_Color = (mean_tf_data_Color_Y + mean_tf_data_Color_R) ./2;
       
        diff_mean_tf_data3 = (mean_PT - mean_Color)./(mean_PT + mean_Color);
        
        subplot(3,5,idx_subplot(chan))
        contourf(times, freqs, diff_mean_tf_data3, 20,'linecolor','none');
        set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
        set(gca,'FontName','Times New Roman', 'FontSize', 14);
        title(['PT - Color ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
               
        if  chan==1
                 colorbar('eastoutside' )
        end
 
    ylabel ('Frequency (Hz)')
    colormap('jet')
        
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);   
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'TFR_Contrasts_PT_vs_Color'], 'png')



%% PT Does Not See vs. Can See
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
            
        data_file1 = [data_location Condition_Name{1} , '_tf_', Channels{chan}];
        load(data_file1)
        mean_tf_data_PT_Can = mean_tf_data;
        clear mean_tf_data tf_data
                
        data_file2 = [data_location Condition_Name{2} , '_tf_', Channels{chan}];
        load(data_file2)
        mean_tf_data_PT_DoesNot = mean_tf_data;
        clear mean_tf_data tf_data
       
        diff_mean_tf_data3 = (mean_tf_data_PT_DoesNot - mean_tf_data_PT_Can)./(mean_tf_data_PT_DoesNot + mean_tf_data_PT_Can);
        
        subplot(3,5,idx_subplot(chan))
        contourf(times, freqs, diff_mean_tf_data3, 20,'linecolor','none');
        set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
        set(gca,'FontName','Times New Roman', 'FontSize', 14);
        title(['PT Does Not See - CanSee ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
               
        if  chan==1
                 colorbar('eastoutside' )
        end
        
    ylabel ('Frequency (Hz)')
    colormap('jet')
        
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);   
set(gca,'FontName','Times New Roman', 'FontSize', 14);

saveas(gcf, [Figures 'TFR_Contrasts_PT_DoesNotSee_vs_CanSee'], 'png')

%% Color Not Yellow vs. Yellow
figure; clf
idx_subplot = [3,11,15,7,9];

for chan=1:length(Channels)
            
        data_file1 = [data_location Condition_Name{3} , '_tf_', Channels{chan}];
        load(data_file1)
        mean_tf_data_Color_Y = mean_tf_data;
        clear mean_tf_data tf_data
                
        data_file2 = [data_location Condition_Name{4} , '_tf_', Channels{chan}];
        load(data_file2)
        mean_tf_data_Color_NotY= mean_tf_data;
        clear mean_tf_data tf_data
       
        diff_mean_tf_data3 = (mean_tf_data_Color_NotY - mean_tf_data_Color_Y)./(mean_tf_data_Color_NotY + mean_tf_data_Color_Y);
        
        subplot(3,5,idx_subplot(chan))
        contourf(times, freqs, diff_mean_tf_data3, 20,'linecolor','none');
        set(gca, 'ylim', freq2plot, 'xlim', time2plot, 'clim', clim_diff);
        set(gca,'FontName','Times New Roman', 'FontSize', 14);
        title(['PT - Color ',Channels{chan}], 'FontName','Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
               
        if  chan==1
                 colorbar('eastoutside' )
        end
        
    ylabel ('Frequency (Hz)')
    colormap('jet')
        
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);   
set(gca,'FontName','Times New Roman', 'FontSize', 14);

saveas(gcf, [Figures 'TFR_Contrasts_Color_NotYellow_vs_Yellow'], 'png')
