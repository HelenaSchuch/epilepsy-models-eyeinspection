%% Fabio Viegas Caixeta and Helena Carvalho Schuch @ UnB, Brasilia, Brasil - June/2019
% Script for Spectral analysis of rodents seizure data
clear; clc; clf

dir = cd(['/Users/fabiovcaixeta/Dropbox/2019_UnB_ano_3/Pesquisa/' ...
'LabEletrofisioHumana/Mestrandos/Helena-Mestrado_2019-1/Analises_epilepsia']);

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

%% Peridogram Plotting (applying Welch)
clf
for n= 1:3
    [Pxx(n,:), F] = pwelch(data(n,:),2^12,[],2^12,srate); % spectral power of channels
end
figure(3)
plot(F, Pxx(1,:), 'linewidth',3)
hold on
plot(F, Pxx(2,:), 'linewidth',3)
plot(F, Pxx(3,:), 'linewidth',3)
xlim([0,45]);
title('spectral power of EEG channels data')
legend('Occipital','Frontal','Parietal')

