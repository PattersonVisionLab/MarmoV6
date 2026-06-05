function TPxData = readTrackpixxBuffer(opts)
% READTRACKPIXXBUFFER
%
% Description:
%   Read data on the Trackpixx's buffer and reformat as a table. Optionally
%   save out the data as csv (default) or mat file. Calling with neither
%   inputs (save = false) nor outputs effectively clears the buffer I think
%
% Syntax:
%   TPxData = readTrackpixxBuffer()
%   readTrackpixxData('SaveData', true, 'MyNewTrial.csv')
%
% Optional Inputs:
%   SaveData        logical
%       Whether to directly save the file data (default = false)
%   FileName        string
%       File name ending in .mat or .csv (default = 'TPxData.csv')
%
% Outputs:
%   TPxData         table
%       See below for fields. This is the main output of the eye tracker for
%       a given trial.
%
% TODO:
%   - Figure out save file names and folders (currently cd)
%   - Warn on overwriting a file?
%   - Does Marmoview just append to an existing file for all trials in an
%     experiment?
%
% Resources:
%   https://docs.vpixx.com/vocal/a-simple-free-viewing-task-in-matlab
% -------------------------------------------------------------------------

    arguments
        opts.SaveData (1,1)         logical     = false
        opts.FileName (1,1)         string      = "TPxData.csv"
        opts.Output   (1,1)         string      = "table"
    end

    if opts.SaveData
        [~, ~, ext] = fileparts(opts.FileName);
        if ext == ""
            opts.FileName = opts.FileName + ".csv";
        end
    end

    status = Datapixx('GetTPxStatus');
    toRead = status.newBufferFrames;
    if toRead == 0
        cprintf('_[0.5,0.5,0.5]', '\t\readTrackpixxBuffer EMPTY\n');
        TPxData = [];
        return
    end
    cprintf('_[0.5,0.5,0.5]', '\t\readTrackpixxBuffer (%u frames)\n', toRead);
    [bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);

    %save eye data from trial as a table in the trial structure
    TPxData = array2table(bufferData, 'VariableNames', { ...
        'TimeTag', 'LeftEyeX', 'LeftEyeY', 'LeftPupilDiameter',...
        'RightEyeX', 'RightEyeY', 'RightPupilDiameter',...
        'DigitalIn', 'LeftBlink', 'RightBlink', 'DigitalOut',...
        'LeftEyeFixationFlag', 'RightEyeFixationFlag',...
        'LeftEyeSaccadeFlag', 'RightEyeSaccadeFlag',  'MessageCode',...
        'LeftEyeRawX', 'LeftEyeRawY', 'RightEyeRawX', 'RightEyeRawY'});

    if endsWith(opts.FileName, ".mat")
        writetable(TPxData, char(opts.FileName));
    elseif endsWith(opts.FileName, ".csv")
        save(opts.FileName, 'TPxData');
    end

    %bufferData is formatted as follows:
%1      --- Timetag (in seconds)
%2      --- Left Eye X (in pixels)
%3      --- Left Eye Y (in pixels)
%4      --- Left Pupil Diameter (in pixels)
%5      --- Right Eye X (in pixels)
%6      --- Right Eye Y (in pixels)
%7      --- Right Pupil Diameter (in pixels)
%8      --- Digital Input Values (24 bits)
%9      --- Left Blink Detection (0=no, 1=yes)
%10     --- Right Blink Detection (0=no, 1=yes)
%11     --- Digital Output Values (24 bits)
%12     --- Left Eye Fixation Flag (0=no, 1=yes)
%13     --- Right Eye Fixation Flag (0=no, 1=yes)
%14     --- Left Eye Saccade Flag (0=no, 1=yes)
%15     --- Right Eye Saccade Flag (0=no, 1=yes)
%16     --- Message code (integer)
%17     --- Left Eye Raw X (in pixels)
%18     --- Left Eye Raw Y (in pixels)
%19     --- Right Eye Raw X (in pixels)
%20     --- Right Eye Raw Y (in pixels)