% FILE:         main.m
% DESCRIPTION:  Main entrypoint to simulatiom/test scripts.
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

close all; clc; clear;

%----------------------------------- Config -----------------------------------%

DecimationFactor = 3;
SampleRate = 48000;
% Scheme = 'linear';
Scheme = 'a-law';

FIRCutoff = 6100;
FIRTaps = 25;

IIRCutoff = 6000;
IIRTaps = 3;
IIRType = 'Butterworth';

%-------------------------------- Entry Point ---------------------------------%

% Set up simulation
sim = Simulation(DecimationFactor, SampleRate, Scheme);
sim.setFIR(FIRCutoff, FIRTaps);
sim.setIIR(IIRCutoff, IIRTaps, IIRType);

% Any arbitrary signal can be input

% audio_in = sim.testSignal([130, 1200, 2700, 5100, 6300], 96000);
% audio_in = sim.testSignal([2000, 9000], 2000);
audio_in = sim.testSignal([1000], 2000);

% audio_in = sim.capture(2);  % Record audio from microphone at sim sample rate

% Simulink Audio Pipeline
pcm = sim.encode(audio_in);
audio_out = sim.decode(pcm);

sim.playback(audio_out);    % Play back reconstructed audio signal

%------------------------------------ Plots -----------------------------------%

fig = Figure([1, 2]);
fig.SuperTitle = sprintf("Audio Pipeline Analysis\n Sample Rate = %u Hz, Decimation Factor = %u, Scheme = %s", ...
                            sim.SampleRate, sim.DecimationFactor, sim.Scheme);

%------- Time domain -------%

% Remove phase offset/time delay for analysis
[audio_in_aligned, audio_out_aligned] = align_signals(audio_in, audio_out);
audio_time = 0:(1/sim.SampleRate):(1/sim.SampleRate)*(length(audio_in_aligned) - 1);

quantization_error = audio_in_aligned - audio_out_aligned;

fig.ActiveAxes = 1;
in_trace = fig.plot(audio_time, audio_in_aligned);
in_trace.DisplayName = "Audio Input";
out_trace = fig.plot(audio_time, audio_out_aligned);
out_trace.DisplayName = "Audio Output";

fig.Title = "Time Domain";
fig.XLabel = "Time /s";
fig.YLabel = "Magnitude / V";
legend(fig.Axes(fig.ActiveAxes), 'location', 'northeast');

%----- Frequency domain -----%

[in_freq, in_mag] = norm_fft(audio_in_aligned, sim.SampleRate, true, true);
[out_freq, out_mag] = norm_fft(audio_out_aligned, sim.SampleRate, true, true);
[q_freq, q_mag] = norm_fft(quantization_error, sim.SampleRate, true, true);

fig.ActiveAxes = 2;
in_trace = fig.plot(in_freq, in_mag);
in_trace.DisplayName = "Audio Input";
out_trace = fig.plot(out_freq, out_mag);
out_trace.DisplayName = "Audio Output";
q_trace = fig.plot(q_freq, q_mag);
q_trace.DisplayName = "Error Delta";
fig.Title = "Frequency Domain";
fig.XLabel = "Frequency / Hz";
fig.YLabel = "Normalised Magnitude";
legend(fig.Axes(fig.ActiveAxes), 'location', 'northeast');

%------------------------------ Helper Functions ------------------------------%

function [f, s, theta] = norm_fft(x, fs, half, norm)
    %NORM_FFT Simple fft abstraction that returns normalised
    %frequency-amplitude data.

    if nargin < 3
        half = false;
    end

    if nargin < 4
        norm = false;
    end

    % Get data length and step size.
    % t is assumed to be in seconds
    t = 0:(1/fs):(1/fs)*(length(x) - 1);
    % and have a constant sampling rate.
    samples = length(t);
    Fs = samples/(t(end) - t(1));   % sampling frequency
    df = Fs/samples;    % width of a frequency 'bin'

    transform = fftshift(fft(x))/samples;

    % Generate frequency from 'bin' width.
    % This works with both odd and even numbers of samples.
    f = fftshift(0:df:df*(samples - 1));
    f(1:floor(samples/2)) = f(1:floor(samples/2)) - Fs;

    % Give complex fourier series in polar form.
    % This makes it easy to plot, but can also be reconstructed.
    s = abs(transform);
    theta = angle(transform);

    % Bin off negative frequency range
    if half
        s = s(f > 0);
        theta = theta(f > 0);
        f = f(f > 0);
    end

    if norm
        s = s/max(s);
    end
end

function [xa, ya] = align_signals(x, y)
    %ALIGN_SIGNALS aligns signals by cross-correlation and trims them to equal length

    [xa, ya] = alignsignals(x, y);

    % Lengths may deviate slightly due to alignment and partial decimation.
    max_len = min(length(xa), length(ya));
    xa = xa(1:max_len);
    ya = ya(1:max_len);
end

%------------------------------------------------------------------------------%
