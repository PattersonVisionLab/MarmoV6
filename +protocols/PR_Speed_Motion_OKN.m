classdef PR_Speed_Motion_OKN < handle
  % Matlab class for running an experimental protocl
  %
  % The class constructor can be called with a range of arguments:
  %
 
  properties (Access = public)
       Iti          double = 1;         % default Iti duration
       startTime    double = 0;         % trial start time
       itiStart     double = 0;         % start of iti interval
       rewardGap    double = 0;         % gap for next target onset
       rewardTime   double = 0;         % store time of last reward
  end
      
  properties (Access = private)
    winPtr; % ptb window
    state           double = 0;      % state counter
    error           double = 0;      % error state in trial
    %*********
    S;              % copy of Settings struct (loaded per trial start)
    P;              % copy of Params struct (loaded per trial)
    trialsList;        % store copy of trial list (not good to keep in S struct)
    %********* stimulus structs for use
    noiseStim = 0;     % which noise stim (if long term duration)
    hNoise = [];       % random flashing background grating
    ori = 0;           % tested orientations
    spatfreq = 0.2;
    tempfreq = 1;      % 
    speedStep = 1;         % speed change phase step
    %******* parameters for Noise History grating stimulus 
    NoiseHistory = []; % list of noise frames over trial and their times
    FrameCount = 0;    % count noise frames
    MaxFrame = (120*20); % twenty second maximum
    TrialDur = 0;      % store internally the trial duration (make less than 20)
    StimPhase = 1;
    %**********************************
    D = struct;        % store PR data for end plot stats, will store dotmotion array
  end
  
  methods (Access = public)
    function o = PR_Speed_Motion_OKN(winPtr)
      o.winPtr = winPtr;
      o.trialsList = [];  % should be set by generate call
    end
    
    function state = get_state(o)
        state = o.state;
    end
    
    function initFunc(o, S, P)
  
       %********** Set-up for trial indexing (required) 
       cors = [0,4];  % count these errors as correct trials
       reps = [1,2];  % count these errors like aborts, repeat
       o.trialsList = [];  % empty for this protocol
       %**********
         
       %******* SETUP NOISE BACKGROUND BASED ON TYPE, HARTLEY, SPATIAL, ETC
       o.NoiseHistory = zeros(o.MaxFrame, 2);
       o.spatfreq = P.spf;
       o.tempfreq = S.frameRate / P.gratingcycle;
       o.ori = P.ori;
       %******
       o.hNoise = cell(1, P.gratingcycle);
       o.StimPhase = 1;
       %*********
       for kpha = 1:P.gratingcycle
           %******** replace dot field with full-field grating
           o.hNoise{1,kpha} = stimuli.grating(o.winPtr);  % grating probe
           o.hNoise{1,kpha}.position = S.centerPix; 
           if isinf(P.noiseradius)
               o.hNoise{1,kpha}.radius = Inf;    %fill entire screen
               o.hNoise{1,kpha}.screenRect = S.screenRect;
           else
               o.hNoise{1,kpha}.radius = round(P.noiseradius*S.pixPerDeg);
           end
           %*********
           o.hNoise{1,kpha}.orientation = o.ori-90;  % 0 should be right
           o.hNoise{1,kpha}.phase = (360*((kpha-1)/P.gratingcycle));
           o.hNoise{1,kpha}.cpd = o.spatfreq;   
           %*******
           o.hNoise{1,kpha}.range = P.noiserange;
           o.hNoise{1,kpha}.square = logical(P.squareWave);
           o.hNoise{1,kpha}.squareAperture = false;
           o.hNoise{1,kpha}.gauss = true;
           o.hNoise{1,kpha}.bkgd = P.bkgd;
           o.hNoise{1,kpha}.transparent = 0.5;
           o.hNoise{1,kpha}.pixperdeg = S.pixPerDeg;
           o.hNoise{1,kpha}.updateTextures();
       end
       %****************
    end
   
    function closeFunc(o)
        if (iscell(o.hNoise))
            for kpha = 1:o.P.gratingcycle
                if ~isempty(o.hNoise{1,kpha})
                    o.hNoise{1,kpha}.CloseUp();
                end
            end
        end
    end
   
    function generate_trialsList(o, S, P)
            % Call a function outside class (easier for us to edit)
            o.trialsList = [];  %all random for this one
    end
        
    function P = next_trial(o, S, P)
        %********************
        o.S = S;
        o.P = P;
        o.error = 0;
        o.FrameCount = 0;
        %********
        if (P.trialdur < 20)
            o.TrialDur = P.trialdur;
        else
            o.TrialDur = 20;
        end
        
        %*************
        if (o.noiseStim == 1)
            o.noiseStim = 2;
        else
            o.noiseStim = 1;
        end
        % o.noiseStim = randi(2);  %1 forward, 2 backward
        o.speedStep = 2^(randi(P.speednum)-1);
        %***********
        o.rewardTime = GetSecs();
        o.rewardGap = P.rewardGapTime;   
        %******** new resettings
        o.NoiseHistory(:,:) = 0;
    end
    
    function [FP,TS] = prep_run_trial(o)
        % Flags that control transitions
        % State is the main variable to control transitions. A protocol can be
        % described by shifting through states. For this protocol:
        % State 0 -- Foraging for targets
        % State 1 -- Fixation entered on target
        % State 2 -- Rewards for target, face shown
        % State 3 -- Foraging finished
        o.state = 0;
        % Errors describe why a trial was not completed
        % No possible errors for this type of experiment
        o.error = 0;     
        %******* Plot States Struct (show fix in blue for eye trace)
                    % any special plotting of states, 
                    % FP(1).states = 1:2; FP(1).col = 'b';
                    % would show states 1,2 in blue for eye trace
        FP(1).states = 1;  %before fixation
        FP(1).col = 'b-';
        FP(2).states = 2;  % fixation held
        FP(2).col = 'r';
        FP(3).states = 3;  % reward on target  
        FP(3).col = 'g';
        %***********
        TS = 1:3;  % most states are time sensitive due to revcor
        %****************
        o.startTime = GetSecs;
        o.Iti = o.P.iti;  % default ITI, could be longer if error        
    end
    
    function updateNoise(o,xx,yy,currentTime)
        if (o.FrameCount < o.MaxFrame)  
            %*************** 
            o.hNoise{1,floor(o.StimPhase)}.beforeFrame();
            if (o.noiseStim == 1)  % forward phase steps
                o.StimPhase = o.StimPhase + o.speedStep;
                if (o.StimPhase > o.P.gratingcycle)
                    o.StimPhase = o.StimPhase - o.P.gratingcycle
                end
            else
                o.StimPhase = o.StimPhase - o.speedStep;
                if (o.StimPhase < 1)
                    o.StimPhase = o.StimPhase + o.P.gratingcycle
                end
            end
            %**********
            o.FrameCount = o.FrameCount + 1;
            % NOTE: store screen time in "continue_run_trial" after flip
            o.NoiseHistory(o.FrameCount,2) = o.noiseStim;               
            %**********
        end
    end   
    
    function keepgoing = continue_run_trial(o, screenTime)
        keepgoing = 0;
        if (o.state < 4)
            keepgoing = 1;
        end
        %******** this is also called post-screen flip, and thus
        %******** can be used to time-stamp any previous graphics calls
        %******** for object on the screen and things like that
        if (o.FrameCount)
           o.NoiseHistory(o.FrameCount,1) = screenTime;  %store screen flip 
        end
        %******************************************************
    end
   
    %******************** THIS IS THE BIG FUNCTION *************
    function drop = state_and_screen_update(o,currentTime,x,y) 
        drop = 0;
        %******* THIS PART CHANGES WITH EACH PROTOCOL ****************
        if (o.state == 0)
            o.state = 1;  % jump in and plot eye traces
        end
        if currentTime > o.startTime + o.TrialDur
            o.state = 4;  % time to end trial
            o.itiStart = GetSecs;
        end
        %***********************
        
        % ALWAYS UPDATE BACKGROUND
        o.updateNoise(NaN,NaN,currentTime);
        
        %******* Deliver random rewards through trial
        if (o.rewardTime > 0)
            if ( (currentTime - o.rewardTime) > o.rewardGap)
                o.rewardTime = currentTime;
                drop = 1;
            end
        end
        %****************************************   
    end
    
    function Iti = end_run_trial(o)
        Iti = o.Iti - (GetSecs - o.itiStart); % returns generic Iti interval
    end
    
    function plot_trace(o,handles)
        %****** plot eccentric ring where stimuli appear
        h = handles.EyeTrace;
        set(h,'NextPlot','Replace');
        eyeRad = handles.eyeTraceRadius;
        % Target ring
        r = o.P.noiseheight;
        plot(h,r*cos(0:.01:1*2*pi),r*sin(0:.01:1*2*pi),'-k');
        set(h,'NextPlot','Add');
        %********
        % h = handles.EyeTrace;
        % set(h,'NextPlot','Replace');
        %****** plot eccentric ring where stimuli appear
        % h = handles.EyeTrace;
        % set(h,'NextPlot','Replace');
        % eyeRad = handles.eyeTraceRadius;
        %*****************
        % axis(h,[-eyeRad eyeRad -eyeRad eyeRad]);
    end
    
    function PR = end_plots(o, P, A)   %update D struct if passing back info
        
        %************* STORE DATA to PR
        %**** NOTE, no need to copy anything from P itself, that is saved
        %**** already on each trial in data .... copy parts that are not
        %**** reflected in P at all and generated random per trial
        PR = struct;
        PR.error = o.error;
        if o.FrameCount == 0
            PR.NoiseHistory = [];
        else
            PR.NoiseHistory = o.NoiseHistory(1:o.FrameCount,:);
        end
        PR.ori = o.ori; % constant over trials, but still nice to store
        PR.spatfreq = o.spatfreq; % constant, but I want to store them
        PR.tempfreq = o.tempfreq; % temporal freq, base (time speed step)
        PR.noiseStim = o.noiseStim; %differs based on noise type
        PR.speedStep = o.speedStep;
        
        %%%% Record some data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% It is advised not to store things too large here, like eye movements, 
        %%%% that would be very inefficient as the experiment progresses
        o.D.error(A.j) = o.error;   % need to decide on something later
        
        %%%% Plot results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Nothing for now ...
       
    end
  end 
end
