% FILE:         main.m
% DESCRIPTION:  Main entrypoint to simulatiom/test scripts.
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%-------------------------------- Entry Point ---------------------------------%

sim = Simulation();

t = sim.capture();

d = sim.encode(t);

pause(2);

sim.playback(t);

%------------------------------ Helper Functions ------------------------------%

