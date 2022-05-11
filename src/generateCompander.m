% FILE:         aLaw.m
% DESCRIPTION:  Generate A-Law lookup table for full-range signal
% AUTHOR:       James Bennion-Pedley
% DATE CREATED: 11/05/2022

%------------------------------------------------------------------------------%

function lut = generateCompander(Range, A, Resolution)

    if nargin < 1
        Range = 2.5;    % Assuming symmetric input bounds
    end

    if nargin < 2
        A = 87.6;       % See G.711 ITU standard
    end

    if nargin < 3
        Resolution = 8; % 'Bit' resolution of lookup table
    end

    sweep = linspace(-Range, Range, 2^Resolution);

    compress = compand(sweep, A, max(sweep), 'A/compressor');
    expand = compand(sweep, A, max(sweep), 'A/expander');

    % Show Compander response
    fig = Figure();

    fig.Title = sprintf("Compander Lookup Table: \nResolution = $2^%u$, Range = %s%.2f, Coefficient = %.2f", ...
                                                                                Resolution, "$\pm$", Range, A);
    fig.XLabel = "Input Level / V";
    fig.YLabel = "Output Level / V";

    linear_ramp = fig.plot(sweep, sweep);
    linear_ramp.DisplayName = "Linear Ramp";

    compression_curve = fig.plot(sweep, compress);
    compression_curve.DisplayName = "Compression Curve";

    compression_curve = fig.plot(sweep, expand);
    compression_curve.DisplayName = "Expansion Curve";

    legend(fig.Axes(1), 'location', 'eastoutside');
    xlim(fig.Axes(1), [-Range, Range]);
    ylim(fig.Axes(1), [-Range, Range]);

    lut = table(sweep, compress, expand, 'VariableNames', { ...
                                                'Input', 'Compress', 'Expand'});

end

%------------------------------------------------------------------------------%
