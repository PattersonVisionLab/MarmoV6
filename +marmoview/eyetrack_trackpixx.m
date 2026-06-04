classdef eyetrack_trackpixx < handle


    properties (SetAccess = private)
        % I put the default properties in Trackpixx demos, we will want to adjust
        ledIntensity        (1,1)   double
        expectedIrisSize    (1,1)   double
    end

    properties
        EyeDump             (1,1)   logical
        % These were inputs to eyetrack_eyelink so we can instruct marmoview
        % to provide those same inputs to eyelink_trackpixx
        eyeFile = []
        eyePath = []
    end

    methods
        function o = eyetrack_trackpixx(h, varargin) % h is the handle for the marmoview gui

            % initialise input parser
            ip = inputParser();
            ip.KeepUnmatched = true;
            addParameter(ip, 'LedIntensity', 8, @isnumeric);
            addParameter(ip, 'SetExpectedIrisSizeInPixels', 115, @isnumeric);
            addParameter(ip, 'EyeDump', true, @islogical); % default 1, do EyeDump
            parse(ip, varargin{:});

            p.addParameter('EyeDump',true,@islogical); % default 1, do EyeDump
            p.addParameter( 'LedIntensity', 8, @isnumeric);
            p.addParameter( 'SetExpectedIrisSizeInPixels', 115, @isnumeric);
            p.parse(varargin{:});

            o.EyeDump = ip.Results.EyeDump;
            o.ledIntensity = ip.Results.LedIntensity;
            o.expectedIrisSize = ip.Results.expectedIrisSize;

            % Configure the tracker and initialize...
            Datapixx('Open');
            Datapixx('SetLedIntensity', o.ledIntensity);
            Datapixx('SetTPxAwake');
            Datapixx('SetExpectedIrisSizeInPixels', o.expectedIrisSize);
            Datapixx('RegWrRd');
            % Show the eye
            img = Datapixx('GetEyeImage');

        end

        function startfile(o, handles)
            % no file is saved if using mouse

            % I am unclear on how often this needs to be run, only clear that
            % it needs to happen before 'StartTpxSchedule'. Should it go in
            % the constructor or unpause instead?
            Datapixx('Open');
            Datapixx('SetupTPxSchedule');
            Datapixx('RegWrRd');

        end

        function closefile(o)
            Datapixx('SetTpxSleep');
            Datapixx('RegWrRd');
            Datapixx('Close');
        end

        function unpause(o)
            Datapixx('StartTpxSchedule');
            Datapixx('RegWrRd');
        end

        function pause(o)
            Datapixx('StopTpxSchedule');
            Datapixx('RegWrRd');
        end

        function [x,y] = getgaze(o)
            % I think this is the instantaneous gaze position rather than waiting
            % until the end of the trial to read out the full buffer
            
            [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft, xRawRight, yRawRight, xRawLeft, yRawLeft, timeTag] = Datapixx('GetEyePosition');
            x = xRawRight ;
            y = 1 - (yRawRight );

            % TODO figure out screen outputs from this function
            % In one of the demos (link above), they use this to convert to
            % Psychophysics toolbox Screen coordinates -- not sure that's
            % what marmoview wants?

            
        end

        function r = getpupil(~)
            % There are two functions for this
            r = Datapixx('GetPupilSizeSimple');
            % [ppLeftMajor, ppLeftMinor, ppRightMajor, ppRightMinor] = Datapixx('GetPupilSize');
        end

        function sendcommand(o, tstring)
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