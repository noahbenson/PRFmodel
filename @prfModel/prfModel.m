classdef prfModel < handle
    % Initialize a prf model object for the forward time series
    % calculation
    %
    % Syntax:
    %      pm = prfModel(varargin);
    %
    % Inputs:
    %
    % Outputs:
    %
    % Optional key/value pairs:
    %
    % Description
    %
    % See also
    %
    
    % Examples
    %{
       pm = prfModel;
       pm.rfCompute;
    %}
    
    properties (GetAccess=public, SetAccess=public)
        % Here we should have all the parameters we will allow to be 
        TR = 1;                % Repetition time of the MR acquisition
""""""
"
    
    properties(Access = private)
        tire;
        bodyColor;
    end
    methods        
        function set.color(this, v)
            this.bodyColor = v;
            this.tire.paintColor = v;
        end
        function v = get.color(this)
            v = this.bodyColor;
        end
        function obj = Car
            obj.tire = Tire;
            obj.color = 'black';
        end
    end

""""""
             
        
    end
    
    properties (Access = private)
        HRF;      % Class: Hemodynamic Response Function
        Stimulus; % Class: Stimulus.
        RF;       % Class: Receptive field. 
        Noise;    % Class: Noise
        BOLD;     % Class: Predicted synthetic time series
    end
    
    %%
    methods
        
        % Constructs 
        function pm = prfModel  % varargin
            % Return a working prfModel using only defaults.
            
%             varargin = mrvParamFormat(varargin);
%             
%             p = inputParser;
%             p.addParameter('tr',2,@isnumeric);                  % Seconds
%             p.addParameter('values', [],@isnumeric);            % actual values, matrix
%             p.addParameter('fieldofviewHorz',[],@isnumeric);    % Deg
%             p.addParameter('fieldofviewVert',[],@isnumeric);    % Deg
%             p.addParameter('hrfduration'    ,20,@isnumeric);    % Seconds
%             
%             p.parse(varargin{:});
            
            %% MR parameters
            % pm.TR         = p.Results.tr;
            
               
            %% Initialize time steps and HRF
            % pm.HRF.duration  = p.Results.hrfduration;
            pm.HRF.tSteps    = 0:(pm.TR):pm.HRF.duration;   % For now, always to 20 sec
            pm.HRF.modelName = 'friston';
            pm.HRF.Friston_a = [];
            pm.HRF.Friston_b = [];
            pm.HRF.Friston_c = [];
            pm               = pm.HRFget;
            
            %% The sequence of stimulus images
            
            % We will probably attach the stimulus movie (time series of images)
            % and write a method that converts the movie to the binary stimulus
            % for us.
            pm.stimulus.fieldofviewHorz = p.Results.fieldofviewHorz;
            pm.stimulus.fieldofviewVert = p.Results.fieldofviewVert;
            pm.stimulus.values          = p.Results.values;
            
            % Obtain the X and Y values
            pm                          = pm.spatialSampleCompute;
            
            %% The receptive field parameters
            
            pm.RF.center     = [0 0];    % Deg
            pm.RF.theta      = 0;        % Radians
            pm.RF.sigmaMajor = 1;        % deg
            pm.RF.sigmaMinor = 1;        % deg
            
            
            %% The predicted BOLD signal
            pm.BOLD.timeSeries          = [];
            pm.BOLD.tSamples            = [];
            pm.BOLD.predicted           = [];
            
            %% Noise
            pm.noise.Type               = "white";
            pm.noise.white_k            = 0.5;
            pm.BOLD.predictedWithNoise  = [];
            
            
        end
        
        
        function set.TR(pm, tr)
            pm.HRF.TR       = tr;
            pm.Stimulus.TR  = tr;
        end
        function v = get.color(this)
            v = this.bodyColor;
        end
        function obj = Car
            obj.tire = Tire;
            obj.color = 'black';
        end
        
        
        
        
        
    end
    
end