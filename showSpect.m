function [figHdl,freqAx,timeAx] = showSpect(specgram,sampFreq,shiftSize)
%
% Show spectrogram from time-frequency matrix 
% This function supports both complex and nonnegative input and both
% monaural and multichannel spectrograms.
% For a multichannel spectrogram, the order of its indexes must be
% [nfreqs x nframes x nch].
% Note that color map range is moderately defined. Tune by yourself.
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
%
% [syntax]
%   [figHdl,freqAx,timeAx] = showSpect3d(specgram)
%   [figHdl,freqAx,timeAx] = showSpect3d(specgram,sampFreq,shiftSize)
%
% [inputs]
%   specgram: STFT matrix ([nFreqs x nTime] for a monaural spectrogram, 
%             and [nFreqs x nTime x channels] for a multichannel 
%             spectrogram, where number of frequency bins is sampFreq/2+1, 
%             and both complex-valued and nonnegative spectrograms are supported.)
%   sampFreq: sampling frequency [Hz]
%  shiftSize: length of window shift
%
% [outputs]
%     figHdl: figure handle
%     freqAx: frequency axis (1 x nbin)
%     timeAx: time axis (1 x nframe)

% Check errors and set default values
[nFreq, nTime, nCh] = size(specgram);
if ~isreal(specgram) % for complex spectrogram
    specgram = real(abs(specgram).^2); % calculate power spectrogram
end
if (nargin < 2)
    freqAx = 1:nFreq;
    timeAx = 1:nTime;
elseif (nargin < 3)
    error('Too few input arguments.\nIf you input sampFreq, shiftSise is also required.\n');
else
    freqAx = linspace(0, sampFreq/2, nFreq);
    timeAx = linspace(0, shiftSize/sampFreq*nTime, nTime);
end

% Draw spectrogram surface
logSpecgram = 10*log10(specgram);
minVal = min(min(min(logSpecgram)));
maxVal = max(max(max(logSpecgram)));
for iCh = 1:nCh
    figHdl(iCh) = figure;
    imagesc(timeAx, freqAx, 10*log10(specgram(:,:,iCh)));
    axis tight; box on;
    caxis([(minVal - maxVal)/6, maxVal]); % moderately define color map range
    set(gca, 'YDir', 'normal'); % inverte virtical axis
    set(gca, 'FontName', 'Times', 'FontSize', 16);
    if nCh ~= 1
        title( sprintf('%dch spectrogram',iCh), 'FontName', 'Arial', 'FontSize', 16 );
    end
    if (nargin < 2)
        xlabel('Time frame', 'FontName', 'Arial', 'FontSize', 16);
        ylabel('Frequency bin', 'FontName', 'Arial', 'FontSize', 16);
    else
        xlabel('Time [s]', 'FontName', 'Arial', 'FontSize', 16);
        ylabel('Frequency [Hz]', 'FontName', 'Arial', 'FontSize', 16);
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%