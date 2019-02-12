function [comacval] = comac(modes1,modes2)
% Calculates the coordinate modal assurance criterion (MAC) values of mode shapes. 
%
%       [comacval] = COMAC(modes1,modes2)
%
% modes1 and modes2 are matrices whose column vectors are mode shapes. 
% both matrices must have the same number of rows. 
% Matrices are not required to have the same number of modes.
% 
% Diego Giraldo  (dfg2@cive.wustl.edu)
% Washington University in Saint Louis
% Structural Control and Earthquake Engineering Laboratory

if nargin > 3
    error('Too many input arguments')
elseif nargin == 1
    modes2 = modes1 ; 
end

if size(modes1,1)~=size(modes2,1)
    error('The mode shapes do not have the same number of points')
end

if size(modes1,2)~=size(modes2,2)
    minimo = min(size(modes1,2),size(modes2,2)) ; 
    modes1 = modes1(:,1:minimo) ; 
    modes2 = modes2(:,1:minimo) ; 
end

comacval = (((sum((abs(modes1.*modes2))')).^2)./(sum((abs(modes1')).^2).*sum((abs(modes2')).^2)))' ; 