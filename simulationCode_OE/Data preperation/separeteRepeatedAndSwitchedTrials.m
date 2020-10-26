%% Seperate Repeated and Switched Target Colour Trials

% The code also plots the average velocities for the both type trials
% 1,2,3 image numbers have same colour target (green) and 4,5,6 (red)

clc,clear all,close all;
historyOfOrder=load('historyOfOrder_12.mat');
handPosX=load('handPositionX_12.mat');
handPosY=load('handPositionY_12.mat');
initialLatency=load('initialLatencyTime_12.mat');
movementTime=load('movementTime_12.mat');
totalTime=load('totalTime_12.mat');
handVelocity=load('handVelocity_12.mat');

historyOfOrder=struct2array(historyOfOrder);
handPosX=struct2array(handPosX);
handPosY=struct2array(handPosY);
initialLatency=struct2array(initialLatency);
movementTime=struct2array(movementTime);
totalTime=struct2array(totalTime);
handVelocity=struct2array(handVelocity);

numberOfChangedTrials=67; % This can be different for each experiment
numberOfRepeatedTrials=52; % This can be different for each experiment

setNumber=20;

reOrderedHistory=historyOfOrder(1,:);

for i=2:setNumber
    reOrderedHistory=horzcat(reOrderedHistory,historyOfOrder(i,:));
end

rOH=reOrderedHistory;
i=1;
% First Find the repeated trials
for Img=1:length(reOrderedHistory)-1
    if ((rOH(Img)==1||rOH(Img)==2||rOH(Img)==3) &&...
            (rOH(Img+1)==1||rOH(Img+1)==2||rOH(Img+1)==3))||...
            ((rOH(Img)==4||rOH(Img)==5||rOH(Img)==6) &&...
            (rOH(Img+1)==4||rOH(Img+1)==5||rOH(Img+1)==6))
        repeatedTrialIndex(i)=Img+1;
        i=i+1;
        
    end
    
    
end

%Remove the repeated trials and the first trial get the changed trials
totalTrials=1:120;
totalTrials(repeatedTrialIndex)=[];
changedTrialIndex=totalTrials;
changedTrialIndex(1)=[];
% Data of the changed target colour
changedHandPosX=handPosX(:,changedTrialIndex);
changedHandPosY=handPosY(:,changedTrialIndex);
changedInitialLatency=initialLatency(changedTrialIndex);
changedMovementTime=movementTime(changedTrialIndex);
changedTotalTime=totalTime(changedTrialIndex);
changedVelocity=handVelocity(:,changedTrialIndex);
sumOfChangedVelocity=sum(changedVelocity')./numberOfChangedTrials;
% Data of the repeated target colour

repeatedHandPosX=handPosX(:,repeatedTrialIndex);
repeatedHandPosY=handPosY(:,repeatedTrialIndex);
repeatedInitialLatency=initialLatency(repeatedTrialIndex);
repeatedMovementTime=movementTime(repeatedTrialIndex);
repeatedTotalTime=totalTime(repeatedTrialIndex);
repeatedVelocity=handVelocity(:,repeatedTrialIndex);
sumOfRepeatedVelocity=sum(repeatedVelocity')./numberOfRepeatedTrials;


figure(3)
plot(sumOfChangedVelocity,'g','LineWidth',3), hold on;plot(sumOfRepeatedVelocity,'b','LineWidth',3);
title('Hand Velocity','FontSize',20);xlabel('time step','FontSize',15);ylabel('Velocity pixel/step','FontSize',15);


