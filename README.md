# Tools for audio signal processing

## About
Sample MATLAB script of audio signal processing tools including short-time Fourier transform (STFT) and its inversion.

## Contents
- input [dir]:              includes test audio signals (dry source signals)
- example_foCepstrum.m:     example script that estimates fo (fundamental frequency) based on cepstrum analysis
- example_foYin.m:          example script that estimates fo (fundamental frequency) based on YIN
- example_musicSpect.m:     example script that calculates MUSIC spectrum
- example_STFTandISTFT.m:   example script that applies SNRmix, STFT, and inverse STFT
- foCepstrum.m:             estimate fo (fundamental frequency) based on cepstrum analysis
- foYin.m:                  estimate fo (fundamental frequency) based on YIN
- ISTFT.m:                  inverse short-time Fourier transform
- musicSpect.m:             calculation of MUSIC spectrum
- PCA.m:                    principal component analysis
- showSpect.m:              show spectrogram
- SNRmix.m:                 mix two signals with a desired signal-to-noise ratio
- STFT.m:                   short-time Fourier transform

## Usage Note
STFT returns only 0Hz to Nyquist frequency components to avoid redundant calculation.

In inverse STFT, optimal synthesis window is calculated and applied. This optimal synthesis window is based on a minimal distortion principle described below:
* D. Griffin and J. Lim, "Signal estimation from modified short-time Fourier transform," IEEE Transactions on Acoustics, Speech, and Signal Processing, vol. 32, no. 2, pp. 236-243, 1984.

## See Also
* HP: http://d-kitamura.net