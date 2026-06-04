classdef EyeTracker < handle 

    properties
        EyeDump 
    end

    properties (SetAccess = private)
        Type 
    end

    methods
        function obj = EyeTracker(varargin)
            ip = inputParser();
            ip.KeepUnmatched = true;
            addParameter(ip, 'EyeDump', true, @islogical);
            parse(ip, varargin{:});

            obj.EyeDump = ip.Results.EyeDump;

            obj.initialize();
            
        end

        function initialize(obj)
            
        end

        function pause(obj)
        end

        function unpause(obj)
        end

        function [x1, y2, x2, y2] = getgaze(obj)
            % 3rd and second arguments for binocular only
        end 
    end
end