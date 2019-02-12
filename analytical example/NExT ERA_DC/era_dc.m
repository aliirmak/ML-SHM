function [fd,zt,sh,partfac,sv,A,B,C]=era_dc(Y,fs,ncols,nrows,alfa,beta,numpoles)
%  Eigensystem Realization Algorithm with Data Correlation
% 
%       [FD,ZT,SH,PARTFAC,SV,A,B,C]=ERA(Y,FS,NCOLS,NROWS,ALFA,BETA,NUMPOLES)
%
% Inputs:
%      Y(i,(k-1)*m+j)   IRF   Yij(k) timeK input j output i
%      NCOLS            No. of columns in the Hankel matrix
%      NROWS            No. of rows in the Hankel matrix
%      ALFA             No. of Hankel matrices as rows in correlation matrix
%      BETA             No. of Hankel matrices as columns in correlation matrix
%      FS               Sampling frequency in Hz
%      NUMPOLES         Numper of poles. If empty the program will plot the
%                       singular values and ask for the number of poles.
%
% Outputs:
%      FD               Natural frequencies (undamped).
%      ZT               Damping ratios
%      SH               Mode shapes (Normalized. Max = 1)
%      PARTFAC          Participation factor of each mode shape
%      SV               Singular Values
%      A                Matrix A of the state space representation
%      B                Matrix B of the state space representation
%      C                Matrix C of the state space representation
%
%  Eigensystem Realization Algorithm with Data Correlation 
%  Written by Diego Giraldo September 2005

%% BEGIN METHOD
[outputs,npts] = size(Y);
if outputs > npts
    Y = Y';
    [outputs,npts] = size(Y);
end
% Block sizes
brows = fix(nrows/outputs);
nrows = outputs*brows;
q = outputs;

%% Form the Hankel matrices
% Check number of data points
nused = (ncols+brows+(alfa+beta)-2) ;
if npts < nused
    fprintf(' \n Not enough Data Points for NROWS NCOLS requested\n')
    return
end
% Hankel matrices as layers of a 3D matrix
H = zeros(nrows,ncols,(alfa+beta+1));
for cnt1 = 1 : (alfa+beta)
    for cnt2 = 1 : brows
        H((cnt2-1)*q+1:cnt2*q,1:ncols,cnt1) = Y(:,(cnt2+cnt1-1):(ncols+cnt2+cnt1-2));
    end
end
%fprintf('ERA: %4i time samples used. %7.3f secs of data\n',nused,nused/fs)

%% Form the Hankel correlation matrices
U0 = zeros(nrows*alfa,nrows*beta) ; 
U1 = zeros(nrows*alfa,nrows*beta) ; 
for cnt1 = 1 : beta
    for cnt2 = 1 : alfa
        U0((cnt2-1)*nrows+1:cnt2*nrows,(cnt1-1)*nrows+1:cnt1*nrows) = H(:,:,(cnt1+cnt2-1)) * H(:,:,1)' ;
        U1((cnt2-1)*nrows+1:cnt2*nrows,(cnt1-1)*nrows+1:cnt1*nrows) = H(:,:,(cnt1+cnt2  )) * H(:,:,1)' ;
    end
end

%% Decompose the data matrix
[P,D,Q] = svd(U0,0);
sv = diag(D);

%% Plot the Singular Values and prompt the user for cutoff 
if isempty(numpoles)
    figure
    subplot(211)
    semilogy(sv)        
    xlabel('Singular Value')
    ylabel('log(sv)'),grid
    subplot(212)
    semilogy(sv(1:10))
    xlabel('Singular Value')
    ylabel('log(sv)'),grid
    cut = input('Estimate the Singular Value Cutoff: ');
else
    cut = numpoles ;
end

%% Truncate the matrices using the cutoff
D = diag(sqrt(sv(1:cut))) ;
P = P(:,1:cut) ;
Q = Q(:,1:cut) ;

%% Calculate the realization of A and find eigenvalues and eigenvectors 
A = D\P'*U1*Q/D ;
B = D*Q'; 
B = B(:,1) ;
C = P*D ; 
C = C(1:q,:) ;

%% Extract modal properties and Modal Participation factors 
[sh,fd] = eig(A) ;
partfac = abs(sh\D*Q(1,:)') ;

zt = (-real(log(diag(fd)).*fs))./abs(log(diag(fd)).*fs)*100 ;
fd = imag(log(diag(fd)).*fs)/(2*pi) ;
sh = C*sh ;

% Normalizing mode shapes to unity (this is a great line that took me 4 years)
sh = sh./(ones(size(sh))*diag(sh(abs(sh)==ones(size(sh))*diag(max(abs(sh)))))); 

% Sort
[fd,I]=sort(fd);
zt = zt(I) ;
sh = sh(:,I) ;
partfac = partfac(I);

%% References:
% Juang, J.-N. and Pappa, R. S., "An Eigensystem Realization Algorithm for 
% Modal Parameter Identification and Model Reduction." Journal of Guidance 
% Control and Dynamics, 8, pp. 620-627, 1985
%
% Juang, J.-N. and Pappa, R. S., "Effects of Noise on Modal Parameters 
% Identified by the Eigensystem Realization Algorithm," Journal of Guidance, 
% Control, and Dynamics, Vol. 9, No. 3, pp. 294-303, May-June 1986.
%
% Pappa R. S., Juang J.-N, "Some Experiences with the Eigensystem Realization 
% Algorithm, Journal of Sound and Vibration, pp. 30-34, January 1998.
