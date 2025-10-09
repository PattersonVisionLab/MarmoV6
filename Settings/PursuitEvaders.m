function [S,P] = PursuitEvaders

%%%%% NECESSARY VARIABLES FOR GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD THE RIG SETTINGS, THESE HOLD CRUCIAL VARIABLES SPECIFIC TO THE RIG,
% IF A CHANGE IS MADE TO THE RIG, CHANGE THE RIG SETTINGS FUNCTION IN
% SUPPORT FUNCTIONS
S = MarmoViewRigSettings;

% NOTE THE MARMOVIEW VERSION USED FOR THIS SETTINGS FILE, IF AN ERROR, IT
% MIGHT BE A VERSION PROBLEM
S.MarmoViewVersion = '5';

% PARAMETER DESCRIBING TRIAL NUMBER TO STOP TASK
S.finish = 20;

% PROTOCOL PREFIXS
S.protocol = 'PursuitEvaders';
S.protocol_class = ['protocols.PR_',S.protocol];

% Define Banner text to identify the experimental protocol
S.protocolTitle = 'Track a wiggling vertical Gabor';

%******** Similar to FaceCal, but configurations are choosen random
%******** from a grid of possible locations, and second, on viewing
%******** a face it becomes a fixation point for a duration, followed
%******** by reward and disappearing if fixation is held (fix foraging)

%********** allow calibratin of eye position during running
P.InTrialCalib = 0;
S.InTrialCalib = 'Eye Calib in Trials';

%********* Show natural image for a break
P.CycleBackImage = 5;
S.CycleBackImage = 'If def, backimage every # trials:';
P.ProbFixTrial = 0.0;  
S.ProbFixTrial = 'Prob of a fixation trial';

%%%%% END OF NECESSARY VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This settings is unnecessary because 'MarmoViewLastCalib.mat' is the GUI
% default to use, but because this is an exemplar protocol I decided to
% includee it if for some reason you don't want to use the last calibration
% values (e.g. subjects you are running have substantially different 
% horizontal or vertical gain). Place this calibration file in the
% 'SupportData' directory of MarmoView
S.calibFilename = 'MarmoViewLastCalib.mat';

% If using the gaze indicator, this sets a step value, intensity should be
% between 1 and 5, this is taking advantage of male color blindness to make
% it less obvious to the marmoset than us, but it will still be obvious if
% overwriting textures

%%%%% PARAMETERS -- VARIABLES FOR TASK, CAN CHANGE WHILE RUNNING %%%%%%%%%
% INCLUDES STIMULUS PARAMETERS, DURATIONS, FLAGS FOR TASK OPTIONS
% MUST BE SINGLE VALUE, NUMERIC -- NO STRINGS OR ARRAYS!
% THEY ALSO MUST INCLUDE DESCRIPTION OF THE VALUE IN THE SETTINGS ARRAY

% Stimulus settings
P.faceradius = 1.0;
S.faceradius = 'Aperture radius (degrees):';
P.facePathTime = 2; % in seconds (will multiply by frame per sec in code)
S.facePathTime = 'Time in seconds of Face flash fixation';
%**********
P.eyeRadius = 2.0;
S.eyeRadius = 'Gaze indicator radius (degrees):';
P.eyeIntensity = 10;
S.eyeIntensity = 'Indicator intensity:';
P.showEye = 0;
S.showEye = 'Show the gaze indicator? (0 or 1):';
P.bkgd = 127;
S.bkgd = 'Choose the background color (0-255):';

