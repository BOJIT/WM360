% FILE:         Simulation.m
% DESCRIPTION:  Simulation class for interacting with PCM_System.slx
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 07/05/2022

%------------------------------------------------------------------------------%

classdef Simulation < handle

    %---------------------------- Public Properties ---------------------------%
    properties
        DecimationFactor = 3;
        SampleRate = 48000;
        Scheme = 'linear';

        FirNumeratorCoefficients = [1, 1];
        FirDenominatorCoefficients = [1, 1];

        IirNumeratorCoefficients = [1, 1];
        IirDenominatorCoefficients = [1, 1];
    end

    properties (Dependent)

    end

    %---------------------------- Private Properties --------------------------%
    properties (Access = private)
        EncoderPath = 'PCM_Encoder';
        DecoderPath = 'PCM_Decoder';

        EncoderSim;
        DecoderSim;

        NativeBitDepth = 16;    % Default sample depth of PC audio hardware

        % List of object properties that get written to Simulink workspace
        Params = [ ...
            "DecimationFactor", ...
            "SampleRate", ...
            "FirNumeratorCoefficients", ...
            "FirDenominatorCoefficients", ...
            "IirNumeratorCoefficients", ...
            "IirNumeratorCoefficients", ...
            "IsLinear", ...
            "IsALaw", ...
        ];
    end

    properties (Access = private, Dependent)
        IsLinear;
        IsALaw;
    end

    %------------------------------- Constructor ------------------------------%
    methods
        function obj = Simulation(decimation_factor, sample_rate, scheme)
            obj.EncoderSim = Simulink.SimulationInput(obj.EncoderPath);
            obj.DecoderSim = Simulink.SimulationInput(obj.DecoderPath);

            if nargin >= 1
                obj.DecimationFactor = decimation_factor;
            end

            if nargin >= 2
                obj.SampleRate = sample_rate;
            end

            if nargin >= 3
                obj.Scheme = scheme;
            end

            obj.setConfig();
        end
    end

    %------------------------------ Public Methods ----------------------------%
    methods
        function stream = capture(obj, duration)
            if nargin < 2
                duration = 5;
            end

            r = audiorecorder(obj.SampleRate, obj.NativeBitDepth, 1);
            fprintf("Recording %u seconds of audio in: ", duration);

            t = 5;
            while t > 0
                fprintf("%u", t);
                pause(1);
                fprintf("\b");
                t = t - 1;
            end
            fprintf("0\n");

            obj.showProgress(duration);
            recordblocking(r, duration);

            fprintf("Audio Recording Complete\n");
            stream = getaudiodata(r);
        end

        function playback(obj, stream)
            duration = length(stream)/obj.SampleRate;
            p = audioplayer(stream, obj.SampleRate, obj.NativeBitDepth);

            fprintf("Playing back %u seconds of audio:\n", duration);
            obj.showProgress(duration);
            playblocking(p);
            fprintf("Audio Playback Complete\n");
        end

        function data = encode(obj, stream)
            obj.EncoderSim.setExternalInput(stream);
            data = sim(obj.EncoderSim);
        end

        function stream = decode(obj, data)
            obj.EncoderSim.setExternalInput(stream);
            stream = sim(obj.DecoderSim);
        end

        function setFIR(obj, coeff)

        end

        function setIIR(obj, coeff)

        end
    end

    %------------------------------ Private Methods ---------------------------%
    methods
        function setConfig(obj)
            for p = obj.Params
                obj.EncoderSim.setVariable(p, obj.(p), 'Workspace', obj.EncoderSim.ModelName);
                obj.DecoderSim.setVariable(p, obj.(p), 'Workspace', obj.DecoderSim.ModelName);
            end
        end

        function showProgress(~, duration)
            inc = 0;
            t = timer;
            t.TimerFcn = @t_inc;
            t.StopFcn = @t_stop;
            t.TasksToExecute = 20;
            t.ExecutionMode = 'fixedRate';
            t.Period = duration/20;

            fprintf("---------------------------------\n");
            fprintf("0%%");
            start(t);

            function t_inc(~, ~)
                inc = inc + 5;
                if mod(inc, 20) == 0
                    fprintf("%u%%", inc);
                else
                    fprintf("-");
                end
            end

            function t_stop(~, ~)
                fprintf("\n");
                fprintf("---------------------------------\n");
                delete(t);
            end
        end
    end

    %------------------------------ Get/Set Methods ---------------------------%
    methods
        function set.DecimationFactor(obj, val)
            obj.DecimationFactor = val;
            obj.setConfig();
        end

        function set.SampleRate(obj, val)
            obj.SampleRate = val;
            obj.setConfig();
        end

        function set.Scheme(obj, val)
            obj.Scheme = val;
            obj.setConfig();
        end

        function val = get.IsLinear(obj)
            val = (obj.Scheme == "linear");
        end

        function val = get.IsALaw(obj)
            val = (obj.Scheme == "a-law");
        end
    end

end
