%% ModifiedImageLoader 
% Adapted from the ImageLoader of COSIVINA toolbox.
% The element loads images from a file and switches between them.
% Modified version also provides inputs to the other elements in MainCode.m


classdef ModifiedImageLoader < Element
    
    properties (Constant)
        parameters = struct('fileNames', ParameterStatus.Fixed, 'size', ParameterStatus.Fixed, ...
            'currentSelection', ParameterStatus.InitRequired);
        components = {'image','imageRed','imageGreen','inputForRed','inputForGreen','sumOfRed','sumOfGreen'};
        defaultOutputComponent = 'image';
    end
    
    properties
        % parameters
        filePath = '';
        fileNames = {};
        size = [1, 1];
        currentSelection = 1;

        % accessible structures
        image
        imageRed
        imageGreen
        inputForRed
        inputForGreen
        sumOfRed
        sumOfGreen
        
    end
    
    methods
        % constructor
        function obj = ModifiedImageLoader(label, filePath, fileNames, imageSize, currentSelection)
            if nargin > 0
                obj.label = label;
                obj.fileNames = fileNames;
                if ~iscell(obj.fileNames)
                    obj.fileNames = cellstr(obj.fileNames);
                end
                obj.size = imageSize;
            end
            if nargin >= 5
                obj.currentSelection = currentSelection;
                
            end
            
            for i = 1 : numel(obj.fileNames)
                obj.fileNames{i} = fullfile(filePath, obj.fileNames{i});
            end
        end
        
        
        % step function
        function obj = step(obj, time, deltaT) %#ok<INUSD>
            
            
            obj.image = imread(obj.fileNames{obj.currentSelection});
            
            
            obj.imageRed=obj.image(:,:,1);
            obj.imageGreen=obj.image(:,:,2);
            obj.sumOfRed=sum(sum(obj.imageRed));
            obj.sumOfGreen=sum(sum(obj.imageGreen));
            
            %Calculate the inputs for the uRed and uGreen
            Coeff=5.446623093681918e-04;
            
            obj.inputForGreen=Coeff.*obj.sumOfRed;
            obj.inputForRed=Coeff.*obj.sumOfGreen;
            
        end
        
        
        % initialization
        function obj = init(obj)
            if mod(obj.currentSelection, 1) == 0 && obj.currentSelection > 0 && obj.currentSelection <= numel(obj.fileNames)
                obj.image = imread(obj.fileNames{obj.currentSelection});
                obj.image(:,:,1)=zeros(obj.size(1));
                obj.image(:,:,2)=zeros(obj.size(1));
                obj.image(:,:,3)=zeros(obj.size(1));
                obj.imageRed=obj.image(:,:,1);
                obj.imageGreen=obj.image(:,:,2);
                obj.sumOfRed=sum(sum(obj.imageRed));
                obj.sumOfGreen=sum(sum(obj.imageGreen));
                %Calculate the inputs for the uRed and uGreen
                Coeff=5.446623093681918e-04;
                
                obj.inputForGreen=Coeff.*obj.sumOfRed;
                obj.inputForRed=Coeff.*obj.sumOfGreen;
                
                
            end
        end
        
    end
end


