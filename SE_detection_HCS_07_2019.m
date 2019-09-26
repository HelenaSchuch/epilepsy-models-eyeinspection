%% Helena C. Schuch @UnB, Brasília, Brasil - July/2019
% Script for Status Epilepticus detection 
% Criteria for SE: >= 20 sec of uninterrupted crises
clear; clc; clf

dir = cd(['C:\Users\helen\Dropbox\Helena-Mestrado\Analises_epilepsia']);
filename = 'rato1_PTZ';
topo = 500;% max amplitude
load(filename)
filename = strrep(filename,'_',' '); % fix figure name

ch = [1 2 3]; % channels
srate= hdr.frequency(1); % frequency
dt = 1/srate; % sample interval
time_vector = dt:dt:dt*length(data);
y_label = {'EEG 1 (uV)','EEG 2 (uV)','EEG 3 (uV)'};

downsample_factor = 20; % to turn off downsampling, use 1.
dt = dt*downsample_factor; % if 20, adjust dt from 2000 to 100
data = data(:,1:downsample_factor:end); % downsample data from 20kHz to 1kHz
time_vector = dt:dt:dt*length(data); % corrected time_window
srate = srate/downsample_factor;

% janelamento:
window = 2; % in sec
window2 = window/dt;
t = time_vector(1):window2:length(time_vector); % 10seconds/dt intervals
% data_filt = eegfilt(data,srate,1,30);

RMS = [];
data_window = []; % create data_window variable
for n = 1:length(t)-1
    data_window(n,:) = data(2,1+window2*(n-1):window2*(n));  % restricts data to 10 sec windows
%     data_window(n,:) = data_filt(2,1+window2*(n-1):window2*(n));
end
RMS= rms(data_window');

figure(1)
count = 0;
for n = ch
    count = count+1; % ajusts the loop for channels 1,2,3
    plots(count) = subplot(length(ch)+1, 1, count);
    plot(time_vector,data(n,:),'k') % plot full data
    hold on
    ylabel(y_label(n))
    ylim([-topo topo])
%     xlim([1650, time_vector(end)])
    set(gca,'box','off'); % adjusts figure properties
end
set(gcf,'color','w')
linkaxes(plots,'x')

% ax = subplot(length(ch)+1,1,length(ch)+1);
subplot(length(ch)+1,1,length(ch)+1)
plot(t(1:end-1),(RMS), 'r')
ylabel('Amplitude RMS (V)')
set(gca,'box','off'); % adjusts figure properties
xlabel('Time (s)')
% xlim(time_vector([2 5.59]*10^5))
% linkaxes([plots,ax],'x')

subplot(length(ch)+1,1,1)
title(filename)

%% Status Epilepticus Detection
figure(2)
clf;
count = 0;
for n = ch
    count = count+1;
    plots(count) = subplot(length(ch), 1, count);
    plot(time_vector,data(n,:),'k')
    hold on
    ylabel(y_label(n))
%     xlim([1850 2000])
    ylim([-topo topo])
    set(gca,'box','off');
end

choice = questdlg(['Selecione o inicio do período de crise'], ...
    'Detecção de S.E','Estou pronto!','Estou pronto!'); % open dialog box
switch choice % creates "choice" scope
    
    case 'Estou pronto!'
        
        [addition_marker,~]=ginput(1); % atributes mouse input to "addition_marker"
        [~,add_marker(1)]= min(abs(time_vector-addition_marker)); % closest point to the selected region
        add_x(1) = time_vector(add_marker(1)); % point coordenates in x axis
        add_y(1) = data(1,add_marker(1)); % point coordenates in y axis
        %                 subplot(length(ch), 1, 1)
        hold on
        count = 0;
        for n = ch;
            count = count+1;
            subplot(length(ch), 1, count)
            scatter(add_x(1),add_y(1),'MarkerEdgeColor','y','MarkerFaceColor','y'); % creates colorful marker for the point
            plot([add_x(1) (add_x(1)+20)], [add_y(1) add_y(1)], 'y', 'LineWidth', 3) % extends marker for 20 seconds
        end
end

set(gcf,'color','w')
linkaxes(plots,'x')
subplot(length(ch),1,1)
title(filename)
subplot(length(ch),1,length(ch))
xlabel('Time (s)')