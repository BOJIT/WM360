% FILE:         generateFIR.m
% DESCRIPTION:  Function to generate FIR Anti-Aliasing filter for PCM Encoder
% AUTHOR:       Josh Routley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

tap = 25;
fc = 6100;
fs = 48000;

hzNum = zeros(1,tap);

omegaC = 2*pi*fc/fs;
m = (tap-1)/2;
for n = -m:m
    if n == 0
        hzNum(n+m+1) = omegaC/pi;
    else
        hzNum(n+m+1) = sin(omegaC*n)/(n*pi);
    end
end
disp(hzNum)
hzDen = [1 zeros(1,(length(hzNum)-1))];

[dB,w] = freqz(hzNum,[1],512);

Phi = 180*unwrap(angle(dB))/pi;
dB = mag2db(abs(dB));

figure;
subplot(2,1,1)
plot(w/pi*fs/2,dB)
% ax = gca;
% ax.YLim = [-20 2]
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
y = conv(hzNum,[1 0 0 0 0 0])
stem(0:(tap-1),y(1:tap))
xlabel('n')
ylabel('Amplitude')
title('Impulse response of 15 tap lowpass FIR filter')
% ax = gca;
% ax.XLim = [0 tap+1]
