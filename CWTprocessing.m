% load radar_sig

st_time = 1000;     % start time
end_time = 1100;    % end time
radar_fs = 20;

[b1,a1] = butter(5,0.1/(radar_fs/2), 'high'); % 0.1 Hz cutoff frequency - high pass filtering
[b2,a2] = butter(5,4/(radar_fs/2), 'low');    % 4 Hz cutoff frequency - low pass filtering

f_sig = filtfilt(b1,a1, radar_sig);   % high pass filtering
ff_sig = filtfilt(b2,a2, f_sig);    % low pass filtering

% Filtering check
figure;
subplot(211); plot(radar_sig((st_time-1)*radar_fs+1 : end_time*radar_fs)); axis tight;
subplot(212); plot(ff_sig((st_time-1)*radar_fs+1 : end_time*radar_fs)); axis tight;

tms = (0:numel(ff_sig)-1)/radar_fs;
[cfs, frq] = cwt(ff_sig, radar_fs, 'FrequencyLimits', [0 5]);

% CWT check
figure;
subplot(211), plot(ff_sig((st_time-1)*radar_fs+1 : end_time*radar_fs)); axis tight;
subplot(212), surface(tms((st_time-1)*radar_fs+1 : end_time*radar_fs), frq, abs(cfs(:, (st_time-1)*radar_fs+1 : end_time*radar_fs))); axis tight; shading flat; 

CWTData.fs = radar_fs;
CWTData.filtData = ff_sig;
CWTData.time = tms;
CWTData.freq = frq;
CWTData.Power = abs(cfs);

save CWTData.mat CWTData

set(gca, 'Visible', 'off');
colorbar('off');
exportgraphics(gca, 'CWTimage.jpg');
close all;