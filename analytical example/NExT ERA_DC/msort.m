function orden = msort(SH,sh)
% This function calculates the order in which the modes-shapes "sh" should 
% be organized so that they correspond to those of SH.
% Unlike FDSORT, this function only organizes the mode shapes. 
% 
%          orden = msort(SH,sh)
% 
%   SH   Experimental mode shapes in a matrix composed of column vectors
%   sh   Analytical mode shapes in a matrix composed of column vectors
% 
% Diego Giraldo
% Washington University
% Civil Engineering Department
% Structural Control and Earthquake Eagineering Lab 
% Written in Feb-2005

mcv = mac(sh,SH) ; 
orden = zeros(1, size(SH,2));
for cnt1 = 1 : size(SH,2)
    [tmp1,~] = find(mcv(:,cnt1)>0.8) ; 
    if length(tmp1)>1
        [tmp1,~] = find(mcv(:,cnt1)==max(mcv(:,cnt1))) ; 
    end
    if isempty(tmp1)
        orden(cnt1) = 0 ; 
    else
        orden(cnt1) = tmp1 ; 
    end
end
tmp = 1:size(sh,2) ;
tmp(orden) = [] ;
orden = [orden tmp] ; 

% [n2,n1] = sort(mac(sh,SH),'descend') ; 
% for cnt1 = 1 : size(SH,2) ; 
%     cnt2 = 1 ; 
%     while (abs(n1(cnt2,cnt1)-cnt1))>3
%         cnt2 = cnt2 + 1 ; 
%     end
%     if n2(cnt2,cnt1)>0.5
%         orden(cnt1) = n1(cnt2,cnt1) ;
%     else
%         disp('No correspondance')
%         break
%     end
% end
% tmp = [1:size(sh,2)] ;
% tmp(orden) = [] ;
% orden = [orden tmp] ; 
