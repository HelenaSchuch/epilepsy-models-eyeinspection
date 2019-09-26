%% Fabio Viegas Caixeta and Helena Carvalho Schuch @ UnB, Brasilia, Brasil - June/2019
%% Script for root mean square analysis of different signal frquency bands
clear; clc; clf

% dir = cd(['/Users/fabiovcaixeta/Dropbox/2019_UnB_ano_3/Pesquisa/' ...
% 'LabEletrofisioHumana/Mestrandos/Helena-Mestrado_2019-1/Analises_epilepsia']);

dir = cd(['C:\Users\helen\Dropbox\Helena-Mestrado\Analises_epilepsia']);

filename = 'rato1_PTZ.mat';
topo = 500;% max amplitude
% rato1_PTZ file changes between 1960 and 1970 sec.

load(filename)
filename = strrep(filename,'_',' '); % fix figure name

ch = [1 2 3];% channels
srate= hdr.frequency(1); % sampling frequency
dt = 1/srate;% sample interval
time_vector = dt:dt:dt*length(data);
y_label = {'Frontal? (uV)','Parietal? (uV)','Occiptal? (uV)'};

downsample_factor = 1; % to turn off downsampling, use 1.
dt = dt*downsample_factor; % if 20, adjust dt from 2000 to 100
srate= 1/dt; % sampling frequency
data = data(:,1:downsample_factor:end); % downsample data from 20kHz to 1kHz
time_vector = dt:dt:dt*length(data); % corrected time_window

figure(1)
count = 0;
for n = ch
    count = count+1; % ajusts the loop for channels 1,2,3
    plots(count) = subplot(length(ch), 1, count);
    plot(time_vector,data(n,:),'k') % plot full data
    hold on
    ylabel(y_label(n))
    ylim([-topo topo])
    set(gca,'box','off'); % adjusts figure properties
end

set(gcf,'color','w') % adjusts figure properties
xlabel('Time (s)')
linkaxes(plots,'x')
subplot(length(ch),1,1)
title(filename)

%% Plotting RMS

figure(2)
limiar = 800;
data_ch1 = data(1,:); % Channel of interest
noise = find(abs(data_ch1(1,:))> limiar); % above limiar data (noise)
data_ch1_clipped = data_ch1;
data_ch1_clipped(1,noise) = mean(data_ch1); % cut noise from data

% janelamento:
window = 10; % in seconds
window2 = window/dt; 
t = time_vector(1):window2:length(time_vector); 

subplot(321) % total RMS 

data_window = []; % creates data_window
RMS = []; % creates RMS
for n = 1:length(t)-1
    data_window(n,:) = data_ch1_clipped(1,1+window2*(n-1):window2*(n)); % restrict data to windows 
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS), 'r')
% ylim([0 80])
% xlim([1 3]*10^6)
title(' total RMS - frontal electrode')

subplot(322)

data_filt = eegfilt(data_ch1_clipped,srate,0.5,4);
data_window = []; 
RMS = [];
for n = 1:length(t)-1
    data_window(n,:) = data_filt(1,1+window2*(n-1):window2*(n)); 
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS))
% ylim([0 80])
title('RMS in Delta (0.5-4 Hz)')

subplot(323)

data_filt = eegfilt(data_ch1_clipped,srate,4.5,7.5);
data_window = []; 
RMS = []; 
for n = 1:length(t)-1
    data_window(n,:) = data_filt(1,1+window2*(n-1):window2*(n)); 
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS))
% ylim([0 80])
% xlim([1 3]*10^6)
title('RMS in Theta (4.5-7.5 Hz)')

subplot(324)

data_filt = eegfilt(data_ch1_clipped,srate,8,13);
data_window = []; 
RMS = []; 
for n = 1:length(t)-1
    data_window(n,:) = data_filt(1,1+window2*(n-1):window2*(n)); 
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS))
% ylim([0 80])
% xlim([1 3]*10^6)
title('RMS in Alpha (8-13 Hz)')

subplot(325)

data_filt = eegfilt(data_ch1_clipped,srate,13,30);
data_window = [];
RMS = []; 
for n = 1:length(t)-1
    data_window(n,:) = data_filt(1,1+window2*(n-1):window2*(n));
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS))
% ylim([0 80])
% xlim([1 3]*10^6)
title('RMS in Beta (13-30 Hz)')

subplot(326)

data_filt = eegfilt(data_ch1_clipped,srate,35,45);
data_window = []; 
RMS = []; 
for n = 1:length(t)-1
    data_window(n,:) = data_filt(1,1+window2*(n-1):window2*(n)); 
end
RMS= rms(data_window');
plot(t(1:end-1),(RMS))
% ylim([0 80])
% xlim([1 3]*10^6)
title('RMS in Gamma (35-45 Hz)')