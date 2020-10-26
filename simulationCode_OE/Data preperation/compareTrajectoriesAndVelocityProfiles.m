%% Plot Reaching Trajectories and velocity profiles
% This code plots the trajectories and velocity profiles for the first 18
% trials so that we can compare the results between trials.
%  "_12" suffex in the name of .mat files only refers to the date when
% the simulation was run.

clc,clear all,close all;

imageNames={'redTargetOnTheLeft.png',...
    'redTargetInTheMiddle.png','redTargetOnTheRight.png',...
    'greenTargetOnTheLeft.png','greenTargetInTheMiddle.png',...
    'greenTargetOnTheRight.png','NoTargetImage.png'};

historyOfOrder=load('historyOfOrder_12.mat');
historyOfOrder=struct2array(historyOfOrder);
[N M]=size(historyOfOrder);
sL=historyOfOrder;
setNumber=20; % All 6 combinations of images are shown 20 times in
%  random order.

reOrderedHistory=historyOfOrder(1,:);

for i=2:setNumber
    reOrderedHistory=horzcat(reOrderedHistory,historyOfOrder(i,:));
end

k=6; % the number of target image combinations

%Hand trajectories from the experiments
handPositionX=load('handPositionX_12.mat');
handPositionY=load('handPositionY_12.mat');
handVelocity=load('handVelocity_12.mat');
handPositionX=struct2array(handPositionX);
handPositionY=struct2array(handPositionY);
handVelocity=struct2array(handVelocity);

%figure('units','normalized','outerposition',[0 0 1 1])
figure(1)
for i=1:3  % 3 sets from the trials are shown
    
    subplot(3,6,i*k-5)
    imshow(imageNames{1,reOrderedHistory(i*k-5)}); hold on, ...
        plot(handPositionX(:,i*k-5),...
        handPositionY(:,i*k-5),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k-5),'FontSize',15);
    subplot(3,6,i*k-4)
    imshow(imageNames{1,reOrderedHistory(i*k-4)}); hold on,...
        plot(handPositionX(:,i*k-4),...
        handPositionY(:,i*k-4),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k-4),'FontSize',15);
    subplot(3,6,i*k-3)
    imshow(imageNames{1,5}); hold on, plot(handPositionX(:,i*k-3),...
        handPositionY(:,i*k-3),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k-3),'FontSize',15);
    subplot(3,6,i*k-2)
    imshow(imageNames{1,reOrderedHistory(i*k-2)}); hold on,...
        plot(handPositionX(:,i*k-2),...
        handPositionY(:,i*k-2),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k-2),'FontSize',15);
    subplot(3,6,i*k-1)
    imshow(imageNames{1,reOrderedHistory(i*k-1)}); hold on,...
        plot(handPositionX(:,i*k-1),...
        handPositionY(:,i*k-1),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k-1),'FontSize',15);
    subplot(3,6,i*k)
    imshow(imageNames{1,reOrderedHistory(i*k)}); hold on, ...
        plot(handPositionX(:,i*k),...
        handPositionY(:,i*k),'*','MarkerSize',2);
    title(sprintf('#%d. Trial',i*k),'FontSize',15);
    
end

figure(2)
for i=1:3 % 3 sets from the trials are shown
    
    subplot(3,6,i*k-5)
    plot(handVelocity(:,i*k-5));
    title(sprintf('#%d. Trial',i*k-5),'FontSize',15);
    subplot(3,6,i*k-4)
    plot(handVelocity(:,i*k-4));
    title(sprintf('#%d. Trial',i*k-4),'FontSize',15);
    subplot(3,6,i*k-3)
    plot(handVelocity(:,i*k-3));
    title(sprintf('#%d. Trial',i*k-3),'FontSize',15);
    subplot(3,6,i*k-2)
    plot(handVelocity(:,i*k-2));
    title(sprintf('#%d. Trial',i*k-2),'FontSize',15);
    subplot(3,6,i*k-1)
    plot(handVelocity(:,i*k-1));
    title(sprintf('#%d. Trial',i*k-1),'FontSize',15);
    subplot(3,6,i*k)
    plot(handVelocity(:,i*k));
    title(sprintf('#%d. Trial',i*k),'FontSize',15);
    
end

