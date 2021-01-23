%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample program for estimating Fo (fundamental frequency) based on       %
% cepstrum analysis                                                       %
%                                                                         %
% Coded by D. Kitamura (d-kitamura@ieee.org)                              %
%                                                                         %
% See also:                                                               %
% http://d-kitamura.net                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc;

% Parameter setting
samplingFreq = 1000; % sampling frequency [Hz]
samplingTime = 1/samplingFreq; % sampling time [s]
sigTime = 0.5; % signal length [s]
timeAxis = 0:samplingTime:sigTime; % time axis
fo = 15; % signal frequency [Hz]
omega = 2*pi*fo; % angular frequency [rad/s]
sigma = 0.8; % amplitude of noise signal
threshold = 0.1; % threshold value in YIN (b/w 0 and 1)
foMin = 10; % minimum frequency for Fo estimation [Hz]
foMax = 20; % maximum frequency for Fo estimation [Hz]

% Produce signals
sig = sin(omega*timeAxis).'; % sine wave signal
noisySig = sig + sigma*randn(size(timeAxis)).'; % observed noisy signal

% Plot signals
plot(timeAxis, noisySig); hold on; plot(timeAxis, sig, 'LineWidth', 2); % plotting signals
xlabel('Time [s]'); ylabel('Amplitude'); % add axis labels
legend('Observed noisy signal', 'True signal', 'Location', 'northeast'); % add legends

% Fundamental frequency estimation based on YIN
estFo = foYin(noisySig,threshold,samplingFreq, foMin, foMax);
fprintf('True Fo: %.2f Hz\nEstimated Fo: %.2f Hz\nError rate: %.2f %%\n', fo, estFo, 100*abs(fo-estFo)/fo);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%