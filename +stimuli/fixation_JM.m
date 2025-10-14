classdef fixation_JM < handle
  % Matlab class for drawing fixation target(s) using the psych. toolbox.
  %
  % The fixation target consists of a central circular target and a
  % concentric circular surround (usually contrasting). The size and colour
  % of both the centre and surround can be configured independently.
  %
  % The class constructor can be called with a range of arguments:
  %
  %   centreSize - diameter of centre (pixels)
  %   surroundRadius - diameter of surround (pixels)
  %   centreColour - colour of centre (clut index or [r,g,b])
  %   surroundColour - colour of surround (clut index or [r,g,b])
  %   position - center of target (x,y; pixels)
  
  % 16-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>
  
  properties (Access = public)
    cSize = 2; % pixels
    sSize = 4; % pixels
    oSize = 8;
    cColour = zeros([1,3]); % clut index or [r,g,b]
    sColour = ones([1,3]);
    sbColour = zeros([1,3]);
    position = [0.0, 0.0]; % [x,y] (pixels)
  end
        
  properties (Access = private)
    winPtr; % ptb window
  end
  
  methods (Access = public)
    function o = fixation_JM(winPtr,varargin) % marmoview's initCmd?
      o.winPtr = winPtr;
      
      if nargin == 1
        return
      end

      % initialise input parser
      args = varargin;
      p = inputParser;
      p.StructExpand = true;
      p.addParameter('centreSize',o.cSize,@isfloat); % pixels
      p.addParameter('surroundSize',o.sSize,@isfloat);
      p.addParameter('centreColour',o.cColour,@isfloat); % clut index or [r,g,b]
      p.addParameter('surroundColour',o.sColour,@isfloat);
      p.addParameter('surroundColourBlack',o.sbColour,@isfloat);
      p.addParameter('position',o.position,@isfloat); % [x,y] (pixels)
                  
      try
        p.parse(args{:});
      catch
        warning('Failed to parse name-value arguments.');
        return;
      end
      
      args = p.Results;
    
      o.cSize = args.centreSize;
      o.sSize = args.surroundSize;
      o.cColour = args.centreColour;
      o.sColour = args.surroundColour;
      o.sbColour = args.surroundColourBlack;
      o.position = args.position;
    end
        
    function beforeTrial(o)
    end
    
    function beforeFrame(o,state)
      o.drawFixation(state);
    end
        
    function afterFrame(o)
    end
    
    function updateTextures(o)
    end
    
    function CloseUp(o)
    end
  end % methods
    
  methods (Access = public)        
    function drawFixation(o,state)
        
      if (state == 1)    %normal black center, white outline  
         r = floor(o.sSize./2); % radius in pixels
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FillOval',o.winPtr,o.sColour,rect');
         r = floor(o.cSize./2);
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FillOval',o.winPtr,o.cColour,rect');
      end
      if (state == 2)   %larger white empty point
         r = floor(2 * o.cSize);
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FrameOval',o.winPtr,o.sColour,rect',floor(r/4));
      end
      if (state == 3)   %all black filled fixation point
         r = floor(o.cSize./2);
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FillOval',o.winPtr,o.cColour,rect');
      end
      if (state == 4)   %larger black empty point
         r = floor(2 * o.oSize);
         rthin = floor( 2 * o.cSize);
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FrameOval',o.winPtr,o.sbColour,rect',floor(rthin/4));
      end
      if (state == 5)   %larger black empty point
         r = floor(2 * o.oSize);
         rthin = floor( 2 * o.cSize);
         rect = kron([1,1],o.position) + kron(r(:),[-1, -1, +1, +1]);
         Screen('FrameOval',o.winPtr,[255,255,255],rect',floor(rthin/4)); %o.cColour,rect',floor(rthin/4));
      end
      % add in a state 4 which would be a black empty point, and can change
      % in the other code to make it used for even trials and the current
      % point for odd trials 
      
    end
  end % methods
  
end % classdef
