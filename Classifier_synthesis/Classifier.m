% Copyright 2018 Giuseppe Silano, University of Sannio in Benevento, Italy
% Copyright 2018 Luigi Iannelli, University of Sannio in Benevento, Italy
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%  

clear all
close all
clc

%%                                                                DETECTOR SYNTHESIS

% Date of the experiment
dateExperiment = '1415_20180727';
% Path folder containing the positive images
datePositiveIstances = '';

% Folder in which are contained the test images
testFolder = 'ImmaginiTest';
extensionTestImages = '.tif';

% False alarm probability (need to synthesize the classifier)
% for more information take a look at the help of the
% trainCascadeObjectDetector function
falseAllarm = 0.25;
cascadeStages = 10;
featureType = 'LBP'; %HOG, Haar, LBP

% Positive instance name
positiveIstancesName = strcat('positiveInstances_', datePositiveIstances, '.mat');
load(positiveIstancesName);
positiveInstances = structure; % Needed taking into account the file structure

% Folder in which are contained the negative images
negativeImagsFolder = strcat('Negative_', datePositiveIstances);
negativeFolder = fullfile(negativeImagsFolder);

% The commands reported below allow to obtain the xml file 'carDetector'
detectorName = strcat('carDetector_virtual_world_', dateExperiment, '.xml');
trainCascadeObjectDetector(detectorName, positiveInstances, negativeFolder, 'FalseAlarmRate', falseAllarm,'NumCascadeStages', cascadeStages, 'ObjectTrainingSize', 'Auto', 'FeatureType', featureType);

%%                                                                DETECTOR TESTING

% The detector is employed to recognize the car into the test images
detector = vision.CascadeObjectDetector(detectorName);

% In order to plot the detection results, the number of elements into the
% test folder is taken into account
D = dir([testFolder,'\*', extensionTestImages]);
numFile = length(D(not([D.isdir])));

recognizeImagesFolder =  strcat('recognizedImages_' , dateExperiment);
% If the folder does not exist, it is going to be created
if ~(exist(recognizeImagesFolder, 'dir'))
     mkdir(recognizeImagesFolder);
end

for i = 1 : numFile
    
    % In order to understand the detector performance
    testImagesName = strcat(testFolder, '\test_', num2str(i), extensionTestImages);
    img = imread(testImagesName);
    bbox = step(detector, img);
    detectedImg = insertObjectAnnotation(img, 'rectangle', bbox,'car');
    figure;
    recognizedImage = strcat('detectedImg_', num2str(i), '_', dateExperiment, '_', featureType, extensionTestImages);
    imwrite(detectedImg, recognizedImage);
    imgResized = imresize(detectedImg, 0.67);
    imshow(imgResized);
    movefile(recognizedImage, recognizeImagesFolder);
    
end


