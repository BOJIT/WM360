% FILE:         fir.m
% DESCRIPTION:  FIR Filter Testing
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 28/04/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%-------------------------------- Entry Point ---------------------------------%

sampleRate = 1000; % Hz

dsp = DSP(sampleRate);

signal = dsp.signal([0, 5, 3, 7, 4]);
window = dsp.signal(hann(24)');


dsp.convolutionPlot(window);

%------------------------------ Helper Functions ------------------------------%
