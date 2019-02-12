function [fd,sh,zt] = stateid(A,C,fs)
% STATEID is a function that uses the matrices A anc C of a system in state 
%         space notation to obtain its modal properties. Both discrete and
%         continuous systems are calculated. Provide the sampling frequency 
%         only for discrete systems, otherwise, provide only A and C. 
%
%	      [fd,sh,zt] = stateid(A,C,fs)
%
%     A    System matrix 
%     C    Output matrix
%     fs   Sampling frequency (only for discrete systems)
%
%	  fd   Damped natural frequencies 
%     sh   Mode shapes
%     zt   Damping ratios (percentage values)
%
% By Diego Giraldo
% created july, 2005

%% Calculating eigen values 
if nargin == 3  % Discrete systems
    [sh,fd] = eig(A) ; 
    zt = (-real(log(diag(fd)).*fs))./abs(log(diag(fd)).*fs)*100 ;
    fd = imag(log(diag(fd)).*fs)/(2*pi) ;
    sh = C*sh ;
else            % Continuous systems 
    [sh,fd]  = eig(A);
    zt = (-real(diag(fd)))./abs(diag(fd))*100 ;
    fd = imag(diag(fd))./(2*pi) ;
    sh = C*sh ;
end

%% Normalizing mode shapes to unity (this is a great line that took me 4 years)
% sh = sh./(ones(size(sh))*diag(sh(find(abs(sh)==ones(size(sh))*diag(max(abs(sh))))))); 
sh = sh./(ones(size(sh))*diag(max(sh))) ;

%% Sort
[fd,I]=sort(fd);
zt = zt(I) ;
sh = sh(:,I) ;

% %% Remove negative frequencies and rigid body modes
% delet = find(fd<=0) ;
% fd(delet)   = [] ; 
% zt(delet)   = [] ; 
% sh(:,delet) = [] ; 

%% Undamped frequencies are calculated with:
% sqrt(((fd(cnt))^2*(zt(cnt)/100)^2/(1-(zt(cnt)/100)^2))+(fd(cnt)^2))
