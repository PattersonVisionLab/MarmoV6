saveOutput = false;
trialTime = 10;
%Connect to TRACKPixx3
Datapixx('Open');
Datapixx('SetTPxAwake');
Datapixx('SetupTPxSchedule');
Datapixx('RegWr');


img = Datapixx('GetEyeImage');

%open window
screenID = 1;                                      
[windowPtr, rect]=Screen('OpenWindow', screenID, [0,0,0]);

%load our image. The jpg is included in the supplementary file download. We will create a rect that
%defines where the painting will appear on the screen
marmoPath = getMarmoViewPath();
im = imread(fullfile(marmoPath, 'supportdata', 'Ares.png'));

imTexture = Screen('MakeTexture', windowPtr, im); 
imDimensions = [723.2 862.4];
imRect = [rect(3)/2 - imDimensions(1)/2,...
          rect(4)/2 - imDimensions(2)/2,...
          rect(3)/2 + imDimensions(1)/2,...
          rect(4)/2 + imDimensions(2)/2];         

%show countdown
for k=1:3
    DrawFormattedText(windowPtr, int2str(k), 'center', 700, 255);
    Screen('Flip', windowPtr);
    WaitSecs(1);
end

%draw our image in Screen coordinates (0,0 is top left corner)
Screen('DrawTexture', windowPtr, imTexture, [], imRect);

%start logging eye data on the next vertical sync pulse: the start of the frame with our image  
Datapixx('StartTPxSchedule');
Datapixx('SetMarker');
Datapixx('RegWrVideoSync');

%flip our image to the screen
Screen('Flip', windowPtr);


startTime = Datapixx('GetMarker');
t = Datapixx('GetTime');
while t < trialTime
    Screen('Flip', winPtr);
end
%wait
WaitSecs(5);

datapixx.strobe(63,0);  % send all bits on to mark trial start
gs = getSecs();
gt = Datapixx('GetTime');
WaitSecs(5);

%stop immediately and get some timestamps
Datapixx('StopTPxSchedule');
Datapixx('RegWrRd');
endTime = Datapixx('GetTime');
viewingTime = endTime - startTime;

%close our display
Screen('Closeall');

%retrieve state of our TPx buffer and read new contents
status = Datapixx('GetTPxStatus');
toRead = status.newBufferFrames;
[bufferData, ~, ~] = Datapixx('ReadTPxData', toRead);

%save eye data from trial as a table in the trial structure
TPxData = array2table(bufferData, 'VariableNames', {'TimeTag',...
                                                    'LeftEyeX',...
                                                    'LeftEyeY',...
                                                    'LeftPupilDiameter',...
                                                    'RightEyeX',...
                                                    'RightEyeY',...
                                                    'RightPupilDiameter',...
                                                    'DigitalIn',...
                                                    'LeftBlink',...
                                                    'RightBlink',...
                                                    'DigitalOut',...
                                                    'LeftEyeFixationFlag',...
                                                    'RightEyeFixationFlag',...
                                                    'LeftEyeSaccadeFlag',...
                                                    'RightEyeSaccadeFlag',...
                                                    'MessageCode',...
                                                    'LeftEyeRawX',...
                                                    'LeftEyeRawY',... 
                                                    'RightEyeRawX',...
                                                    'RightEyeRawY'});

%save as both a .mat and .csv file
if saveOutput
    save('TPxData.mat', 'TPxData');
    writetable(TPxData, 'TPxData.csv');
end

%turn off tracker and disconnect
Datapixx('SetTPxSleep');
Datapixx('RegWr');
Datapixx('Close');