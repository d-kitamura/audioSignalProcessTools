%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample program for calculating MUSIC spectrum                           %
%                                                                         %
% Coded by D. Kitamura (d-kitamura@ieee.org)                              %
%                                                                         %
% See also:                                                               %
% http://d-kitamura.net                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc;

% Fix random seed
seed = 2; % seed
RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed)); % set pseudo random stream (mt19937ar)

% Parameters
fs = 100; % sampling frequency [Hz]
n = (0:1/fs:10)'; % discrete time index
f1 = 15; % frequency 1 [Hz]
f2 = 35; % frequency 2 [Hz]
sigma = 5; % amplitude of white noise
order = 2; % number of (real-valued) sinusoidal waves
windowSize = 512; % length of short-time signal (frame)
fftSize = 512; % FFT length for calculating MUSIC spectrum
shiftSize = 1; % shift length for short-time signals (frames)

% Produce noisy signal
sig = cos(2*pi*f1*n) + sin(2*pi*f2*n) + sigma*randn(size(n));

% Plot signal
figure; plot(n,sig);
xlabel('Time'); ylabel('Amplitude');
title('Noisy signal'); grid on;

% Plot amplitude spectrum of signal
figure; plot(20*log10(abs(fft(sig))));
xlabel('Frequency [Hz]'); ylabel('Power [dB]');
title('Fourier power spectrum'); grid on;

% Calculation of MUSIC spectrum based on sub-space method
[P,f] = musicSpect(sig,order,fs,windowSize,fftSize,shiftSize);
figure; plot(f,20*log10(P));
xlim([0,fs/2]);
xlabel('Frequency [Hz]'); ylabel('Power [dB]');
title('Pseudospectrum Estimate via MUSIC'); grid on;

% MUSIC spectrum using MATLAB built-in function (see: https://jp.mathworks.com/help/signal/ref/pmusic.html)
% short-time signals are produced with shiftSize=1 and apply SVD
dim = 2*order; % 2 times of number of sinusoidal waves when signal is real-valued
fftSize = windowSize; % FFT size for calculating MUSIC spectrum
[P,f] = pmusic(sig,dim,fftSize,fs,windowSize);
figure; plot(f,20*log10(abs(P)));
xlabel('Frequency [Hz]'); ylabel('Power [dB]');
title('Pseudospectrum Estimate via MUSIC (MATLAB built-in)'); grid on;
