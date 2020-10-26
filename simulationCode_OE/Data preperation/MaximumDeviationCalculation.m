%Calculate the maximum deviation (MD)
clc,clear all;

changedHandPosX=load('changedHandPosX_12.mat');
changedHandPosY=load('changedHandPosY_12.mat');

changedHandPosX=struct2array(changedHandPosX);
changedHandPosY=struct2array(changedHandPosY);

repeatedHandPosX=load('repeatedHandPosX_12.mat');
repeatedHandPosY=load('repeatedHandPosY_12.mat');

repeatedHandPosX=struct2array(repeatedHandPosX);
repeatedHandPosY=struct2array(repeatedHandPosY);

maxDeviationHistoryForChanged=zeros(120,1);
maxDeviationHistoryForRepeated=zeros(120,1);

numberOfChangedTrials=67; % This can be different for each experiment
numberOfRepeatedTrials=52; % This can be different for each experiment

E=0.001; % A small number will be added to the yEnd and xEnd to make sure
% (yEnd - y1) and (xEnd-x1) are not zero so that we can create 
% a straight line (reference line) which has the same sample size with
% the trajectory to calculate the deviation.

for i=1:numberOfChangedTrials
    
    % Remove the location data before the hand located in the middle (60,60)
    handlePosX=changedHandPosX(:,i);
    handlePosX(handlePosX == 0)=[];
    
    handlePosY=changedHandPosY(:,i);
    handlePosY(handlePosY == 0)=[];
    
    % Create X and Y axises of the straight line
    strightLineX = (handlePosX(1):((handlePosX(end)+E)-handlePosX(1))/...
        (length(handlePosX)-1):(handlePosX(end)+E))';
    
    strightLineY = (handlePosY(1):((handlePosY(end)+E)-handlePosY(1))/...
        (length(handlePosY)-1):(handlePosY(end)+E))';
    
    % Calculate the distance between the points on the trajectory and the
    % points on the straight line.
    handleDeviation=sqrt((strightLineX-handlePosX).^2+...
        (strightLineY-handlePosY).^2);
    
    %Find the maximum deviation (max. the distance between the points)
    maxDeviationHistoryForChanged(i)=handleDeviation(handleDeviation==...
        max(handleDeviation));
    
end

for i=1:numberOfRepeatedTrials
    
    % Remove the location data before the hand located in the middle (60,60)
    handlePosX=repeatedHandPosX(:,i);
    handlePosX(handlePosX == 0)=[];
    
    handlePosY=repeatedHandPosY(:,i);
    handlePosY(handlePosY == 0)=[];
    
     % Create X and Y axises of the straight line
    strightLineX = (handlePosX(1):((handlePosX(end)+E)-handlePosX(1))/...
        (length(handlePosX)-1):(handlePosX(end)+E))';
    
    strightLineY = (handlePosY(1):((handlePosY(end)+E)-handlePosY(1))/...
        (length(handlePosY)-1):(handlePosY(end)+E))';
    
    % Calculate the distance between the points on the trajectory and the
    % points on the straight line.
    handleDeviation=sqrt((strightLineX-handlePosX).^2+...
        (strightLineY-handlePosY).^2);
    
    %Find the maximum deviation (max. the distance between the points)
    maxDeviationHistoryForRepeated(i)=handleDeviation(handleDeviation==...
        max(handleDeviation));
    
end
