% FILE:         main.m
% DESCRIPTION:  Main entrypoint to simulatiom/test scripts.
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%-------------------------------- Entry Point ---------------------------------%

sim = Simulation();

% a = sim.capture(2);

% Any arbitrary signal can be input
a = sim.testSignal([130, 1200, 2700, 5100, 6300], 100);

fig = Figure([2, 2]);

fig.ActiveAxes = 1;
fig.plot(a);
fig.Title = "Raw Audio";

b = sim.encode(a);

fig.ActiveAxes = 2;
fig.plot(b);
fig.Title = "PCM Stream";

c = sim.decode(b);

fig.ActiveAxes = 3;
fig.plot(c);
fig.Title = "Reconstructed Signal";

% sim.playback(c);

%------------------------------ Helper Functions ------------------------------%

