function [nsh] = complexmodesh(csh)

% this program normalize complex modeshapes to real modeshapes
% csh is m by n complex shape matrix
% where m is number of nodes
% and n is number of modes

% DETERMINE EIGENVECTORS AND EIGENVALUES 
m = size(csh,1);
n = size(csh,2);

v1 = csh;
v1r = zeros(m,n);
v1n = zeros(m,n);

for ii = 1:n           % rotate and renormalize vectors (norm=1)
   v1(:,ii)  = v1(:,ii)/norm(v1(:,ii));  % normalize s.t. norm = 1
   v1r(:,ii) = v1(:,ii)/v1(1,ii); 
   v1r(:,ii) = v1r(:,ii)/norm(v1r(:,ii)); % rotate then norm 
   v1sign    = sign(real(v1r(:,ii)));    % sign of each component of the rotated version 
   v1n(:,ii) = (v1sign).*abs(v1r(:,ii))/max(abs(v1r(:,ii))); 
   
   [~,ind] = max(abs(v1n(:,ii)));
   if v1n(ind,ii) == -1
       v1n(:,ii) = -1*v1n(:,ii);
   end
   
end

% general check here for consistency
if v1n(20,1) < 0
    v1n(:,1) = -1*v1n(:,1);
end
if v1n(10,2) > 0
    v1n(:,2) = -1*v1n(:,2);
end
if v1n(20,3) < 0
    v1n(:,3) = -1*v1n(:,3);
end
if v1n(15,4) < 0
    v1n(:,4) = -1*v1n(:,4);
end
if v1n(20,5) < 0
    v1n(:,5) = -1*v1n(:,5);
end
if v1n(23,6) < 0
    v1n(:,6) = -1*v1n(:,6);
end
    
nsh = v1n;