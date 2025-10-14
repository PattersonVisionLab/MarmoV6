classdef eyetrack_trackpixx < handle


    properties (SetAccess = private, GetAccess = public)
        % I put the default properties in Trackpixx demos, we will want to adjust
        ledIntensity        (1,1)   double
        expectedIrisSize    (1,1)   double
    end

    % dependent properties, calculated on the fly...
    properties (SetAccess = public, GetAccess = public)
        EyeDump             (1,1)   logical
        % These were inputs to eyetrack_eyelink so we can instruct marmoview
        % to provide those same inputs to eyelink_trackpixx
        eyeFile = []
        eyePath = []
    end

    methods
        function obj = eyetrack_trackpixx(h, eyeFile, eyePath, varargin) % h is the handle for the marmoview gui

            % initialise input parser
            ip = inputParser;
            addParameter(ip, 'LedIntensity', 8, @isnumeric);
            addParameter(ip, 'SetExpectedIrisSizeInPixels', 115, @isnumeric);
            addParameter(ip, 'EyeDump', true, @islogical); % default 1, do EyeDump
            parse(ip, varargin{:});

            args = p.Results;

            obj.EyeDump = args.EyeDump;
            obj.eyePath = eyePath;
            obj.eyeFile = eyeFile;

            % Configure the tracker and initialize...
            Datapixx('Open');
            Datapixx('SetLedIntensity', obj.ledIntensity);
            Datapixx('SetTPxAwake');
            Datapixx('SetExpectedIrisSizeInPixels', obj.expectedIrisSize);
            Datapixx('RegWrRd');
            % Show the eye
            img = Datapixx('GetEyeImage');

        end

        function startfile(obj, handles)
            % no file is saved if using mouse

            % I am unclear on how often this needs to be run, only clear that
            % it needs to happen before 'StartTpxSchedule'. Should it go in
            % the constructor or unpause instead?
            Datapixx('SetupTPxSchedule');
            Datapixx('RegWrRd');

        end

        function closefile(obj)
            Datapixx('SetTpxSleep');
            Datapixx('RegWrRd');
            Datapixx('Close');
        end

        function unpause(obj)
            Datapixx('StartTpxSchedule');
            Datapixx('RegWrRd');
        end

        function pause(obj)
            Datapixx('StopTpxSchedule');
            Datapixx('RegWrRd');
        end

        function [x,y] = getgaze(obj)
            % I think this is the instantaneous gaze position rather than waiting
            % until the end of the trial to read out the full buffer
            [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft, xRawRight, yRawRight, xRawLeft, yRawLeft, timeTag] = Datapixx('GetEyePosition');

            % TODO figure out screen outputs from this function
            % In one of the demos (link above), they use this to convert to
            % Psychophysics toolbox Screen coordinates -- not sure that's
            % what marmoview wants?
            fixationLocs = Datapixx('ConvertCoordSysToCustom', [xScreenRight, yScreenRight; xScreenLeft, yScreenLeft]);
        end

        function r = getpupil(~)
            % There are two functions for this
            r = Datapixx('GetPupilSizeSimple');
            % [ppLeftMajor, ppLeftMinor, ppRightMajor, ppRightMinor] = Datapixx('GetPupilSize');
        end

        function sendcommand(obj, tstring)
        end

    end % methods

    methods  (Static) % Extra trackpixx methods
        function setLedIntensity(value)
            Datapixx('SetLedIntensity', value);
        end

        function value = getLedIntensity()
            value = Datapixx('GetLedIntensity');
        end

        function img = getEyeImage()
            img = Datapixx('GetEyeImage');
        end
    end

    methods (Access = private)

    end % private emethods

end % classdef