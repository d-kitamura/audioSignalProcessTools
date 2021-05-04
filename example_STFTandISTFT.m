%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample program for applying STFT and ISTFT to audio signals             %
%                                                                         %
% Coded by D. Kitamura (d-kitamura@ieee.org)                              %
%                                                                         %
% See also:                                                               %
% http://d-kitamura.net                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % clear memory (workspace variables)
close all; % close all plot figures

% Parameters
wavPath1 = sprintf('./input/drums.wav'); % file path of wav signal
wavPath2 = sprintf('./input/piano.wav'); % file path of wav signal

% Read audio files
[s1,fs] = audioread(wavPath1); % fs: sampling frequency [Hz], s1 is a vector of size "length x channels"
[s2,fs] = audioread(wavPath2); % s1, s2, and s3 are column vectors because sample wave files are monaural

% Mixing with SNR = 0 [dB]
SNR = 0;
[x,s1,s2,coef] = SNRmix(s1,s2,SNR); % mixture signal of size "1 x length"

% Apply short-time Fourier transform (STFT)
fftSize = 2048;
shiftSize = fftSize/4;
winType = 'hamming';
[S1,analyWin,orgLen1] = STFT(s1,fftSize,shiftSize,winType);
[S2,analyWin,orgLen2] = STFT(s2,fftSize,shiftSize,winType);
[X,analyWin,orgLenX] = STFT(x,fftSize,shiftSize,winType);

% Show spectrograms
showSpectLite(S1,fs,shiftSize);
showSpectLite(S2,fs,shiftSize);
showSpectLite(X,fs,shiftSize);

% Apply inverse STFT (ISTFT)
y1 = ISTFT(S1,shiftSize,analyWin,orgLen1);
y2 = ISTFT(S2,shiftSize,analyWin,orgLen2);
z = ISTFT(X,shiftSize,analyWin,orgLenX);

% Numerical error caused by calculations in STFT and ISTFT
err1 = sum((s1-y1).^2)
err2 = sum((s2-y2).^2)
err3 = sum((x-z).^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%