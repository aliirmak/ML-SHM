function [ht,time] = csd2free(CSDmat,freqv)
% [HT,TIME] = CSD2FREE(CSDMAT,FREQV) 
% 
% This matlab function will perform an inverse Fourier trnasform
% on the Cross-Spectral Density (CSD) function to obtain the
% time domain response. 
%
% INPUTS: 
%    CSDMAT   = measured cross spectral density (nw x ny)
%    FREQV    = frequency vector (nw x 1)
%
% OUTPUTS: 
%    HT      = impulse response function matrix [nt x ny]
%    TIME    = corresponding time vector [nt x 1]
%
%  written by S.J. Dyke:  1/4/00
%  last modified:         2/19/00
%  Modified by Juan Caicedo:  Jume 13/2002


% SET UP 
df    = freqv(2)-freqv(1); 
npts  = length(freqv);
N     = 2*npts;
T     = 1/df;
Time  = (0:N)/N*T;
dt    = Time(2)-Time(1);
wvec  = 2*pi*freqv;

% CALCULATE IFFT 
X_G1    = CSDmat(:,:);
X_G1c   = conj(X_G1(2:end-1,:));
X_G1tot = [X_G1;flipud(X_G1c)]/dt;
yg1     = ifft(X_G1tot);
dt      = 1/2/(max(wvec)/2/pi);
time    = (1:length(yg1))*dt - dt;

% FORM impulse response function matrix 
ht      = real(yg1);


