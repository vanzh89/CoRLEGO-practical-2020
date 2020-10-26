%% ModifiedHand2D 

% This element is adapted from the GaussStimulus2D element of COSIVINA.
% GaussStimulus2D creates a two-dimensional Gaussian stimulus.
% Modified version creates normalized 2D Gaussian and values close and 
% below 0 are capped to 0.
% Additionally, the position, variance, amplitude and movement of the 
% hand stimulus can be controlled while the simulation is running. 

classdef ModifiedHand2D < Element
    
    properties (Constant)
        parameters = struct('size', ParameterStatus.Fixed, 'sigmaX', ParameterStatus.InitRequired, ...
            'sigmaY', ParameterStatus.InitRequired, 'amplitude', ParameterStatus.InitRequired, ...
            'positionY', ParameterStatus.InitRequired, 'positionX', ParameterStatus.InitRequired, ...
            'rowPeakV', ParameterStatus.InitRequired,'colPeakV', ParameterStatus.InitRequired,...
            'velocity', ParameterStatus.Changeable,...
            'circularX', ParameterStatus.InitRequired, 'circularY', ParameterStatus.InitRequired, ...
            'normalized', ParameterStatus.InitRequired);
        components = {'output','positionX','positionY','velocity','velocityIndex','velocityXaxes'};
        defaultOutputComponent = 'output';
    end
    
    properties
        % parameters
        size = [1, 1];
        sigmaX = 1;
        sigmaY = 1;
        amplitude = 0;
%         positionX = 1;
%         positionY = 1;
        rowPeakV=60;
        colPeakV=60;
        
        circularX = true;
        circularY = true;
        normalized = false;
        
        % accessible structures
        output
        positionY
        positionX
        velocity
        velocityIndex
        velocityXaxes
    end
    
    methods
        % constructor
        function obj = ModifiedHand2D(label, size, sigmaY, sigmaX, amplitude, positionY, positionX, ...
                rowPeakV,colPeakV,velocity,circularY, circularX, normalized)
            if nargin > 0
                obj.label = label;
                obj.size = size;
            end
            if nargin >= 4
                obj.sigmaY = sigmaY; %sigmaY is changed to sigmaX since we want them to be equal and control with only one parameter
                obj.sigmaX = sigmaX;
            end
            if nargin >= 5
                obj.amplitude = amplitude;
            end
            if nargin >= 7
                obj.positionY = positionY;
                obj.positionX = positionX;
            end
            if nargin >= 10
                obj.rowPeakV = rowPeakV;
                obj.colPeakV = colPeakV;
                obj.velocity = velocity;
            end
            
            if nargin >= 12
                obj.circularY = circularY;
                obj.circularX = circularX;
            end
            if nargin >= 13
                obj.normalized = normalized;
            end
            
            if numel(obj.size) == 1
                obj.size = [1, obj.size];
            end
        end
        
        
        % step function
        function obj = step(obj, time, deltaT) %#ok<INUSD>
           
            
            obj.velocityXaxes = time;
           
            
        end
        
        
        % initialization
        function obj = init(obj)
            
            obj.rowPeakV=obj.size(:,2)/2;
            obj.colPeakV=obj.size(:,1)/2;
            obj.velocity=0;
            obj.velocityIndex=1;
            obj.velocityXaxes=[1,0];
            
            obj.output = circularGauss2d(1:obj.size(1), 1:obj.size(2), obj.positionY, obj.positionX, ...
                obj.sigmaY, obj.sigmaX, [], obj.circularY, obj.circularX);
            if obj.normalized && any(any(obj.output))
                obj.output = (obj.amplitude / sum(sum(obj.output))) * obj.output;
                [row col]=size(obj.output);
                maxVal=max(max(obj.output));
                for i=1:row
                    for k=1:col
                        if obj.output(i,k)<(maxVal/100000)
                            obj.output(i,k)= 0;
                        end
                    end
                end
            else
                obj.output = obj.amplitude * obj.output;
                [row col]=size(obj.output);
                maxVal=max(max(obj.output));
                for i=1:row
                    for k=1:col
                        if obj.output(i,k)<(maxVal/100000)
                            obj.output(i,k)= 0;
                        end
                    end
                end
            end
        end
    end
    
end
