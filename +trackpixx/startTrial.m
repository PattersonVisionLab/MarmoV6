function startTrial()
    % Status query should be performed first but maybe that should go in a
    % multi-device check step. 
    Datapixx('StartTPxSchedule');
    Datapixx('RegWrRd');