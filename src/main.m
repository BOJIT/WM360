% FILE:         main.m
% DESCRIPTION:  Main entrypoint to simulatiom/test scripts.
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%-------------------------------- Entry Point ---------------------------------%

sim = Simulation();

a = sim.capture(3);

% Any arbitrary signal can be input
% t = 0:1/48000:(1e-3 - eps);
% a = sin(2*pi*2000*t);

b = sim.encode(a);
c = sim.decode(b);

sim.playback(c);

%------------------------------ Helper Functions ------------------------------%

