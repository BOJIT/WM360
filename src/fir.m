% FILE:         fir.m
% DESCRIPTION:  FIR Filter Testing
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 28/04/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%-------------------------------- Entry Point ---------------------------------%

sampleRate = 1000; % Hz

% b = fir1(80,0.5,kaiser(81,8));
% freqz(b,1);

fir_filt = [ ...
    -0.061072119396879, ...
    -0.068614601583902, ...
    -0.079336759046606, ...
    -0.092251949094246, ...
    -0.103197321704239, ...
     0.192484291541263, ...
    -0.103197321704239, ...
    -0.092251949094246, ...
    -0.079336759046606, ...
    -0.068614601583902, ...
    -0.061072119396879, ...
];

dsp = DSP(sampleRate);

signal = dsp.signal([0, 5, 3, 7, 4]);
% window = hann(24)';

kernel = sinc(-2*pi:pi/8:2*pi);

f = Figure();
f.stem(kernel);

avLen = 5;
filter = ones(1, avLen)./avLen;

dsp.convolutionPlot(dsp.impulse(50), kernel);

%------------------------------ Helper Functions ------------------------------%
