
### Structures
- **`S`**:  Settings
- **`P`**:  Parameters
- **`C`**:  Calibration
- **`D`**:  Data (P, eyeData, PR, C)
- **`PR`**: Protocol ()
- **`FC`**: FrameControl object

### Light
- Red: protocol loaded but not running
- Blue: protocol initializing
- Grey:
- Green:


### Eyetrackers
- `startfile`: needed for arrington, automatic for eyelink, up to us for trackpixx
- `closefile`: needed for eyelink and arrington
- `pause`:
- `unpause`: 
- `getgaze`:
- `getpupil`:
- `sendcommand`: necessary for arrington only 
- `initialize`: formerly in the constructor, let's get it into a dedicated fcn


### Protocols
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


