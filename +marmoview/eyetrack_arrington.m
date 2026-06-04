% wrapper class for Arrington eye tracker
% 8/23/2018 - Jude Mitchell

classdef eyetrack_arrington < handle
    %******* basically is just a wrapper for a bunch of VPX calls
    % the VPX toolbox enables the eye tracker to link into Matlab
    % and to store raw eye data into a .vpx file for off-line analysis
    
    
    properties
        EyeDump      logical
    end
    
    methods
        function obj = eyetrack_arrington(h, varargin) % h is the handle for the marmoview gui
            
            % initialise input parser
            p = inputParser;
            p.addParameter('EyeDump', true, @islogical); % default 1, do EyeDump
            p.parse(varargin{:});
            
            obj.EyeDump = p.Results.EyeDump;
            
            % configure the tracker and initialize...
            vpx_Initialize; % load the ViewPoint libray
            
            if obj.EyeDump
                vpx_SendCommandString('datafile_AsynchStringData Yes');
                vpx_SendCommandString('dataFile_UnPauseUponClose True');
            end
        end
        
        function startfile(obj, handles)
            if obj.EyeDump
                eyeFile = sprintf('%s_%s_%s_%s.vpx', ...
                    handles.outputPrefix, ...
                    handles.outputSubject, ...
                    handles.outputDate, ...
                    handles.outputSuffix);
                
                fname = fullfile(handles.outputPath, eyeFile);
                vpx_SendCommandString(sprintf('dataFile_NewName "%s"',fname));
                vpx_SendCommandString('dataFile_Pause Yes'); % pause
            end
        end
        
        function closefile(obj)
            if obj.EyeDump
                vpx_SendCommandString('dataFile_Close');
            end
        end
        
        function unpause(obj)
            if obj.EyeDump
                vpx_SendCommandString('dataFile_Pause No');
            end
        end
        
        function pause(obj)
            if obj.EyeDump
                vpx_SendCommandString('dataFile_Pause Yes');
            end
        end
        
        function [x,y] = getgaze(obj)
            [x,y] = vpx_GetGazePoint;
            y = 1 - y; % NEED TO INVERT SO ++ IS UP
        end
        
        function r = getpupil(obj)
            r = vpx_GetPupilSize;
        end
        
        function sendcommand(obj, tstring)
            vpx_SendCommandString(['dataFile_InsertString "', tstring, '"']);
        end
        
    end 
end 
