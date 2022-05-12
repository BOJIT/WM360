% FILE:         main.m
% DESCRIPTION:  Main entrypoint to simulatiom/test scripts.
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%----------------------------------- Config -----------------------------------%

FIRCutoff = 6100;
FIRTaps = 25;

IIRCutoff = 6000;
IIRTaps = 3;
IIRType = 'Butterworth';

%-------------------------------- Entry Point ---------------------------------%

% Configure simulation
sim = Simulation();
sim.setFIR(FIRCutoff, FIRTaps);
sim.setIIR(IIRCutoff, IIRTaps, IIRType);
sim.Scheme = 'a-law';

% Any arbitrary signal can be input
% audio_in = sim.testSignal([130, 1200, 2700, 5100, 6300], 96000);
% audio_in = sim.testSignal([2000, 9000], 2000);

audio_in = sim.capture(2);  % Record audio from microphone at sim sample rate

% Simulink Audio Pipeline
pcm = sim.encode(audio_in);
audio_out = sim.decode(pcm);

sim.playback(audio_out);    % Play back reconstructed audio signal


% Plot summary
fig = Figure([1, 2]);
fig.SuperTitle = "Audio Pipeline Analysis";

% Time domain
fig.ActiveAxes = 1;
in_trace = fig.plot(audio_in);
in_trace.DisplayName = "Audio Input";
out_trace = fig.plot(audio_out);
out_trace.DisplayName = "Audio Output";
fig.Title = "Time Domain";
legend(fig.Axes(fig.ActiveAxes), 'location', 'northeast');

% Frequency domain
in_freq = abs(fft(audio_in));
out_freq = abs(fft(audio_out));

fig.ActiveAxes = 2;
in_trace = fig.plot(in_freq(1:floor(length(in_freq)/2)));
in_trace.DisplayName = "Audio Input";
out_trace = fig.plot(out_freq(1:floor(length(out_freq)/2)));
out_trace.DisplayName = "Audio Output";
fig.Title = "Frequency Domain";
legend(fig.Axes(fig.ActiveAxes), 'location', 'northeast');
