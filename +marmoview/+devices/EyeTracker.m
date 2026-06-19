classdef (Abstract) EyeTracker < handle 

    properties (SetAccess = private)
        doStreamData      (1,1)      logical  
    end

    methods
        function obj = EyeTracker(varargin)
            ip = inputParser();
            ip.KeepUnmatched = true;
            addParameter(ip, 'Stream', true, @islogical);
            parse(ip, varargin{:});

            obj.doStreamData = ip.Results.Stream;

            obj.initialize();
        end

        function setStreaming(obj, value)
            obj.doStreamData = value;
        end

        function pause(obj)

        end

        function unpause(obj)

        end

        function [x1, y2] = getgaze(obj)
            
        end 

        function r = getpupil(obj)

        end
    end

    methods (Access = protected)
        function initialize(obj)
        end
    end
end
