function [macval] = mac(modes1,modes2)
% Calculates the modal assurance criterion (MAC) values of mode shapes. 
%
%       [macval] = MAC(modes1,modes2)
%
% modes1 and modes2 are matrices whose column vectors are mode shapes. 
% Both matrices must have the same number of rows. 
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

macval = real(((modes1.'*conj(modes2)).*conj(modes1.'*conj(modes2)))./((diag(modes1.'*conj(modes1)))*(diag(modes2.'*conj(modes2)))')) ;     


% % the upper part is 
% ( shapes(:,1).' * conj(shapes(:,2)) ) * conj( shapes(:,1).' * conj(shapes(:,2)) )
% % in matrix form
% ( (sh1.'*conj(sh2)).*conj(sh1.'*conj(sh2)) )
% 
% % the bottom part is 
% ( shapes(:,1).'*conj(shapes(:,1)) ) * ( shapes(:,2).'*conj(shapes(:,2)) )
% % in matrix form
% diag( sh1.'*conj(sh1) )*diag( sh2.'*conj(sh2) )'
% 
% % the whole equation
% ( ( shapes(:,1).' * conj(shapes(:,2)) ) * conj( shapes(:,1).' * conj(shapes(:,2)) ) ) / ( ( shapes(:,1).'*conj(shapes(:,1)) ) * ( shapes(:,2)'*shapes(:,2) ) )
% % in matrix form (the REAL function is to eliminate the very small imaginary component remaining after numerical procedure)
% macval = real(  ((shapes.'*conj(shapes)).*conj(shapes.'*conj(shapes)))./((diag(shapes.'*conj(shapes)))*(diag(shapes.'*conj(shapes)))')  ) ; 
