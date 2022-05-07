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
    end

    properties (Dependent)

    end

    %---------------------------- Private Properties --------------------------%
    properties (Access = private)
        EncoderPath = 'Simulink/PCM_Encoder.slx';
        DecoderPath = 'Simulink/PCM_Decoder.slx';

        EncoderSim;
        DecoderSim;

        % List of object properties that get written to Simulink workspace
        Params = [ ...
            "DecimationFactor", ...
            "SampleRate", ...
            "Scheme", ...
        ];
    end

    properties (Access = private, Dependent)

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

    end

    %------------------------------ Private Methods ---------------------------%
    methods
        function setConfig(obj)
            for p = obj.Params
                obj.EncoderSim.setVariable(p, obj.(p), 'Workspace', obj.EncoderSim.ModelName);
                obj.DecoderSim.setVariable(p, obj.(p), 'Workspace', obj.DecoderSim.ModelName);
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
    end

end
