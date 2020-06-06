function estFo = foCepstrum(signal,fs,foMin,foMax,fftSize,window)
%
% Estimation of Fo (fundamental frequency) based on cepstrum analysis
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
%
% [syntax]
%   estFo = foCepstrum(signal,fs,foMin,foMax)
%   estFo = foCepstrum(signal,fs,foMin,foMax,fftSize)
%   estFo = foCepstrum(signal,fs,foMin,foMax,fftSize,window)
%
% [inputs]
%       signal: input signal (sigLen x 1)
%           fs: sampling frequency [Hz]
%        foMin: minimum frequency for analysis (default: 0 [Hz])
%        foMax: maximum frequency for analysis (default: fs/2 [Hz])
%      fftSize: length of short-time signal for calculating cepstrum (scaler)
%       window: arbitrary analysis window function (fftSize x 1) or choose function from below:
%               'hamming'    : Hamming window (default)
%               'hann'       : von Hann window
%               'rectangular': rectangular window
%               'blackman'   : Blackman window
%               'sine'       : sine window
%
% [outputs]
%        estFo: estimated fo (scaler [Hz])
%

[sigLen,nCh] = size(signal);
cepMax = round(fs/foMin); % Maximum order of cepstrum for analysis
cepMin = round(fs/foMax); % Minimum order of cepstrum for analysis

% Check errors and set default values
if (nargin < 4)
    error('Too few input arguments.\n');
end
if nCh > sigLen
    signal = signal';
end
if nCh ~= 1
    error('estFoCepstrum only supports single-channel signal');
end
if (nargin < 5)
    fftSize = 2^(nextpow2(round(sigLen/2))); % default analysis length
end
if fftSize < cepMax
    error('fftSize (analysis length) is too short or foMin is too low.\n');
end
if (nargin < 6)
    window = hamming_local(fftSize); % default analysis window
else
    if isnumeric(window)
        if size(window, 1) ~= fftSize
            error('The length of analysis window must be the same as that of fftSize.\n');
        end
    else
        switch window
            case 'hamming'
                window = hamming_local(fftSize);
            case 'hann'
                window = hann_local(fftSize);
            case 'rectangular'
                window = rectangular_local(fftSize);
            case 'blackman'
                window = blackman_local(fftSize);
            case 'sine'
                window = sine_local(fftSize);
            otherwise
                error('Input window type is not supported. Check options.\n')
        end
    end
end

% Find a short-time signal whose power is maximum
powMax = 0; indStart = 1;
for ind = 1:fftSize:sigLen-fftSize
    pow = sum(signal(ind:ind+fftSize-1).^2); % signal power of short-time signal
    if pow > powMax
        powMax = pow;
        indStart = ind;
    end
end
analySignal = signal(indStart:indStart+fftSize-1); % short-time signal

% Calculate cepstrum of short-time signal
windowedAnalySignal = analySignal.*window; % windowing
spectrum = fft(windowedAnalySignal); % FFT
logAbsSpectrum = log(max(abs(spectrum),eps)); % absolute, eps flooring, and log
cepstrum = real(ifft(logAbsSpectrum)); % inverse FFT

% Find maximum cepstrum and get its order (quefrency)
[~, indCep] = max(cepstrum(cepMin:cepMax));
maxQuef = indCep + cepMin - 2;

% Convert quefrency to frequency
estFo = fs/maxQuef;

end

%% Local functions
function analyWindow = hamming_local(fftSize)
t = linspace(0,1,fftSize+1).'; % periodic (produce L+1 window and return L window)
analyWindow = 0.54*ones(fftSize,1) - 0.46*cos(2.0*pi*t(1:fftSize));
end

function analyWindow = hann_local(fftSize)
t = linspace(0,1,fftSize+1).'; % periodic (produce L+1 window and return L window)
analyWindow = max(0.5*ones(fftSize,1) - 0.5*cos(2.0*pi*t(1:fftSize)),eps);
end

function analyWindow = rectangular_local(fftSize)
analyWindow = ones(fftSize,1);
end

function analyWindow = blackman_local(fftSize)
t = linspace(0,1,fftSize+1).'; % periodic (produce L+1 window and return L window)
analyWindow = max(0.42*ones(fftSize,1) - 0.5*cos(2.0*pi*t(1:fftSize)) + 0.08*cos(4.0*pi*t(1:fftSize)),eps);
end

function analyWindow = sine_local(fftSize)
t = linspace(0,1,fftSize+1).'; % periodic (produce L+1 window and return L window)
analyWindow = max(sin(pi*t(1:fftSize)),eps);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%