classdef (Abstract) liquid < marmoview.feedback
% abstract class for providing feedback in the form of a liquid reward

% 23-05-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>
% 21-06-2026 - SSP - Added getVolumeText
% 22-06-2026 - SSP - added setVolume option
% -------------------------------------------------------------------------
  
    properties (Abstract)
        volume; % must be declared by the concrete subclass
    end

    methods (Abstract)
        txt = getVolumeText(obj, value)
    end
    
    methods
        function obj = liquid(h,varargin)
            obj = obj@marmoview.feedback(h,varargin{:});
        end

        function setVolume(obj, value)
            obj.volume = value;
        end
    end
end 
