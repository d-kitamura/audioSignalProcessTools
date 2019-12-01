function [mix,outSignal,outNoise,coef] = SNRmix(inSignal,inNoise,SNR)
%
% Mixing two signals with a desired signal-to-noise ratio (SNR)
% This function supports multichannel signals.
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
%
% [syntax]
%   [mix,outSignal,outNoise,coef] = SNRmix(inSignal,inNoise)
%   [mix,outSignal,outNoise,coef] = SNRmix(inSignal,inNoise,SNR)
%
% [inputs]
%    inSignal: input signal (length x ch)
%     inNoise: input noise (length x ch)
%         SNR: desired SNR [dB] (default = 0)
%
% [outputs]
%         mix: mixed signal with desired SNR (length x ch)
%   outSignal: signal in the mixture signal (length x ch)
%    outNoize: noise in the mixture signal (length x ch)
%        coef: mixing coefficient (scalar)

% Check errors and set default values
[length, nch ] = size( inSignal );
if size(inNoise,1) ~= length || size(inNoise,2) ~= nch
    error('The size of two input signals are not the same.\n')
end
if (nargin<2)
    error('Too few input arguments.\n');
end
if (nargin<3)
    SNR = 0;
end

if length < nch
    [mix,outSignal,outNoise,coef] = SNRmix(inSignal.',inNoise.',SNR);
else
    squareSums = zeros(2,1);
    for m = 1 : nch
        squareSums(1,1) = squareSums(1,1) + ( inSignal(:,m)' * inSignal(:,m) );
        squareSums(2,1) = squareSums(2,1) + ( inNoise(:,m)' * inNoise(:,m) );
    end
    inSNR = 10*log10( ( squareSums(1,:) ) ./ ( squareSums(2,:) ) );
    coef = ( 10 ^ ( ( inSNR - SNR )  / 20 ) );
    outSignal = inSignal;
    outNoise = inNoise .* coef;
    mix = outSignal + outNoise;
    normCoef = max(max(abs(mix)));
    if  normCoef >= 1
        mix = mix ./ normCoef;
        outNoise = outNoise ./ normCoef;
        outSignal = outSignal ./ normCoef;
        fprintf('The signals are normalized in SNRmix.\n');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%