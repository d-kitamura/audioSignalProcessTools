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
addpath('./input'); 

% parameters
fileName = 'a.wav'; % audio file name
fftSize = 4096; % FFT length (short-time length) for analysis 
foMin = 80; % minimum frequency [Hz] for analysis
foMax = 400; % maximum frequency [Hz] for analysis

% Read wav fale
[signal,fs] = audioread(fileName); % fs is a sampling frequency [Hz]

% Fo estimation
estFo = foCepstrum(signal,fs,foMin,foMax,fftSize,'rectangular');

fprintf('Estimated Fo is %.5f [Hz].\n', estFo);
