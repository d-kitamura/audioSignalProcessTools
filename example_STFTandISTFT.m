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

% Audio read
[s1,fs] = audioread(wavPath1); % fs: sampling frequency [Hz], s1 is a vector of size "length x channels"
[s2,fs] = audioread(wavPath2); % s1, s2, and s3 are column vectors because sample wave files are monaural

% Mixing with SNR = 0 [dB]
SNR = 0;
[x,s1,s2,coef] = SNRmix(s1,s2,SNR); % mixture signal of size "1 x length"

% Apply short-time Fourier transform
fftSize = 2048;
shiftSize = fftSize/4;
window = 'hamming';
[S1,analyWin] = STFT(s1,fftSize,shiftSize,window);
[S2,analyWin] = STFT(s2,fftSize,shiftSize,window);
[X,analyWin] = STFT(x,fftSize,shiftSize,window);

% Show spectrograms
showSpect(S1,fs,shiftSize);
showSpect(S2,fs,shiftSize);
showSpect(X,fs,shiftSize);

% Apply inverse short-time Fourier transform
orgLength = size(s1,1);
y1 = ISTFT(S1,shiftSize,analyWin,orgLength);
y2 = ISTFT(S2,shiftSize,analyWin,orgLength);
z = ISTFT(X,shiftSize,analyWin,orgLength);

% Numerical error caused by calculations in STFT and ISTFT
err1 = sum((s1-y1).^2)
err2 = sum((s1-y1).^2)
err3 = sum((x-z).^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%