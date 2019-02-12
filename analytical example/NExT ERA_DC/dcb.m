function [y]=dcb(x)
% Convert to decibels
%
% See INVDCB
%
% Juan Caicedo - April 1999
y = 20*log10(abs(x));
