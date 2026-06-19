% wrapper class for New Era syringe pumps that has been adapted by Jude and
% Keith for a solenoid juice delivery 10/5/2018

classdef SolenoidControl < handle % marmoview.liquid
    % StimulusControl - frontend to usb serial relay that controls the
    % stimulus presentation timing for experiment see
    % https://numato.com/docs/1-channel-usb-powered-relay-module/ for
    % details on protocol
    %
    % NOTE: need to send the EndLine character BEFORE and after sending
    % commands or they get lost

    properties (SetAccess = private)
        ComPortName = 'COM4'
        JuicerPort = '0'
        FixationPort = '1'
        FixationLostPort = '2'
        IncorrectPort = '3'
    end 

    properties (Dependent)
        volume             double         % dispensing volume (mL)
    end

    properties
        JuicerDuration           = 0.5               % sec
        FixationDuration         = 0.3               % sec
        FixationLostDuration     = .3                % sec
        IncorrectDuration        = .3                % sec
    end

    properties (Constant, Access = private)
        EndLine = char(hex2dec('0d'))
        TurnOnCmd = 'relay on '
        TurnOffCmd = 'relay off '
        StatusCmd = 'relay read '
    end

    properties (Access = private)
        SerialPort
    end

    methods

        function obj = SolenoidControl(comport)
            obj.ComPortName=comport;
            obj.SerialPort = serial(obj.ComPortName, 'BaudRate', 9600);
            fopen(obj.SerialPort);
        end

        function delete(obj)
            fclose(obj.SerialPort);
            delete(obj.SerialPort);
        end

        function set.volume(obj, value)
            % note: not volume for solenoid, but duration of pulse
            obj.JuicerDuration  = value;  % ul in the GUI, is millisecs here
        end

        function value = get.volume(obj)
            value = obj.JuicerDuration; %
        end

        function err = deliver(obj, varargin)
            err = 0;
            tmr = timer(...
                'StartFcn', @(ev,ob)fprintf(obj.SerialPort,  [obj.EndLine obj.TurnOnCmd obj.JuicerPort obj.EndLine],  'sync'), ...
                'TimerFcn',@(ev,ob)pause(obj.JuicerDuration), ...
                'StopFcn', @(ev,ob)fprintf(obj.SerialPort,  [obj.EndLine obj.TurnOffCmd obj.JuicerPort obj.EndLine],  'sync'));

            start(tmr)
        end

        function r = report(obj) %#ok<MANU>
            r.totalVolume = 0;
        end

    end
end
