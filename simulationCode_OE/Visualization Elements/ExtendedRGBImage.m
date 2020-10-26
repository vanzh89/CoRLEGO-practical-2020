%% ExtendedRGBImage (COSIVINA toolbox)
% Adapted from RGBImage visualization element of COSIVINA.
% This is used in the simulation to visualize hand trajectories.
% It combines imshow and plot functions of MATLAB.
% Basicly, it plots the hand trajectory over the target image.


classdef ExtendedRGBImage < Visualization
    properties
        imageElementHandle
        imageElementLabel
        imageComponent
        
        plotElementHandleX
        plotElementHandleY
        plotElementLabel
        plotComponentX
        plotComponentY
          
        plotHandle
        plotProperties
        
        axesHandle
        axesProperties
              
        imageHandle
        imageProperties
        
        title = '';
        xlabel = '';
        ylabel = '';
        
        titleHandle = 0;
        xlabelHandle = 0;
        ylabelHandle = 0;
    end
    
    methods
        % Constructor
        function obj = ExtendedRGBImage(imageElement, imageComponent, plotElement, plotComponentX, plotComponentY,...
                axesProperties,imageProperties,plotProperties,title, xlabel, ylabel, position)
            
            obj.imageElementLabel = imageElement;
            obj.imageComponent = imageComponent;
            obj.plotElementLabel = plotElement;
            obj.plotComponentX = plotComponentX;
            obj.plotComponentY = plotComponentY;
            obj.axesProperties = {};
            obj.imageProperties = {};
            obj.plotProperties = {};
            obj.position = [];
            obj.axesHandle = 0;
            obj.imageHandle = 0;
            obj.plotHandle =0;
            
            
            if nargin >= 6
                obj.axesProperties = axesProperties;%axesProperties
            end
            if nargin >= 7
                obj.imageProperties = imageProperties;
            end
            if nargin >= 8
                obj.plotProperties = plotProperties;%plotProperties
            end
           
            if nargin >= 9 && ~isempty(title)
                obj.title = title;
            end
            if nargin >= 10 && ~isempty(xlabel)
                obj.xlabel = xlabel;
            end
            if nargin >= 11 && ~isempty(ylabel)
                obj.ylabel = ylabel;
            end
            if nargin >= 12
                obj.position = position;
            end
        end
        
        
        % connect to simulator object
        function obj = connect(obj, simulatorHandle)
            if simulatorHandle.isElement(obj.imageElementLabel)
                obj.imageElementHandle = simulatorHandle.getElement(obj.imageElementLabel);
                if ~obj.imageElementHandle.isComponent(obj.imageComponent) ...
                        && ~obj.imageElementHandle.isParameter(obj.imageComponent)
                    error('ExtendedRGBImage:connect:invalidComponent', 'Invalid component %s for element %s in simulator object.', ...
                        obj.imageComponent, obj.imageElementLabel);
                end
            else
                error('ExtendedRGBImage:connect:elementNotFound', 'No element %s in simulator object.', obj.imageElementLabel);
            end
            
            
            if simulatorHandle.isElement(obj.plotElementLabel)
                obj.plotElementHandleX = simulatorHandle.getElement(obj.plotElementLabel);
                if ~obj.plotElementHandleX.isComponent(obj.plotComponentX) ...
                        && ~obj.plotElementHandleX.isParameter(obj.plotComponentX)
                    error('ExtendedRGBImage:connect:invalidComponent', 'Invalid component %s for element %s in simulator object.', ...
                        obj.plotComponentX, obj.plotElementLabel);
                end
            else
                error('ExtendedRGBImage:connect:elementNotFound', 'No element %s in simulator object.', obj.plotElementLabel);
            end
            
            
            if simulatorHandle.isElement(obj.plotElementLabel)
                obj.plotElementHandleY = simulatorHandle.getElement(obj.plotElementLabel);
                if ~obj.plotElementHandleY.isComponent(obj.plotComponentY) ...
                        && ~obj.plotElementHandleY.isParameter(obj.plotComponentY)
                    error('ExtendedRGBImage:connect:invalidComponent', 'Invalid component %s for element %s in simulator object.', ...
                        obj.plotComponentY, obj.plotElementLabel);
                end
            else
                error('ExtendedRGBImage:connect:elementNotFound', 'No element %s in simulator object.', obj.plotElementLabel);
            end
        end
        
        
        % initialization
        function obj = init(obj, figureHandle)
            obj.axesHandle = axes('Parent', figureHandle, 'Position', obj.position);
                       
            obj.imageHandle = image(obj.imageElementHandle.(obj.imageComponent), 'Parent', obj.axesHandle, ...
                obj.imageProperties{:});
            hold on;
            obj.plotHandle=plot(obj.plotElementHandleX.(obj.plotComponentX),obj.plotElementHandleY.(obj.plotComponentY),'Parent',obj.axesHandle,...
                obj.plotProperties{:});
            
            if ~isempty(obj.axesProperties)
                set(obj.axesHandle, obj.axesProperties{:});
            end
            
            if ~isempty(obj.title)
                obj.titleHandle = title(obj.axesHandle, obj.title); %#ok<CPROP>
            end
            if ~isempty(obj.xlabel)
                obj.xlabelHandle = xlabel(obj.axesHandle, obj.xlabel); %#ok<CPROP>
            end
            if ~isempty(obj.ylabel)
                obj.ylabelHandle = ylabel(obj.axesHandle, obj.ylabel); %#ok<CPROP>
            end
        end
        
        
        % update
        function obj = update(obj)
            set(obj.imageHandle, 'CData', obj.imageElementHandle.(obj.imageComponent));
            xdata = get(obj.plotHandle, 'XData');  
            ydata = get(obj.plotHandle, 'YData');
            set(obj.plotHandle, 'XData', [xdata, obj.plotElementHandleX.(obj.plotComponentX)], 'YData', [ydata, obj.plotElementHandleY.(obj.plotComponentY)]);
        end
        
    end
    
end