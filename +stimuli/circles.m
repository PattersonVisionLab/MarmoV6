classdef circles < handle
    % Matlab class for drawing circles using the psych. toolbox.
    %
    % The class constructor can be called with a range of arguments:
    %
    %   size     - diameter (pixels)
    %   weight   - line weight (pixels)
    %   colour   - line colour (clut index or [r,g,b])
    %   position - center of aperture (x,y; pixels)
    
    % 14-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>
    % 04-06-2026 - SSP - updated
    
    properties
        size        double = 0;             % pixels
        weight      double = 2;             % pixels
        colour      double = ones([1,3]);   % clut index or [r,g,b]
        position	double = [0.0, 0.0];    % [x,y] (pixels)
    end
    
    properties (Access = private)
        winPtr;                             % ptb window
    end
    
    methods
        function obj = circles(winPtr, varargin) % marmoview's initCmd?
            obj.winPtr = winPtr;
            
            if nargin == 1
                return
            end
            
            ip = inputParser;
            ip.StructExpand = true;
            ip.CaseSensitive = false;
            ip.addParameter('size', obj.size, @isfloat); 
            ip.addParameter('weight', obj.weight, @isfloat);
            ip.addParameter('colour', obj.colour, @isfloat); 
            ip.addParameter('position', obj.position, @isfloat);
            
            obj.size = ip.Results.size;
            obj.weight = ip.Results.weight;
            obj.colour = ip.Results.colour;
            obj.position = ip.Results.position;
        end
        
        function beforeTrial(~) % marmoview's nextCmd?
        end
        
        function beforeFrame(obj) % Run?
            obj.drawCircles();
        end
        
        function afterFrame(~) % Run?
        end
        
        function updateTextures(~)  % no textures for this stimulus
        end
        
        function CloseUp(~)
        end
    end
    
    methods
        function drawCircles(obj)
            r = floor(obj.size ./ 2); % radius in pixels
            
            rect = kron([1,1], obj.position) + kron(r(:), [-1, -1, +1, +1]);
            if obj.weight > 0
                Screen('FrameOval', obj.winPtr ,obj.colour,rect', obj.weight);
            else
                Screen('FillOval', obj.winPtr, obj.colour, rect');
            end
        end
    end
    
end
