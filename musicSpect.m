function [musicSpect,freqAxis] = musicSpect(signal,order,fs,windowSize,fftSize,shiftSize)
%
% Estimation of MUSIC spectrum based on sub-space method
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
%
% [syntax]
%   [musicSpect,freqAxis] = musicSpect(signal,order,fs,windowSize)
%   [musicSpect,freqAxis] = musicSpect(signal,order,fs,windowSize,fftSize)
%   [musicSpect,freqAxis] = musicSpect(signal,order,fs,windowSize,fftSize,shiftSize)
%
% [inputs]
%       signal: input signal (sigLen x 1)
%        order: number of (real-valued) sinusoidal waves in signal (scaler)
%           fs: sampling frequency [Hz]
%   windowSize: length of short-time signal frame (scaler)
%      fftSize: length of Fourier transform for calculating MUSIC spectrum (scaler)
%    shiftSize: shift length of frames (default: 1)
%
% [outputs]
%   musicSpect: pseudo spectrum (MUSIC spectrum) of input signal (frequency bins (windowSize) x 1)
%     freqAxis: frequency axis vector (windowSize x 1)
%

% Check errors and set default values
if (nargin < 4)
    error('Too few input arguments.\n');
end
if (size(signal,2) > 1)
    error ('Input argument signal" must be a column vector.\n');
end
if ~isreal(signal)
    error ('Input argument "signal" must be a real-valued vector.\n');
end
if (nargin < 5)
    fftSize = windowSize; % default
end
if (nargin < 6)
    shiftSize = 1; % default
end

sigLen = size(signal,1);

% short-time framing (break signal into short-time signal pieces)
sigZeroPad = [signal;zeros(windowSize-1,1)]; % zero padding
nFrames = ceil(sigLen/shiftSize); % number of frames
shortTimeSig = zeros(windowSize, nFrames); % memory allocation
for frame = 1:nFrames
    startPoint = (frame-1)*shiftSize+1;
    endPoint = startPoint+windowSize-1;
    shortTimeSig(:,frame) = sigZeroPad(startPoint:endPoint);
end

% MUSIC spectrum calculation
covMat = (shortTimeSig*shortTimeSig')/nFrames; % sample covariance matrix
[eigVec,eigVal] = eig(covMat); % eigenvalue decomposition (covMat = eigVec * eigVal * eigVec')
[~, ind] = sort(diag(eigVal), 'descend'); % sort eigenvalues in descending order and get sorted index
sortEigVec = eigVec(:,ind); % sort eigenvectors (column vectors of eigVec) in descending order
noiseEigVec = sortEigVec(:,2*order+1:end); % noise eigenvectors
fftNoiseEigVec = abs(fft(noiseEigVec,fftSize)).^2; % power spectrum of noise eigenvectors (the denominator of MUSIC spectrum is a sum of inner product of noise eigenvector and Fourier basis, which is equal to DFT)
musicSpect = 1./sum(fftNoiseEigVec,2); % pseudo spectrum (MUSIC spectrum)
freqAxis = 0:fs/windowSize:fs-1/windowSize; % frequency axis

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%