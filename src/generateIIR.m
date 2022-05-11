% FILE:         generateIIR.m
% DESCRIPTION:  Function to generate IIR reconstruction filter for PCM reader
% AUTHOR:       Matt Chapman
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

function  [numd, denomd] = generateIIR(fc, fs, filtType, filtOrder)

    wd = 2*pi*fc; 
    T=1/fs;

    wa = (2/T)*tan((wd*T)/2);
    
    %% Low-Pass Prototypes - Butterworth
    hpnum(1,:) = [0 1*wa 0 0 0];
    hpnum(2,:) = [0 0 1*wa^2 0 0];
    hpnum(3,:) = [0 0 0 1*wa^3 0];
    hpnum(4,:) = [0 0 0 0 1*wa^4];

    hpden(1,:) = [1 1*wa 0 0 0];
    hpden(2,:) = [1 1.4142*wa 1*wa^2 0 0];
    hpden(3,:) = [1 2*wa 2*wa^2 1*wa^3 0];
    hpden(4,:) = [1 2.6131*wa 3.4142*wa^2  2.6131*wa^3 1*wa^4];
    
    %% Low-Pass Prototype - Chebyshev
    
    hcnum(1,:) = [0 1.9652*wa 0 0 0];
    hcnum(2,:) = [0 0 0.9826*wa^2 0 0];
    hcnum(3,:) = [0 0 0 0.4913*wa^3 0];
    hcnum(4,:) = [0 0 0 0 0.2456*wa^4];

    hcden(1,:) = [1 1.9652*wa 0 0 0];
    hcden(2,:) = [1 1.0977*wa 1.1025*wa^2 0 0];
    hcden(3,:) = [1 0.9883*wa 1.2384*wa^2 0.4913*wa^3 0];
    hcden(4,:) = [1 0.9528*wa 1.4539*wa^2  0.7426*wa^3 0.2756*wa^4];
    
    %% Select Filter
    %Select the correct filter based on its inputs
    if filtType == 0
        filtNum = hpnum(filtOrder, 1:filtOrder+1);
        filtDen = hpden(filtOrder, 1:filtOrder+1);
    elseif filtType == 1
        filtNum = hcnum(filtOrder, 1:filtOrder+1);
        filtDen = hcden(filtOrder, 1:filtOrder+1); 
    else
        disp('Butterworth filt type = 0')
        disp('Chebyshev filt type = 1')
    end 
    
    
    %% Z domain

    [numd, denomd] = bilinear(filtNum, filtDen , fs);
    [hz, w] = freqz(numd, denomd, 1024);
    phi = 180*unwrap(angle(hz))/pi;
    db = mag2db(abs(hz))/2;
    w = w.*fs/(2*pi);
    figure()
    subplot(2,1,1)
    plot(w,db)
    hold on
    xline(fc)
    yline(-3)
    ylabel('Magnitude (db)')
    xlabel('Frequency (Hz)')
    grid on
    subplot(2,1,2)
    plot(w, phi)
    ylabel('Phase')
    grid on

    %% Pole - Zero plot

    figure()
    pzmap(tf(numd, denomd));

    %% Impulse Response

    figure()
    N1 = 100;
    y1 = impz(numd,denomd, N1);
    n2 = 0:N1-1;
    stem(n2,y1)
    title('Impulse Response of IIR Filter')
    xlabel('Sample Number')
    ylabel('Amplitude')

    
    
end