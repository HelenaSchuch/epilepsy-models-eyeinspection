clear; clc; clf;
dir = cd('C:\Users\helen\Desktop\Dados Rafael edf')
[hdr, p1] = edfread('Rafael (base-02)PTZAM251_2014-02-20_10_37_03.edf'); % reads .edf files and atributes them to variable
[hdr, p2] = edfread('Rafael (rato-02)PTZAM251_2014-02-20_12_33_13.edf'); 
data=[p1 zeros(4,1*10^5) p2];
tam = [size(p1); size(p2)];
% mkdir('mat') % creates directory for files
save([dir filesep 'mat' filesep 'rato2_PTZAM251_new.mat'],'data','hdr')
display('Concatenation finished')