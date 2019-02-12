function sorted = fdsort(organized,unorganized)
% This function calculates the order in which the unorganized modes should 
% be sorted so that they correspond to the organized ones. If a mode is
% not present in unorganized, then a zero is introduced. Moreover, modes 
% with no correspondance are left in ascendent order at the end. 
% Unlike MSORT, this function organizes frequencies, shapes and damping 
% ratios. 
% 
%          organized = msort(organized,unorganized)
% 
%     organized.fd ; 
%     organized.sh ; 
%     organized.zt ; 
%
%     unorganized.fd
%     unorganized.sh
%     unorganized.zt
% 
% Diego Giraldo
% Washington University
% Civil Engineering Department
% Structural Control and Earthquake Eagineering Lab 
% Written in Sep-2005

FD = organized.fd ; 
SH = organized.sh ; 
ZT = organized.zt ; 

% Find order
mcv = mac(unorganized.sh,SH) ; 
orden = zeros(1, size(SH,2));
for cnt1 = 1 : size(SH,2)
    [tmp1,~] = find(mcv(:,cnt1)>0.9) ; 
    if length(tmp1)>1
        [tmp1,~] = find(mcv(:,cnt1)==max(mcv(:,cnt1))) ; 
    end
    if isempty(tmp1)
        orden(cnt1) = 0 ; 
    else
        orden(cnt1) = tmp1 ; 
    end
end

sorted.fd = zeros(size(FD)) ; 
sorted.zt = zeros(size(ZT)) ; 
sorted.sh = zeros(size(SH)) ; 

for cnt1 = find(orden)
    sorted.fd(cnt1)   = unorganized.fd(orden(cnt1))   ; 
    sorted.zt(cnt1)   = unorganized.zt(orden(cnt1))   ; 
    sorted.sh(:,cnt1) = unorganized.sh(:,orden(cnt1)) ; 
end

unorganized.fd(orden(orden~=0))   = [] ;
unorganized.zt(orden(orden~=0))   = [] ;
unorganized.sh(:,orden(orden~=0)) = [] ;

sorted.fd = [sorted.fd ; unorganized.fd] ;    
sorted.zt = [sorted.zt ; unorganized.zt] ;    
sorted.sh = [sorted.sh   unorganized.sh] ;    
