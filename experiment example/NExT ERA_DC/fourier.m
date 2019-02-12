function [spectrum,freq] = fourier(data,time)
% Takes DATA into the frequency domain and back into time domain. 
% 
%        [amp,freq] = fourier(data,time)
% 
% Diego Giraldo

if size(data,1) < size(data,2) 
    data = data' ; 
end

if size(time,1) == 1 
    time = time' ; 
end

if size(time,1) ~= size(data,1)
    disp('The vectors have different lengths.')
    return
end

if floor(size(data,1)/2) == size(data,1)/2
    data = data(1:end-1,:) ;
    time = time(1:end-1) ;
end

Tmax = time(end);
dt   = time(2)-time(1) ;

% PERFORM FFT 
F    = fft(data)*dt ;
Ws   = 1/dt ;
freq = 0 : Ws/(Tmax*Ws) : Ws ;
freq = freq(1:length(F))' ; 

% Cut the frequency domain and the spectrum in half and plot results
% This is performed so no mirror image is displayed
freqhalf = freq(1:floor(length(freq)/2)+1);
Fhalf    = F(1:length(freqhalf),:);

% Reconstruct mirrored image based on already cut spectrum
ending = conj(flipud(Fhalf)) ; 
mirror = [ Fhalf ; ending(1:end-1,:) ] ; 
% mirror = mirror(1:length(data)) ; 


% reconstruct the time vector
dt   = (freqhalf(2)-freqhalf(1))*(size(freqhalf,1)-1) / (2*(freqhalf(end))^2) ;

% Calculate inverse of fourier
f = ifft(mirror)/dt ;
f = f(1:length(data),:) ; 

freq = freqhalf ; 
spectrum = Fhalf ;

figure
subplot(211)
plot(freqhalf,dcb(abs(Fhalf)))
legend('ABS value')
subplot(212)
plot(time,data,'b',time,real(f),'r:')
legend('Original','Reconstructed')
xlabel('time');ylabel('y(t)')
