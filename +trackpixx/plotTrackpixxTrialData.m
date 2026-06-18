function plotTrackpixxTrialData(T, titleStr)

    if nargin < 2
        titleStr = "";
    end
    if isstruct(T)
        T = T.TPxData;
    end

    T = T(6:end,:);
    xpts = T.TimeTag - T.TimeTag(1);
    fh = figure();
    fh.Position(4) = fh.Position(4)*0.75;
    fh.Position(3:4) = fh.Position(3:4)*0.9;
    subplot(1,2,1); hold on;
    plot(xpts, T.LeftPupilDiameter, 'Color', 'r', 'LineWidth', 1.25, 'DisplayName', 'Left');
    plot(xpts, T.RightPupilDiameter, 'Color', 'b', 'LineWidth', 1.25, 'DisplayName', 'Right');
    ylim([0 100]);
    ylabel('Pupil Diameter (mm)');
    legend('Location', 'southeast');
    title(titleStr);
    xlabel('Time ("sec")');

    ax = subplot(1,2,2); hold on;
    if any(~isnan(T.LeftEyeRawX))
        plot(T.LeftEyeRawX, T.LeftEyeRawY, 'Color', 'r');
    end

    if any(~isnan(T.RightEyeRawX))
        plot(T.RightEyeRawX, T.RightEyeRawY, 'Color', 'b');
    end
    
    axis equal square;
    grid on;

    limits = [min([xlim; ylim], [], "all") max([xlim;ylim], [], "all")];

    axis([limits limits])

