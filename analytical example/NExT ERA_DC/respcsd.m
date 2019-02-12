function [csddata,freq] = respcsd(data,Fs,rchan,npts,varargin)
%
% [CSDDATA] = RESPCSD(DATA,FS,RCHAN,NPTS,NOVERLAP);
%
% This program will calculate the averaged
% CSD's for a set of response data in DATA.
% The sampling frequency of the data is FS. 
% The reference channel is given by RCHAN. 
% The columns of DATA are assumed to be the
% responses. NPTS are used in the CSD calculation
% with 50% overlap. A HANNING window is also used.
% NOVERLAP is the number of points for overlaping
% If not defined 75% is used.
% 
%
% by S.J. Dyke
% Written:  2/19/00
% Modified: 2/19/00
% Modified by Juan Caicedo 6/12/2002

nrec = length(data(1,:));
noverlap = npts*0.75;
for counter = 5:nargin
    switch counter
    case 5
        noverlap = varargin{counter-4};
    end
end
csddata = zeros(npts/2+1, nrec);
for ii = 1:nrec
   % csd(x,y,nfft,Fs,window,noverlap)
   [csddata(:,ii),freq] = csd(data(:,rchan),data(:,ii),npts,Fs,boxcar(npts),noverlap);
   % cpsd(x,y,window,noverlap,f,fs)
   % [csddata(:,ii),freq] = cpsd(data(:,ii),data(:,rchan),boxcar(npts),noverlap,npts,Fs);
end