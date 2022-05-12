% FILE:         generateFIR.m
% DESCRIPTION:  Generate coefficients for an FIR filter
% AUTHOR:       Josh Routley
% DATE CREATED: 12/05/2022

%------------------------------------------------------------------------------%

function [hzNum,hzDen] = generateFIR(tap,fc,fs)

hzNum = zeros(1,tap);
wn = hzNum;

omegaC = 2*pi*fc/fs;
m = (tap-1)/2;
for n = -m:m
%     wn(n+m+1) = 1;
%     wn(n+m+1) = 1-abs(n)/m;
    wn(n+m+1) = 0.54+0.46*cos(n*pi/m);
%     wn(n+m+1) = 0.42 + 0.5*cos(n*pi/m) + 0.08*cos(2*n*pi/m)
    if n == 0
        hzNum(n+m+1) = omegaC/pi;
    else
        hzNum(n+m+1) = sin(omegaC*n)/(n*pi);
    end
end
hzNum;
hzNum = hzNum.*wn;
hzDen = [1 zeros(1,(length(hzNum)-1))];

[dB,w] = freqz(hzNum,[1],512);

Phi = 180*unwrap(angle(dB))/pi;
dB = mag2db(abs(dB));

figure;
subplot(2,1,1)
plot(w/pi*fs/2,dB)
% ax = gca;
% ax.XLim = [0 10000]
hold on
xline(6100)
hold on
yline(-3)

xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
title('Frequency and Phase response of 15 tap lowpass FIR filter')


subplot(2,1,2)
plot(w/pi*fs/2,Phi)

xlabel('Frequency [Hz]')
ylabel('Phase [degrees]')


figure;
y = conv(hzNum,[1 0 0 0 0 0]);
stem(0:(tap-1),y(1:tap))
xlabel('n')
ylabel('Amplitude')
title('Impulse response of 15 tap lowpass FIR filter')
% ax = gca;
% ax.XLim = [0 tap+1]
end