% Gabor moving stim properties
P.gaborRadius = 0.75;
S.gaborRadius = 'Size of stimulus radius';
P.gaborOri = 0; %90;
S.gaborOri = 'Orientation of tracked grating';
P.gaborCpd = 2.0; % cycles per deg for stim
S.gaborCpd = 'Cycles per deg';

    
% *** Things to make the Gabor path for trial
P.gaborPathTime = 3;   % in seconds (will multiply by frame per sec in code) ... max they can loose and reacquire it
S.gaborPathTime = 'Time in seconds of Gabor moving';
P.gaborDecay = exp(-1/15);  % this will be straighter
S.gaborDecay = 'Decay in 1/e in frames';
P.gaborStep = 2.5; % no random extra motion, all linear moves ; % was 2.5; %5 angular steps in turning
S.gaborStep = 'Angular noise in turning angle';
P.gaborEvade = 45;
S.gaborEvade = 'One time +/- turn at acquisition';

P.holdFix = 0.2;  % duration to hold fix before start track
S.holdFix = 'Fix hold before start tracking:';
P.reappearGap = 1.5;  % random uniform distribution, 0 to this, reappear after acquired
S.reappearGap = 'Time to reappear target after acquired';
P.minreappear = 0.5;  % min time to restart with new target
S.minreappear = 'Min offset before new target appears';
P.gaborSpeed = 6; % degrees per sec, contstant velocity
S.gaborSpeed = 'Speed of moving target (constant)';
P.gaborCapture = 0.6;  % force her to look at it this long before change contrast
S.gaborCapture = 'Duration she must look before contrast change:';
P.gaborHold = 0.6;  % duration to hold target for reward
S.gaborHold = 'Duration to hold for juice';
P.gaborStartRad = (P.gaborSpeed * 0.2); 
S.gaborStartRad = 'Runs Rassbash back to center:';
P.updateOrientation = 1;
S.updateOrientation = 'Mark 1 if Gabor should change ori per frame';

P.gaborBoundary = 10;  % in visual degs
S.gaborBoundary = 'Maximum of square from fixation';
P.useCircleBoundary = 1;
S.useCircleBoundary = 'Use circular boundary, not square';
P.gaborReward = 0.25; % flash grating while drop (time before reposition)
S.gaborReward = 'Duration to flash grating and restart clock';
P.searchHold = 1.5; % if not on target at all for this period, reset its loc
S.searchHold = 'Duration before reset target location';

P.probFixJuice = 1.0;  % prob for a drop of juice on fixation
S.probFixJuide = 'Prob of fixation juice drop';

P.flashFrameLength = 6;
S.flashFrameLength = 'Counter for flashing on and off fixation';

P.DotTrialProb = 0.0;
S.DotTrialProb = 'Fraction of trials with straight motion, small dot target';
P.dotSpeedArray = [4]; % [2,6,10] % degs per sec
S.dotSpeedArray = 'Possible speeds (dot move)';
P.DotJiggleProb = 0.5;
S.DotJiggleProb = 'Fraction of trials with jiggle dot motion';
P.startAng = 22.5; 
S.startAng = 'Gaussian around horizontal, +/- sig in angle';

% Trial timing
P.fixRadius = 2.0;
S.fixRadius = 'Radius to accept a fixating gabor';
%**** These are new to implement Aki's sloppy pursuit start ******
P.fixInitRadius = 3.0;
S.fixInitRadius = 'Radius to accept a fixating until pursuit started';
P.gaborInitTime = 0.4;  % must acquire target within fixRadius by this time
                          % this should be shorter than P.gaborCapture(0.5)
S.gaborInitTime = 'How long before InitRadius slop expires:';
%**********************************

P.fixPointRadius = 0.2;
S.fixPointRadius = 'Fixation point radius';
P.flashFrameLength = 12;
S.flashFrameLength = 'On and off duration of flashing fixation (frames)';

P.iti = 0.5;
S.iti = 'Duration of intertrial interval (s):';

P.hardTrialThreshold = 5;  % if above this contrast level, count as hard
S.hardTrialThreshold = 'Contrast list from easy to hard, above this count as hard';
P.maxHardRepeat = 1; % if more than this trials in a row that are hard, force easy
S.maxHardRepeat = 'If more than this trials in a row that are hard, force easy';

