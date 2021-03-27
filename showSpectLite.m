function [graph,faxis,taxis] = showSpectLite(spectrogram,fs,shiftSize)
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
%   [graph,faxis,taxis] = showSpectLite(spectrogram)
%   [graph,faxis,taxis] = showSpectLite(spectrogram,fs,shiftSize)
%
% [inputs]
%   spectrogram: STFT matrix ([freqs x frames] for a monaural spectrogram, 
%                and [freqs x frames x channels] for a multichannel 
%                spectrogram, where number of frequency bins is fs/2+1, and
%                both complex-valued and nonnegative spectrograms are supported.)
%            fs: sampling frequency [Hz]
%     shiftSize: length of window shift
%
% [outputs]
%         graph: graphics handle
%         faxis: frequency axis (1 x nbin)
%         taxis: time axis (1 x nframe)

% Check errors and set default values
[nfreqs, nframes, nch] = size(spectrogram);
if ~isreal(spectrogram) % for complex spectrogram
    spectrogram = real(abs(spectrogram).^2); % calculate power spectrogram
end
if (nargin < 2)
    faxis = 1:nfreqs;
    taxis = 1:nframes;
elseif (nargin < 3)
    error('Too few input arguments.\nIf you input fs, shiftSise is also required.\n');
else
    faxis = 0:fs/(2*nfreqs):fs/2 - (fs/(2*nfreqs));
    taxis = 0:shiftSize/fs:(shiftSize/fs)*(nframes-1);
end

% Draw spectrogram surface
logSpectrogram = 10*log10( spectrogram );
minVal = min( min( min( logSpectrogram ) ) );
maxVal = max( max( max( logSpectrogram ) ) );
for ch = 1:nch
    graph(ch) = figure;
    imagesc( taxis, faxis, 10*log10(spectrogram(:,:,ch)) );
    axis tight;
    box on;
    caxis( [(minVal - maxVal)/6, maxVal] ); % moderately define color map range
    set( gca,'YDir','normal' ); % 縦軸を上下反転
    set( gca, 'FontName', 'Times', 'FontSize', 16 );
    if nch ~= 1
        title( sprintf('%dch spectrogram',ch), 'FontName', 'Arial', 'FontSize', 16 );
    end
    if (nargin < 2)
        xlabel( 'Time frame', 'FontName', 'Arial', 'FontSize', 16 );
        ylabel( 'Frequency bin', 'FontName', 'Arial', 'FontSize', 16 );
    else
        xlabel( 'Time [s]', 'FontName', 'Arial', 'FontSize', 16 );
        ylabel( 'Frequency [Hz]', 'FontName', 'Arial', 'FontSize', 16 );
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%