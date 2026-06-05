# Design notes

Longer comments pulled from MarmoV6 to consolidate info about the initial design into one location


**At the end of the trial run, when Data structure is setup:**

    SKETCH OF MY DATA SOLUTION HERE
     D should be a struct that stores per trial data (not everything)
       D.P has trial parameters (struct)
       D.eyeData has the eye trace (matrix)
       D.PR has feedback from the protocol (struct)
          if the protocol is complicated (rev cor), this could be large
          for example, might list every stim shown per frame in trial
       D.C has the eye calibration (struct)
       
     In this scenario, the PR.end_plots does not get D at all.
     What does that mean, if your PR wants to plot stats over trials
     then it must store its own internal D with that information in
     a list .... so the experimenter needs to police this function.
     It will get the P struct and A each trial and can update then.
