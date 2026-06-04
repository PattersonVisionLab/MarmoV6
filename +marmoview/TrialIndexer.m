% class to keep track of trial indexes over a trial list
% by Jude, 9/2/2018   -- handles trial indexing over blocks

classdef TrialIndexer < handle
    
    properties (SetAccess = private)
        trialN;
        trialPerm;
        trialComp;  %track trials completed
        trialInd;  %will step to 1 if no error
    end 
    
    properties 
        corstates	double;             % correct states to continue trial
        repstates   double;             % error states for which to repeat trial
        RepeatUntilCorrect   double;    % if one, repeat till all trials correct
    end
    
    methods
        
        function obj = TrialIndexer(TrialsList, P, corstates, repstates) % h is the handle for the marmoview gui
            cprintf('_Comments', 'TrialIndexer, constructor\n');
            if (isempty(TrialsList))
                obj.trialN = 1;   %it will always return trial 1 if so
            else
                obj.trialN = size(TrialsList,1);
            end
            
            obj.resetTrialBuffer();
            if (isfield(P,'RepeatUntilCorrect'))
                obj.RepeatUntilCorrect = P.RepeatUntilCorrect;
            end
            
            if isempty(corstates)
                obj.corstates = 0;  % error 0 means correct, default
            else
                obj.corstates = corstates;
            end
            if isempty(repstates)
                obj.repstates = 1;  % error 1 is an abort, repeat it
            else
                obj.repstates = repstates;
            end
        end
        
        function trialInd = getNextTrial(obj, error)
            if obj.RepeatUntilCorrect
                if ismember(error,obj.corstates) % correct trials marked complete
                    obj.trialComp(obj.trialInd) = 1;
                end
                if (sum(obj.trialComp) == obj.trialN)  % all correct, then reset
                    obj.resetTrialBuffer();
                else     % find next index not complete
                    findit = 1;
                    k = obj.trialInd;
                    while findit
                        k = k + 1;
                        if (k > obj.trialN)
                            k = 1;
                        end
                        if (obj.trialComp(k) == 0)
                            break;
                        end
                    end
                    obj.trialInd = k;
                end
            else
                %******* only repeat if an abort or fix break
                if  ~ismember(error,obj.repstates)  % not abort or break fix
                    obj.trialInd = obj.trialInd+1;  % always step forward
                    if obj.trialInd >= obj.trialN
                        obj.resetTrialBuffer();
                    end
                end
            end
            %*******************
            trialInd = obj.trialPerm(obj.trialInd);
        end
        
        function resetTrialBuffer(o)
            o.trialPerm = randperm(o.trialN);
            o.trialComp = zeros(1,o.trialN);  %track trials completed
            o.trialInd = 1;  %will step to 1 if no error
        end
    end
end
