
%% CORLEGO practical project 2020
% adpated from MSc CNCR Thesis:A Dynamic Neural Architecture for Choice Reaching Tasks
% Code for the simulation of the experiment, GUI part removed
clear all;
close all;
clc;
%Pick the image for target selection
currentFolder = pwd;
selpath = uigetdir(pwd);
%randperm()
imageNames={'redTargetOnTheLeft.png',...
    'redTargetInTheMiddle.png','redTargetOnTheRight.png','greenTargetOnTheLeft.png',...
    'greenTargetInTheMiddle.png','greenTargetOnTheRight.png','NoTargetImage.png'};

fieldSize=[30 , 30];
currentSelection = 1; %

%% setting up the simulator
connectionValue = -2; %Amplitude for connections can be different for each one
historyDuration = 100;
samplingRange = [-10, 10];
samplingResolution = 0.05;
tStimOn=0;

sigmaInhY = 10;
sigmaInhX = 10;
amplitudeInh_dv = 0.8;
sigmaExcY = 5;
sigmaExcX = 5;
amplitudeExc = 5;

amplitudeGlobal_dd=-0.01;
amplitudeGlobal_dv=-0.005;
i=1;
sim = Simulator();




sim.addElement(ModifiedImageLoader('targetImage',[selpath],imageNames,fieldSize,currentSelection));
sim.init();

% For tunning, input parameters can be controlled by sliders

sim.addElement(SingleNodeDynamics('nodeRed', 10, -5, 4, 1, 0.2, samplingRange, samplingResolution), 'targetImage','inputForRed');
sim.addElement(SingleNodeDynamics('nodeGreen', 10, -5, 4, 1, 0.2, samplingRange, samplingResolution), 'targetImage','inputForGreen');


sim.addElement(Preprocessing('preprocessing'));
sim.addConnection('targetImage','imageRed','preprocessing');
sim.addConnection('targetImage','imageGreen','preprocessing');
sim.addConnection('nodeRed','output','preprocessing');
sim.addConnection('nodeGreen','output','preprocessing');

sim.addElement(NeuralField('targetLocationMap', fieldSize, 20, -1, 4));
sim.addConnection('preprocessing','output','targetLocationMap');

threshold=-5;

sim.addElement(ModifiedHand2D('hand', fieldSize, 15,15, (-1*threshold), fieldSize(:,1)/2, fieldSize(:,2)/2));

sim.addElement(ModifiedGaussStimulus2D('fixedStimuli', fieldSize, 15, 15, (-1*threshold), fieldSize(:,1)/2, fieldSize(:,2)/2));
sim.addElement(ModifiedConvolution('handTargetDifferenceMap', fieldSize , 1 ,0,9.3), {'hand', 'targetLocationMap'},{'output','output'});

% add d field

sim.addElement(NeuralField('field d', fieldSize, 20, threshold, 4),{'fixedStimuli','handTargetDifferenceMap'},{'output','output'});
sim.addElement(ModifiedNeuralField('velocityMap', fieldSize, 5, (threshold+4.8), 4));


% there is no local inhibition from d to d
sim.addElement(LateralInteractions2D('d -> d', fieldSize, sigmaExcY,sigmaExcX, amplitudeExc, sigmaInhY, sigmaInhX, 0, amplitudeGlobal_dd), 'field d', 'output', 'field d');
sim.addElement(LateralInteractions2D('d -> v', fieldSize, sigmaExcY,sigmaExcX, amplitudeExc, sigmaInhY, sigmaInhX, amplitudeInh_dv, amplitudeGlobal_dv), 'field d', 'output', 'velocityMap');

sim.addElement(NormalNoise('noise u', fieldSize, 1));
sim.addElement(GaussKernel2D('noise kernel u', fieldSize, 5, 5, 0.2, true, true), 'noise u', 'output', 'field d');
sim.addElement(NormalNoise('noise v', fieldSize, 1));
sim.addElement(GaussKernel2D('noise kernel v', fieldSize, 5, 5, 0.2, true, true), 'noise v', 'output', 'velocityMap');


sim.addElement(ScaleInput('c_21', [1, 1]), 'nodeRed', 'output', 'nodeGreen');
sim.addElement(ScaleInput('c_12', [1, 1]), 'nodeGreen', 'output', 'nodeRed');


sim.addElement(RunningHistory('historyRedNodeActivation', [1, 1], historyDuration, 1), 'nodeRed', 'activation');
sim.addElement(RunningHistory('historyRedNodeOutput', [1, 1], historyDuration, 1), 'nodeRed', 'output'); % This added
sim.addElement(RunningHistory('historyGreenNodeActivation', [1, 1], historyDuration, 1), 'nodeGreen', 'activation');
sim.addElement(RunningHistory('historyGreenNodeOutput', [1, 1], historyDuration, 1), 'nodeGreen', 'output');

