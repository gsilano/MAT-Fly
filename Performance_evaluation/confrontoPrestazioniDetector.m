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
% Starting from the images acquired from the virtual environment (both
% positive and negative), the script makes in output the mat files (it
% contains the ROI of the object to detect) needed to synthesis the
% classifier.

clear all
close all
clc

%%                                                                  SCRIPT PARAMETERS

% Font size into the subplots
captionFontSize = 14;

% The date. It is used to distinguish the simulation results
experimentDate = '20170521_1717';

% The folder that contains the test images
testImages = 'testImages';
framesDataExtension = '.tif';

%Folder containing the detectors (XML files)
pathXMLDetector = 'XMLDetector';
detectorFileExtension = '.xml';

% List of the detector contained into the folder
detectorNames = dir(pathXMLDetector);

 
%%                                                                  RAPPRESENTAZIONE

% The number of images contained into the test images folder
D_testImages = dir([testImages, '\*', framesDataExtension]);
numberOfTestImages = length(D_testImages(not([D_testImages.isdir])));

% Number of detector contained into the folder
D_detector = dir([pathXMLDetector, '\*', detectorFileExtension]);
detectorNumber = length(D_detector(not([D_detector.isdir])));

% Folder that will contain the detector outputs
pathDetectorOutputs =  strcat('FigureForPerformanceEvaluation_' , experimentDate);
% Sub folder needed for the evaluation process
if ~(exist(pathDetectorOutputs, 'dir'))
     mkdir(pathDetectorOutputs);
end

% The number of rows and columns contained for the subplot
columnsSubPlot = 4;
rowSubPlots = round((detectorNumber+1)/columnsSubPlot); % The detector of the conference paper is employed for performance evaluation (CCA2016)

for i = 1 : numberOfTestImages
    
    % Image reading
    testImageName = strcat(testImages, '\test_', num2str(i), framesDataExtension);
    img = imread(testImageName);

    %Subplot: row, columns, element
    figure_subplot = figure();
    subplot(rowSubPlots, columnsSubPlot, 1);
    imshow(testImageName);
    % The size of figure are normalized into the window
    set(gcf, 'units', 'normalized', 'outerposition',[0 0 1 1]); 
    % Force the image drawing to show step by step the detection results
    drawnow;
    caption = sprintf('Test Images');
    title(caption, 'FontSize', captionFontSize);
    axis image; % In order to avoid modifies due to ratio aspect of the window
    
    % First detector
    for j = 1 : detectorNumber
        
        pathFile = strcat(pathXMLDetector, '\', detectorNames(j+2).name);
        detector = vision.CascadeObjectDetector(pathFile);
        bbox = step(detector, img);
        detectedImg = insertObjectAnnotation(img, 'rectangle', bbox,'car');
        subplot(rowSubPlots, columnsSubPlot, j+1);
        imshow(detectedImg);
        detectedImage = strrep(detectorNames(j+2).name, 'carDetector_virtual_world_', '');
        caption = strrep(detectedImage,'_',' ');
        title(caption, 'FontSize', captionFontSize);
        axis image
    
    end
    
    % Figure saving
    figureName = strcat('comparingFigureTest_', num2str(i), '.fig');
    savefig(figure_subplot, figureName);
    movefile(figureName, pathDetectorOutputs);

end