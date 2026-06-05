classdef eyetrack_trackpixx < handle


    properties (SetAccess = private)
        ledIntensity        (1,1)   double
        expectedIrisSize    (1,1)   double
    end

    properties
        EyeDump             (1,1)   logical
        eyeFile = []
        eyePath = []
    end

    properties (SetAccess = private)
        isAwake     (1,1)       logical     = false
    end

    methods
        function o = eyetrack_trackpixx(h, varargin) 

            ip = inputParser();
            ip.KeepUnmatched = true;
            ip.CaseSensitive = false;
            addParameter(ip, 'LedIntensity', 8, @isnumeric);
            addParameter(ip, 'SetExpectedIrisSizeInPixels', 115, @isnumeric);
            addParameter(ip, 'EyeDump', true, @islogical); 
            parse(ip, varargin{:});

            o.EyeDump = ip.Results.EyeDump;
            o.ledIntensity = ip.Results.LedIntensity;
            o.expectedIrisSize = ip.Results.expectedIrisSize;

            obj.initialize();
        end

        function initialize(obj)
            Datapixx('Open');
            Datapixx('SetLedIntensity', obj.ledIntensity);
            Datapixx('SetTPxAwake');
            isAwake = true;
            Datapixx('SetExpectedIrisSizeInPixels', obj.expectedIrisSize);
            Datapixx('RegWrRd');
        end

        function startfile(obj)
            % no file is saved if using mouse
            Datapixx('Open');
            Datapixx('SetupTPxSchedule');
            Datapixx('RegWrRd');
        end

        function closefile(obj)
            Datapixx('SetTpxSleep');
            Datapixx('RegWrRd');
            isAwake = false;
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

        function [x, y] = getgaze(obj)
            [xScreenRight, yScreenRight, xScreenLeft, yScreenLeft,... 
                xRawRight, yRawRight, xRawLeft, yRawLeft, timeTag] = Datapixx('GetEyePosition');
            x = xRawRight ;
            y = 1 - (yRawRight );
        end

        function r = getpupil(~)
            % There are two functions for this
            % r = Datapixx('GetPupilSizeSimple');

            [ppLeftMajor, ppLeftMinor, ppRightMajor, ppRightMinor] = Datapixx('GetPupilSize');
        end

        function sendcommand(o, tstring)
        end

    end 

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
end 
