function [fd,sh,zt,rf] = stabilize(FD,SH,ZT,ploton)
% STABILIZE defines the modal properties of a system based on a 
%    stabilization diagram. Use this program when you have many modal 
%    properties that are the same but need to be averaged to find more 
%    accurate values. Averaging of similar frequencies, damping ratios and 
%    mode shapes is performed. STABILIZE uses the MAC parameter to identify
%    equivalent modes.  It also outputs the number of times that a
%    vibrational mode has been identified. 
% 
%        [fd,sh,zt,rf] = stabilize(FD,SH,ZT,ploton)
% 
%     FD      Natural frequencies detected from modal-ID programs
%     SH      Mode shapes
%     ZT      Damping ratios
%     ploton  Ploting options: 0 or 1 (this is optional) 
% 
%     fd      Averaged frequencies
%     sh      Averaged mode shapes
%     zt      Averaged damping ratios
%     rf      Number of times detected
%
% By Diego Giraldo
% created August/2005
% Modified October/2005 

%% Check Entries 
% Chick size of data entries
if ( (size(FD,1)~=size(SH,2)) || (size(FD,1)~=size(ZT,1)) )
    disp('The number of modal properties is not correct')
    return
end

% Removing negative and zero frequencies
a = find( FD<=0 ) ; 
FD(a) = [] ; SH(:,a) = [] ; ZT(a) = [] ; 

% If unassigned, no diagram displayed
if nargin == 3 
    ploton = 0 ; 
end

%% Plotting stabilization diagram
if ploton == 1
    % Numbering entry samples 
    cnt2 = 1 ; 
    old = 0 ; 
    ref = zeros(1, size(FD,1));
    for cnt1 = 1 : size(FD,1)
        if FD(cnt1) < old 
            cnt2 = cnt2+1 ; 
        end
        ref(cnt1,1) = cnt2 ; 
        old = FD(cnt1) ; 
    end
    % Exit if frequencies are sorted out
    if max(ref) == 1
        disp('Diagram is unnecesary as frequencies are sorted...') ;
        ploton = 0 ;
    else
        % Plotting all data samples
        figure(1) ; clf ;
        set(figure(1),'Position',[20 20 400 300]);
        hold on ;
        plot(FD,ref,'.') ; 
        axis([ 0  max(FD)+1  0  max(ref)+1 ]) ; 
        xlabel('Frequency (Hz)')
        ylabel('Sample data')
    end
else
    ref = ones(size(FD)) ;
end

%% Defining Similar Vibrational Modes

% Mode shapes (MAC grater than 0.9)
macval = mac(SH) ; 
tmp1 = zeros(length(FD)) ;
tmp1(macval>0.9) = 1 ;

% Frequencies (values within 1%)
freqcy = abs(((FD*ones(size(FD))')-(FD*ones(size(FD))')')./(FD*ones(size(FD))')') ; 
tmp2 = zeros(length(FD)) ;
tmp2(freqcy<0.01) = 1 ;

% Combined
tmp = zeros(length(FD)) ;
tmp((tmp1+tmp2)==2) = 1 ;

%% Defining modal properties through averaging
cnt1 = 1 ; 
rf = zeros(size(FD)); fd = zeros(size(FD)); zt = zeros(size(ZT)); sh = zeros(size(SH));
while ~isempty(FD)
    [~,d] = sort(sum(tmp)','descend') ;
    a = find(tmp(:,d(1))==1) ;
    rf(cnt1,1) = length(a) ; 
    
    % Multiplying by -1 when the shapes are backwards
    if length(a) > 1
        oposed = find( sum(abs(SH(:,a))) > sum(abs(real(SH(:,a)+SH(:,a(1))*ones(size(a'))))) ) ; 
        SH(:,a(oposed)) = -SH(:,a(oposed)) ;
    end

    if ploton == 1
        plot(FD(a),ref(a),':')
        plot(mean(FD(a))*ones(size(FD(a))),ref(a),':r')
    end

    % Obtaining averages of frequencies, mode-shapes and damping ratios
    fd(cnt1,1) = sum( FD(a) / length(a) ) ;
    zt(cnt1,1) = sum( ZT(a) / length(a) ) ;
    sh(:,cnt1) = sum((SH(:,a)),2)./ length(a) ;
    
    % Deleting averaged frequencies, mode-shapes and damping ratios
    FD(a) = [] ; SH(:,a) = [] ; ZT(a) = [] ; ref(a) = [] ; tmp(:,a) = [] ; tmp(a,:) = [] ; 
    cnt1 = cnt1 + 1 ; 
end

%% Organizing entries 
[fd,orden]  = sort(fd) ; 
sh = sh(:,orden) ; zt = zt(orden) ; rf = rf(orden) ;
