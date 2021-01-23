function estFo = foYin(sig,threshold,sampFreq,foMin,foMax)
%
% Estimation of Fo (fundamental frequency) based on YIN
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
% M. Mauch and S. Dixon, "PYIN: A fundamental frequency estimator using probabilistic threshold distributions," Proc. ICASSP, pp. 659-663, 2014.
% A. Cheveigne and H. Kawahara, "YIN, a fundamental frequency estimator for speech and music," The Journal of the Acoustical Society of America, vol. 111, no. 4, pp. 1917–1930, 2002.
%
% [syntax]
%   estFo = foYin(sig,threshold,fs)
%   estFo = foYin(sig,threshold,fs,foMin)
%   estFo = foYin(sig,threshold,fs,foMin,foMax)
%
% [inputs]
%          sig: input signal (sigLen x 1)
%     sampFreq: sampling frequency [Hz]
%        foMin: minimum frequency for analysis (default: 0 [Hz])
%        foMax: maximum frequency for analysis (default: fs/2 [Hz])
%
% [outputs]
%        estFo: estimated fo (scaler [Hz])
%

% Check arguments and set default values
arguments
    sig (:,1) double
    threshold (1,1) double
    sampFreq (1,1) double
    foMin (1,1) double = 0;
    foMax (1,1) double = sampFreq/2;
end

% Check errors
if threshold < 0; error('Threshold value in YIN must be nonnegative.\n'); end
if sampFreq <= 0; error('Sampling frequency must be positive.\n'); end
if foMin < 0; error('Minimum frequency must be nonnegative.\n'); end
if foMax <= 0; error('Maximum frequency must be positive.\n'); end

% Initialization
sigLen = size(sig, 1); % signal length
sampTime = 1/sampFreq; % sampling time
lagRange = floor(sigLen/2); % range of lag (denoted W in the papers, a half of signal length)
laggedSig = zeros(lagRange, lagRange); % matrix for lagged signals
indMin = round(1/foMax/sampTime); % index that corresponds to foMax (minimum of estimated lag)
indMax = round(1/foMin/sampTime); % index that corresponds to foMin (maximum of estimated lag)
if indMax > lagRange; indMax = lagRange; end % replace indMax to lagRange when indMax exceeds maximum index

% Calculate cumulative-mean-normalized squared difference between original and lagged signals
for lag = 1:lagRange
    laggedSig(:,lag) = sig(1+lag:lagRange+lag,1); % lagged signals (rows: signal, columns: lag)
end
diff = sum((sig(1:lagRange,1) - laggedSig).^2, 1).'; % squared difference between original and lagged signals (with each lag length)
cumMeanDiff = cumsum(diff)./(1:1:lagRange).'; % cumulative mean
normDiff = diff./cumMeanDiff; % cumulative-mean normalization

% Estimation of fundamental frequency Fo
validInd = find(normDiff(indMin:indMax,1) <= threshold); % get indexes of elements that satisfy normDiff<=threshold in the range [indMin, indMax]
if isempty(validInd) % if there is no index that satisfies normDiff<=threshold in the range [indMin, indMax]
    [~, minInd] = min(normDiff(indMin:indMax,1)); % get index whose normDiff is the minumum
    estTo = (minInd(1)+indMin-1) * sampTime; % estimated fundamental period To, where indMin-1 is added because minInd(1) is an index for normDiff(indMin:indMax,1) (limited range)
else % if there exist indexes that satisfy normDiff<=threshold in the range [indMin, indMax]
    estTo = (validInd(1)+indMin-1) * sampTime; % estimated fundamental period To, where indMin-1 is added because minInd(1) is an index for normDiff(indMin:indMax,1) (limited range)
end
estFo = 1/estTo; % estimated fundamental frequency Fo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%