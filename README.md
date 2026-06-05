
### Structures
- **`S`**:  Settings
- **`P`**:  Parameters
- **`C`**:  Calibration
- **`A`**: 
- **`D`**:  Data (P, eyeData, PR, C)
- **`PR`**: Protocol 
- **`PRI`**: BackImage Protocol (`lastRunWasImage`)
- **`FC`**: FrameControl object

### Light
- Grey: no protocol selected
- Red: protocol loaded but not running
- Blue: protocol initializing
- Green: protocol running
- Yellow: pressed pause


### Eyetracker
- `startfile`: needed for arrington, automatic for eyelink, up to us for trackpixx
- `closefile`: needed for eyelink and arrington
- `pause`: 
- `unpause`: 
- `getgaze`: runs on each flip
- `getpupil`: runs on each flip
- `sendcommand`: necessary for arrington only, useful for logging 
- `initialize`: formerly in the constructor, let's get it into a dedicated fcn


### Protocol
- `generate_trialsList(obj, S, P)`
- `P = next_trial(obj, S, P)`
- `closeFunc(obj)`
- `keepgoing = continue_run_trial(obj, screenTime)`
- `drop = state_and_screen_update(currentTime, x, y)`
- `P = next_trial(obj, S, P)`
- `[FP, TS] = prep_run_trial(obj)`
- `Iti = end_run_trial(obj)`
- `plot_trace(obj, handles)`
- `PR = end_plots(obj, P, A)`


### WORKFLOW
Initialize
- TrialIndexer
- MViewRigSettings()
- FrameControl.initialize()
- FrameControl.updateArgsFromStruct()
- EyeTrack.startFile()

Run
- MVCallback: RunTrial
- EyeTrack.unpause()
- FrameControl.updateArgsFromPStruct()
- Protocol.prepRunTrial()
- _Setting clock_
- FrameControl.prepRunTrial()
- EyeTrack.sendCommand - "TRIALSTART"...
- EyeTrack.unpause()
- _Starting run loop_

Each Frame 
- FrameControl.grabEyeRunTrial()
- FrameControl.updateEyeCalib()
- EyeTrack.getgaze()
- EyeTrack.getpupil()
- [currentTime, ] = FrameControl.grabEyeRunTrial()
- Protocol.stateAndScreenUpdate()
- Protocol.continueRunTrial()

Final Frame
- FrameControl.lastScreenFlip()
- EyeTrack.pause()
- EyeTrack.sendCommand - "TRIALENDED"...
- Protocol.endRunTrial()
- EyeTrack.getDataOnBuffer()
- FrameControl.uploadEyeData()
- FrameControl.uploadC()


Clear
- EyeTrack.pause()
- MView.clearSettings()
- EyeTrack.closeFile()
- _Condensing data_
- MViewRigSettings()
