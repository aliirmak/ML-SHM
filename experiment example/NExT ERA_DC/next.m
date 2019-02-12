function [fdata,ftime] = next(data,fsample,rchan,varargin)
% NExT program will calculate the free response data from ambient data. 
% The method assumes that the excitation is a white noise (uncorrelated). 
% Multiple-output is acceptable. 
%
%         [FDATA,FTIME] = NEXT(DATA,FSAMPLE,RCHAN,[NFFT],[PLOT])
%
%     DATA    Time histories of responses in column vectors
%     TIME    Corresponding time vector
%     RCHAN   Reference channel
%     NFFT    Number of points of the fourier transform
%     PLOT    0 for no plots ... 1 for plots
% 
%     FDATA   Free response data
%     FTIME   Free response time
%
% Written by S.J. Dyke       2/19/2000
% Modified by Juan Caicedo   5/26/2002
% Modified by Diego Giraldo 10/10/2005

%% Constants
ploton = 0;
numpts = 1024;    % Default number of points for the spectral density function
switch nargin
case 4
    numpts = varargin{1};
case 5
    numpts = varargin{1};
    ploton = varargin{2};
end
[~,nresp] = size(data);

%% Calculate Free response data 
[csddata,freq] = respcsd(data,fsample,rchan,numpts);
fdata = zeros(numpts,nresp);
for ii=1:nresp
    [httmp,time] = csd2free(csddata(:,ii),freq);
    fdata(:,ii) = httmp;
    clear httmp
end
ftime = time(1:end/2);
fdata = fdata(1:end/2,:);
% fprintf('NExT:%4i Windows averaged.  %7.3f secs of data\n',fix(nsteps/numpts*4),ftime(end)) ;

%% Plotting results 
if ploton == 1
    figure
    subplot(2,1,1);
    plot(freq,dcb(csddata));
    xlabel ('Freq (Hz)') ;
    ylabel ('Amplitude (dB)');
    subplot(2,1,2);
    plot(ftime,fdata) ;
    xlabel ('Time (Sec)') ;
    ylabel ('Amplitude');
end
