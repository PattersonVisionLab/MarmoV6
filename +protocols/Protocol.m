classdef Protocol < handle 
%
% PROPERTIES
%   Iti                 
% METHODS
%   value = get_state(obj)
%   initFunc(obj, S, P)
%   closeFunc(obj)
%
%   generate_trialsList(obj, S, P)
%   tf = continue_run_trial(obj, lastFlipTime)
%   P = next_trial(obj, S, P)
%   iti = end_run_trial(obj)
%   rewardFlag = state_and_screen_update(obj)
%
%   plot_trace(obj)
%   end_plots(obj)   

    properties 
        Iti             = 1;        % default Iti duration
        itiStart        = 0;        % start of ITI interval
        startTime       = 0;        % trial start time
        rewardCount     = 0;        % counter for reward drops
    end

    properties (Access = protected)
        winPtr
        S                   % copy of Settings struct (loaded per trial start)
        P                   % copy of Params struct (loaded per trial)
        state   = 0;        % state counter
        error   = 0;        % error state in trial
        trialsList = []     % Optional
        trialsIndexer = []  % Optional
    end

    methods
        function obj = Protocol(winPtr)
            obj.winPtr = winPtr;
            obj.trialsList = [];
        end

        function initFunc(obj, S, P) %#ok<INUSD>

        end

        function closeFunc(obj) %#ok<MANU> 

        end

        function value = get_state(obj)
            value = obj.state;
        end
    end

    methods 
        function generate_trialsList(obj, S, P) %#ok<INUSD> 
            
        end

        function tf = continue_run_trial(obj, lastFlipTime) %#ok<INUSD> 
            % Implement in subclasses
            tf = false;
        end

        function P = next_trial(obj, S, P)
            obj.S = S;
            obj.P = P;
        end

        function plot_trace(obj) %#ok<MANU> 
        end

        function rewardFlag = state_and_screen_update(obj) %#ok<MANU> 
            % Implement in subclasses
            rewardFlag = false;
        end

        function end_plots(obj)  %#ok<MANU>
        end

        function iti = end_run_trial(obj)
            iti = obj.Iti;
        end
    end
end
