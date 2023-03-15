%% PT condition
% Load all Can See condition data in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(1)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_Can = zeros([size(tf_data_1) length(subject_list)]);
    end
    tf_all_PT_Can(:,:,:,sub) = tf_data_1;
end


% Load all Doesn Not See condition data in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(2)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_PT_DoesNot = zeros([size(tf_data_2) length(subject_list)]);
    end
    tf_all_PT_DoesNot(:,:,:,sub) = tf_data_2;
end

tf_all_PT = (tf_all_PT_Can+tf_all_PT_DoesNot)/2;
tf_all_PTCanMinDoesNot = (tf_all_PT_Can-tf_all_PT_DoesNot);

%% Control condition
% Load all Color Yellow condition data in a matrix freq x time x channel x subjects

for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(3)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_Y = zeros([size(tf_data_3) length(subject_list)]);
    end
    tf_all_Color_Y(:,:,:,sub) = tf_data_3;
end


% Load all Color Not Yellow condition data in a matrix freq x time x channel x subjects
for sub = 1:length(subject_list)
    subject  = subject_list{sub};
    load([TFR_Data subject, '_tf_data_' int2str(4)])
    
    % initialize matrices on 1st subject
    if sub == 1
        tf_all_Color_R = zeros([size(tf_data_4) length(subject_list)]);
    end
    tf_all_Color_R(:,:,:,sub) = tf_data_4;
end

tf_all_Color = (tf_all_Color_R+tf_all_Color_Y)/2;
tf_all_ColorYMinR = tf_all_Color_Y-tf_all_Color_R;
tf_all_Diff_PTMinColor = (tf_all_PT-tf_all_Color)./(tf_all_PT+tf_all_Color);

%%
% find indices corresponding to time and frequency windows
Time_Idx  = zeros(size(time_windows)); % initialize time indices
Mu_Freqs_Idx = zeros(size (mu_freq_windows)); % initialize frequency indices
Beta_Freqs_Idx = zeros(size (beta_freq_windows));
Theta_Freqs_Idx = zeros(size (theta_freq_windows));

% Find time indices
for i=1:size(time_windows,1)
    for j=1:2
        [~,Time_Idx(i,j)] = min(abs(times-time_windows(i,j)));
    end
end

% Find frequency indices
for i=1:size(mu_freq_windows,1)
    for j=1:2
        [~,Mu_Freqs_Idx(i,j)] = min(abs(freqs-mu_freq_windows(i,j)));
    end
end

% Find frequency indices
for i=1:size(beta_freq_windows,1)
    for j=1:2
        [~,Beta_Freqs_Idx(i,j)] = min(abs(freqs-beta_freq_windows(i,j)));
    end
end

% Find frequency indices
for i=1:size(theta_freq_windows,1)
    for j=1:2
        [~,Theta_Freqs_Idx(i,j)] = min(abs(freqs-theta_freq_windows(i,j)));
    end
end

for ti =1:size(time_windows,1)
    for fi=1:size(theta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap        
        topoplot(squeeze(mean(mean(mean(tf_all_Color_Y(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end

        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Color_R(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Theta_Color_YNotY'], 'png')
figure(1)
set(gcf,'name','Theta: PT and Color')


for ti =1:size(time_windows,1)
    for fi=1:size(theta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PT(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Color(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Theta_PT_Color'], 'png')

figure(2)
set(gcf,'name','Theta: PT - Color')


for ti =1:size(time_windows,1)
    for fi=1:size(theta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Diff_PTMinColor(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end

    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Theta_PT_Min_Color'], 'png')



%% Alpha
figure(3)
set(gcf,'name','Alpha: PT and Color')


for ti =1:size(time_windows,1)
    for fi=1:size(mu_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PT(Mu_Freqs_Idx(fi,1):Mu_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(mu_freq_windows(1)) '-' num2str(mu_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Color(Mu_Freqs_Idx(fi,1):Mu_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(mu_freq_windows(1)) '-' num2str(mu_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Alpha_PT_Color'], 'png')
figure(4)
set(gcf,'name','Alpha: PT - Color')


for ti =1:size(time_windows,1)
    for fi=1:size(mu_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Diff_PTMinColor(Mu_Freqs_Idx(fi,1):Mu_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(mu_freq_windows(1)) '-' num2str(mu_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end

    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Alpha_PT_Min_Color'], 'png')

%% Beta
figure(5)
set(gcf,'name','Beta: PT and Color')


for ti =1:size(time_windows,1)
    for fi=1:size(beta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PT(Beta_Freqs_Idx(fi,1):Beta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(beta_freq_windows(1)) '-' num2str(beta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Color(Beta_Freqs_Idx(fi,1):Beta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(beta_freq_windows(1)) '-' num2str(beta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Beta_PT_Color'], 'png')
figure(6)
set(gcf,'name','Beta: PT - Color')


for ti =1:size(time_windows,1)
    for fi=1:size(beta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_Diff_PTMinColor(Beta_Freqs_Idx(fi,1):Beta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(beta_freq_windows(1)) '-' num2str(beta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end

    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Beta_PT_Min_Color'], 'png')

figure(7)
set(gcf,'name','Beta: PTCan vs. DoesNot and ColorY vs. NotY')
for ti =1:size(time_windows,1)
    for fi=1:size(beta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PTCanMinDoesNot(Beta_Freqs_Idx(fi,1):Beta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(beta_freq_windows(1)) '-' num2str(beta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_ColorYMinR(Beta_Freqs_Idx(fi,1):Beta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(beta_freq_windows(1)) '-' num2str(beta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Beta_PTCan_Min_DoesNot_Y_Min_NY'], 'png') 

figure(8)
set(gcf,'name','Alpha: PTCan vs. DoesNot and ColorY vs. NotY')
for ti =1:size(time_windows,1)
    for fi=1:size(mu_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PTCanMinDoesNot(Mu_Freqs_Idx(fi,1):Mu_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(mu_freq_windows(1)) '-' num2str(mu_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_ColorYMinR(Mu_Freqs_Idx(fi,1):Mu_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(mu_freq_windows(1)) '-' num2str(mu_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Alpha_PTCan_Min_DoesNot_Y_Min_NY'], 'png') 

figure(9)
set(gcf,'name','Theta: PTCan vs. DoesNot and ColorY vs. NotY')
for ti =1:size(time_windows,1)
    for fi=1:size(theta_freq_windows,1)
        subplot(4,5,ti)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_PTCanMinDoesNot(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
        
        subplot(4,5,ti+10)
        % make topomap
        topoplot(squeeze(mean(mean(mean(tf_all_ColorYMinR(Theta_Freqs_Idx(fi,1):Theta_Freqs_Idx(fi,2),Time_Idx(ti,1):Time_Idx(ti,2),:,:),1), 2),4)),channel_location,'plotrad',.55,'maplimits',clim,'electrodes','off','numcontour',0);
        title([ '(' num2str(time_windows(ti,1)) ' ' num2str(time_windows(ti,2)) 'ms; ' num2str(theta_freq_windows(1)) '-' num2str(theta_freq_windows(2)) 'Hz)' ]);
        set(gca, 'FontName','Times New Roman', 'FontSize', 12, 'FontWeight', 'normal')
        if ti== size(time_windows,1)
            colorbar
        end
    end
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gca,'FontName','Times New Roman', 'FontSize', 14);
saveas(gcf, [Figures 'Topo_Theta_PTCan_Min_DoesNot_Y_Min_NY'], 'png') 
