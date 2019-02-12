function [fd,sh,zt] = eliminate(fd,sh,zt,fs,ref,pf)
%   ELIMINATE deletes modes from a realization obtained using the 
%   combinations NEXT-ERA or RDD-ITD, based on four criteria: 
%             1. Frequency is negative, zero, or equal or greater than half 
%                the sampling frequency
%             2. Unexpectedly high damping ratio. Negative damping ratios
%                (unstable modes) are assumed to have zero damping 
%             3. Reference channel with low motion (applies only to cases
%                in which the random decrement or NEXT have been applied)
%             4. Repeated modes: When repeated, the mode with lower 
%                participation factor is deleted. If not participation 
%                factors are provided, then the one with the lowest damping 
%                ratio is left.  
%
%         [fd,sh,zt] = eliminate(fd,sh,zt,fs,ref,pf)
%
%     fd    Natural frequencies (column vector)                  - NEEDED
%     sh    Mode shapes (in column vectors)                      - NEEDED
%     zt    Damping ratios (column vector)                       - NEEDED
%
%     fs    Sampling frequency (scalar)                          - OPTIONAL
%     ref   Reference channel used to detect properties (scalar) - OPTIONAL
%     pf    Participation factors from ERA (column vector)       - OPTIONAL
% 
% By Diego Giraldo
% created july/2005

%% Checking entries
if ((length(fd)~=size(sh,2))||(length(fd)~=size(zt,1)))
    disp('The number of frequencies of the inputs do not coincide')
    return
end

if nargin < 6
    PF_flag = 0 ; 
    pf = zeros(size(fd)) ; 
else 
    PF_flag = 1 ; 
end

%% Criterion 1
% Eliminate negative frequencies and free body modes
if nargin > 3 
    delet = find( (fd<=0) | (fd>=fs/2) ) ; 
else
    delet = find( fd<=0 ) ; 
end
fd(delet)   = [] ;
sh(:,delet) = [] ;
zt(delet)   = [] ;
pf(delet)   = [] ; 

%% Criterion 2
% Eliminate modes with negative damping ratio or higher than 6%
delet = find( abs(zt)>6 ) ; 
fd(delet)   = [] ;
sh(:,delet) = [] ;
zt(delet)   = [] ;
pf(delet)   = [] ; 

zt(zt<0) = 0 ; 

%% Criterion 3
% Eliminate modes whose amplitude at the reference point is less than 0.1
% This elimination of modes is performed only for ambient vibration tests,
% were the NExT is applied. Hammer tests don't require a refference chan.
if nargin >= 5
    if ~isempty(ref)
        abshapes = abs(sh) ; 
        [~,delet] = find( abshapes(ref,:) < 0.1 ) ; 
        fd(delet)   = [] ;
        sh(:,delet) = [] ;
        zt(delet)   = [] ;
        pf(delet)   = [] ; 
    end
end

%% Criterion 4
% Eliminating Repeated modes 
macval = tril(mac(sh)) ; 
macval = macval - diag(diag(macval)) ;
if PF_flag == 0    % (if participation factors are not provided)
    cnt1 = 1 ; 
    while cnt1 <= size(sh,2)
        a = [ cnt1  [find(macval(:,cnt1)>0.8)]' ]  ;
        % Only frequencies within 30% are considered for elimination
        if length(a) > 1
            a = a((fd(a)/fd(cnt1))<1.3) ;
            [~,tmp2] = min(zt(a)) ;
            a(tmp2) = [] ;
            fd(a)       = [] ; 
            sh(:,a)     = [] ; 
            zt(a)       = [] ; 
            macval(:,a) = [] ; 
            macval(a,:) = [] ; 
            if sum(a==cnt1)==1
                cnt1 = cnt1 - 1 ;
            end
        end
        cnt1 = cnt1 + 1 ;     
    end
else
    cnt1 = 1 ; 
    while cnt1 <= size(sh,2)
        a = [ cnt1  [find(macval(:,cnt1)>0.8)]' ]  ;
        % Only frequencies within 30% are considered for elimination
        if length(a) > 1
            a = a((fd(a)/fd(cnt1))<1.3) ;
            [~,tmp2] = max(pf(a)) ;
            a(tmp2) = [] ;
            fd(a)       = [] ; 
            sh(:,a)     = [] ; 
            zt(a)       = [] ; 
            pf(a)       = [] ;
            macval(:,a) = [] ; 
            macval(a,:) = [] ; 
        end
        cnt1 = cnt1 + 1 ;     
    end
end