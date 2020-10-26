% Convolution (COSIVINA toolbox)
%   Element to perform a convolution between two inputs. Either input may
%   be flipped to effectively compute a correlation.
%
% Constructor call:
% Convolution(label, outputSize, flipFirst, flipSecond,convolutionShape,handAmplitude)
%   label - element label
%   outputSize - size of the result of the convolution
%   flipFirst - flag indicating whether first input should be flipped
%   flipSecond - flag indicating whether second input should be flipped
%   convolutionShape - shape of the convolution (as in MATLAB function
%     conv2)
%   handAmplitude= to adjust amplitude of handTargetDifference map
%   amplitude (It is optional for a spesific use )

classdef ModifiedConvolution < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'flipInputs', ParameterStatus.Changeable, ...
      'handAmplitude',ParameterStatus.Changeable, 'shape', ParameterStatus.Fixed);
    components = {'output'};
    defaultOutputComponent = 'output';
    
    
    FlipNone = 0;
    FlipFirst = 1;
    FlipSecond = 2;
    FlipBoth = 3;
    
  end
  
  properties
    % parameters
    size = [1, 1];
    flipInputs = ModifiedConvolution.FlipNone;
    %handAmplitude=1;
    shape = 'same';
    
    % accessible structures
    output
    handAmplitude
  end

  
  methods
    % constructor
    function obj = ModifiedConvolution(label, outputSize, flipFirst, flipSecond,handAmplitude,convolutionShape)
      if nargin > 0
        obj.label = label;
        obj.size = outputSize;
      end
      if nargin >= 4
        if flipFirst
          obj.flipInputs = ModifiedConvolution.FlipFirst;
        elseif flipSecond
          obj.flipInputs = ModifiedConvolution.FlipSecond;
        end
        if flipFirst && flipSecond
          obj.flipInputs = ModifiedConvolution.FlipBoth;
        end
      end
      if nargin >= 5
        
        obj.handAmplitude = handAmplitude;
      end
      if nargin >= 6
        obj.shape = convolutionShape;
        
      end
           
      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      switch obj.flipInputs
        case ModifiedConvolution.FlipNone
          obj.output = conv2(obj.inputElements{1}.(obj.inputComponents{1}), ...
            obj.inputElements{2}.(obj.inputComponents{2}), obj.shape);
        case ModifiedConvolution.FlipFirst
          obj.output = conv2(rot90(obj.inputElements{1}.(obj.inputComponents{1}), 2), ...
            obj.inputElements{2}.(obj.inputComponents{2}), obj.shape);
        case ModifiedConvolution.FlipSecond
          obj.output = conv2(obj.inputElements{1}.(obj.inputComponents{1}), ...
            rot90(obj.inputElements{2}.(obj.inputComponents{2}), 2), obj.shape);
        case ModifiedConvolution.FlipBoth
          obj.output = rot90(conv2(obj.inputElements{1}.(obj.inputComponents{1}), ...
            obj.inputElements{2}.(obj.inputComponents{2}), obj.shape), 2);
      end
      obj.output= obj.handAmplitude*(obj.output)./max(max(obj.output));
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = zeros(obj.size);
    end

  end
end


