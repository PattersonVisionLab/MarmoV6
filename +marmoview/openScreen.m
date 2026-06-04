function A=openScreen(S,A)
    % OPENSCREEN Opens PTB window with parameters specified in S

    PsychStartup();

    % disable ptb welcome screen
    Screen('Preference','VisualDebuglevel',3);

    % close any open windows
    Screen('CloseAll');
    PsychDefaultSetup(0);

    % setup the image processing pipeline for ptb
    PsychImaging('PrepareConfiguration');

    PsychImaging('AddTask','General','FloatingPoint16Bit');
    %PsychImaging('AddTask','General','FloatingPoint32BitIfPossible');

    % Applies a simple power-law gamma correction
    PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');

    % create the ptb window...
    if isfield(S,'DummyScreen') && S.DummyScreen
      [A.window, A.screenRect] = PsychImaging('OpenWindow',...
          0, S.bgColour, S.screenRect);
    else    
      [A.window, A.screenRect] = PsychImaging('OpenWindow',...
          S.screenNumber, S.bgColour);
      % Add gamma correction
      PsychColorCorrection('SetEncodingGamma', A.window, 1/S.gamma);
    end

    A.frameRate = FrameRate(A.window);

    % bump ptb to maximum priority
    A.priorityLevel = MaxPriority(A.window);

    % set alpha blending/antialiasing etc.
    Screen(A.window, 'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    if isfield(S, 'DataPixx') && S.DataPixx 
        if Datapixx('IsViewPixx')
            Datapixx('Open');
            cprintf('*[1,0.25,0.25]', '\topenScreen, Opened datapixx');
        end
    end