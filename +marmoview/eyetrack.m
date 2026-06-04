% 8/23/2018 - Jude Mitchell

classdef eyetrack < handle
    
    properties 
        EyeDump
    end
    
    methods
        function obj = eyetrack_arrington(h, varargin) 
            % h is the handle for the marmoview gui
            
            % initialise input parser
            p = inputParser;
            p.addParameter('EyeDump', true, @islogical); % default 1, do EyeDump
            p.parse(varargin{:});
            
            obj.EyeDump = p.Results.EyeDump;
            
            % configure the tracker and initialize...
        end
        
        function startfile(obj, handles)
            % no file is saved if using mouse
        end
        
        function closefile(obj)
        end
        
        function unpause(obj)
        end
        
        function pause(obj)
        end
        
        function [x,y] = getgaze(obj)
            [x,y] = GetMouse;
            %other specs depend on screen and position
        end
        
        function r = getpupil(obj)
            r = 1.0;
        end
        
        function sendcommand(o, tstring)
        end
        
    end 
end
