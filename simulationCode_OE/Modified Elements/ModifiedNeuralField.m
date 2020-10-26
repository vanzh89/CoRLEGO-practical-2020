%% ModifiedNeuralField
% Adapted from the NeuralField element of COSIVINA
% Additionally, this provides maximum activation coordinates.
% This element is used to create the Velocity map which updates the hand
% movement.

classdef ModifiedNeuralField < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'tau', ParameterStatus.Changeable, ...
      'h', ParameterStatus.Changeable, 'beta', ParameterStatus.Changeable);
    components = {'activation', 'output', 'h','peakY','peakX'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    size = [1, 1];
    tau = 10;
    h = -5;
    beta = 4;
    
    
    % accessible structures
    peakY
    peakX
    activation
    output
  end
  
  methods
    % constructor
    function obj = ModifiedNeuralField(label, size, tau, h, beta)
      if nargin > 0
        obj.label = label;
        obj.size = size;
      end
      if nargin >= 3
        obj.tau = tau;
      end
      if nargin >= 4
        obj.h = h;
      end
      if nargin >= 5
        obj.beta = beta;
      end
      
      
      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSL>
      input = 0;
      for i = 1 : obj.nInputs
        input = input + obj.inputElements{i}.(obj.inputComponents{i});
      end
      obj.activation = obj.activation + deltaT/obj.tau * (- obj.activation + obj.h + input);
      obj.output = sigmoid(obj.activation, obj.beta, 0);
      [obj.peakY,obj.peakX]=find(max(max(obj.output)));
      if ~isscalar(obj.peakY)&& ~isempty(obj.peakY) && ~isnan(obj.peakY)
           obj.peakY=obj.peakY(1,1);
           obj.peakX=obj.peakX(1,1);
      end
    end
    
    
    % intialization
    function obj = init(obj)
      obj.activation = zeros(obj.size) + obj.h;
      obj.output = sigmoid(obj.activation, obj.beta, 0);
      obj.peakY=0;
      obj.peakX=0;
      
      
    end
  end
end


