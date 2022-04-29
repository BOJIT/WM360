tap = 15;
fc = 6100;
fs = 15000;

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

hzDen = [1 zeros(1,(length(hzNum)-1))];

[dB,w] = freqz(hzNum,[1],512);

Phi = 180*unwrap(angle(dB))/pi;
dB = mag2db(abs(dB));

figure;
subplot(2,1,1)
plot(w/pi*fs/2,dB)
ax = gca;
ax.YLim = [-30 0]
hold on
xline(6100)
hold on
yline(-3)

xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')


subplot(2,1,2)
plot(w/pi*fs/2,Phi)

xlabel('Frequency [Hz]')
ylabel('Phase [degrees]')

figure;
stem(conv(hzNum,[1 0 0 0 0 0]))