sim.addElement(SumInputs('shiftedStimulusRed', [1, 1]), {'targetImage', 'nodeRed'}, {'inputForRed', 'h'});
sim.addElement(SumInputs('shiftedStimulusGreen', [1, 1]), {'targetImage', 'nodeGreen'}, {'inputForGreen', 'h'});

sim.addElement(RunningHistory('stimulusHistoryRed', [1, 1], historyDuration, 1), 'shiftedStimulusRed');
sim.addElement(RunningHistory('stimulusHistoryGreen', [1, 1], historyDuration, 1), 'shiftedStimulusGreen');

% ManyPeaksInVmap=0;
setSize=7; %6 different target image
numberOfSet=1; %it is changeable

historyOfOrder=zeros(numberOfSet,setSize);
breakImage=7; %7th image is a black image
rateConstant=0.005;
trialTime=1250;
breakTime=1;
numberOfTrial=numberOfSet*setSize;
handVelocity=zeros(trialTime,numberOfTrial);
handPositionY=zeros(trialTime,numberOfTrial);
handPositionX=zeros(trialTime,numberOfTrial);
initialLatencyTime=zeros(numberOfTrial,1);
movementTime=zeros(numberOfTrial,1);
totalTime=zeros(numberOfTrial,1);

sim.init();
% gui.init();

for nOS=1:numberOfSet
    currentOrder=randperm(setSize);
    historyOfOrder(nOS,:)=currentOrder;
    currentOrder=[1 2 3 4 5 6 1];
    
    for sS=1:setSize %sS stands for the set size
        
        currentSelection=currentOrder(sS);
        sim.setElementParameters('targetImage','currentSelection',currentSelection);
        initialLatencyWasMesured=false;
        trialIsDone=false;
        sim.t=0;
        for tT=1:trialTime
            
            sim.step();
            velocity=sim.getComponent('velocityMap','output');
            
            if any(velocity(:)>0.5)
                [rowPeakV,colPeakV]=find(velocity == max(velocity(:)));
                
                
                handPositionY(tT,setSize*(nOS-1)+sS)=sim.getComponent('hand','positionY');
                handPositionX(tT,setSize*(nOS-1)+sS)=sim.getComponent('hand','positionX');
                sim.setElementParameters('hand','positionY',(handPositionY(tT,setSize*(nOS-1)+sS)+((rowPeakV-fieldSize(:,2)/2)*rateConstant)));
                sim.setElementParameters('hand','positionX',(handPositionX(tT,setSize*(nOS-1)+sS)+((colPeakV-fieldSize(:,1)/2)*rateConstant)));
                sim.setElementParameters('hand','rowPeakV',rowPeakV);
                sim.setElementParameters('hand','colPeakV',colPeakV);
                
                handVelocity(tT,setSize*(nOS-1)+sS)=sqrt(((rowPeakV-fieldSize(:,2)/2)*rateConstant)^2 +((colPeakV-fieldSize(:,1)/2)*rateConstant)^2);
                sim.setElementParameters('hand','velocity',handVelocity(tT,setSize*(nOS-1)+sS));
                
                if handVelocity(tT,setSize*(nOS-1)+sS)>0.02 && ~initialLatencyWasMesured
                    initialLatencyTime(setSize*(nOS-1)+sS)=sim.t;
                    initialLatencyWasMesured=true;
                end
                
                if handVelocity(tT,setSize*(nOS-1)+sS)<=0.000001 && ~trialIsDone && initialLatencyWasMesured && (handPositionY(tT,setSize*(nOS-1)+sS)<35)
                    movementTime(setSize*(nOS-1)+sS)= (sim.t) - initialLatencyTime(setSize*(nOS-1)+sS);
                    totalTime(setSize*(nOS-1)+sS)=sim.t;
                    trialIsDone=true;
                    break;
                end
            end
%             gui.updateVisualizations();
            pause(0);
            
        end
        %Small break initilazation
        
        sim.setElementParameters('targetImage','currentSelection',breakImage);
        sim.setElementParameters('hand','positionY',fieldSize(:,2)/2);
        sim.setElementParameters('hand','positionX',fieldSize(:,1)/2);
        
        
        for bT= 1:breakTime  % It controls colour priming
            
            sim.step();
            
%             gui.updateVisualizations();
            pause(0);
        end
        
        
    end
    
end

reorederedHistory=[1 2 3 4 5 6 1];
for i=2:numberOfSet
    reorederedHistory=horzcat(reorederedHistory,historyOfOrder(i,:));
end


for sS= 1:numberOfTrial
    figure(4), subplot(numberOfTrial,2,2*sS-1),imshow(imageNames{1,reorederedHistory(sS)}); hold on, plot(handPositionX(:,sS),handPositionY(:,sS),'*'); hold off;
    subplot(numberOfTrial,2,2*sS), plot(handVelocity(:,sS));
end