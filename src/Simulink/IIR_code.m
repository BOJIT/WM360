close all
clc

%% Parameters

fc = 6100; % Cut-off frequency
fs = 48000; % Sampling Frequency
wd = 2*pi*fc; 
T=1/fs;

wa = (2/T)*tan((wd*T)/2);

syms s p
s = p/wa;

%% Low-Pass Prototypes
hp1 = 1/(s+1);
hp2 = 1/(s^3 + 2*s^2 + 2*s + 1); 
hp3 = 1/(s^3 + 2*s^2 + 2*s + 1);


[n,d] = numden(hp3);
n_coeff = sym2poly(n);
d_coeff = sym2poly(d);

%% Z domain

[numd, denomd] = bilinear(n_coeff, d_coeff, fs);


%% Run Simulink

model = 'PCM_System';
load_system(model);
cs = getActiveConfigSet(mdl);
mdl_cs = cs.copy;

set_param(mdl_cs, 'StopTime', 0.01, 'MaxStep', 1e-5);
simulation = sim(model, mdl_cs);


