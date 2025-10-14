function plotEyePosition(TPxData, opts)

    arguments
        TPxData
        opts.Axes   % existing axis to plot to
        opts.PlotType (1,1) {mustBeMember(opts.PlotType, ["XvsY", "T"])}
        opts.WhichEye (1,1) {mustBeMember(opts.WhichEye, ["Left", "Right", "Both"])}
    end

    if isempty(opts.Axes)
        opts.Axes = axes('Parent', figure());
    end

    switch opts.PlotType
        case "XvsY"
            plot(TPxData.LeftEyeX(:), TPxData.LeftEyeY(:), 'b');
            hold on;
            plot(TPxData.RightEyeX(:), TPxData.RightEyeY(:), 'r');
            xlabel('X (pixels)'); ylabel('Y (pixels)');
        case "T"
            plot(ax)
    end
