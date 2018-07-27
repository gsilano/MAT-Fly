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
%
% The script is based on 
% https://it.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial
%
clear all
close all
clc

%%                                                         PARAMETERS RELATED TO THE POSITIVE IMAGES

% Name of the folder in which are contained the positive images
folderName = 'Positive_images';
date = '1415_20180727'; %Allows to distinguish the different tests
imageFileExstension = '.tif';

% Allows to count the images number
D = dir([folderName,'\*',imageFileExstension]);
numFile = length(D(not([D.isdir])));


%%                                                              ROI COMPUTING FROM THE IMAGES

% The timer allows to understand how many time has passed from the
% beginning to the end of the code
timeToROIExtraction = tic;
imtool close all;
format long g;
format compact;
captionFontSize = 14;

% The loop allows to measure the bounding box size for every image
errors = 0;
indexNoBlobsFigure = zeros(numFile,1);
figureNoBlobsNumber = 1;
for i = 1 : numFile
    
    close all % Close the windows before to open the new ones
    imageFileName = strcat(folderName, '\screenCaptured_', num2str(i), imageFileExstension);
    originalImageRGB = imread(imageFileName);
    
    % Before to measure the image size, they are converted in the RGB format
    % if them are expressed in a different way (e.g., gray scale)
    [rows, columns, numberOfColorChannels] = size(originalImageRGB);
    if numberOfColorChannels > 1
        % The images are converted by using the standard formula. Take a
        % look at the documentation of "rgb2gray"
        originalImage = rgb2gray(originalImageRGB);
    end
    
    % The histogram allows to discriminate the background from the foreground
    figure_1 = figure();
    movegui(figure_1, [50 50]);
    [pixelCount, grayLevels] = imhist(originalImage);
    bar(pixelCount);
    histogramFigureTitle = strcat('Histogram of original image_{', num2str(i),'}');
    title(histogramFigureTitle, 'FontSize', captionFontSize);
    xlim([0 grayLevels(end)]); % The x-axis is scaled in automatically way
    grid on;
    
    % Threshold the image to get a binary image (only 0's and 1's) of class "logical."
    % Method #1: using im2bw()
    %   normalizedThresholdValue = 0.4; % In range 0 to 1.
    %   thresholdValue = normalizedThresholdValue * max(max(originalImage)); % Gray Levels.
    %   binaryImage = im2bw(originalImage, normalizedThresholdValue);       % One way to threshold to binary
    % Method #2: using a logical operation.
    thresholdValue = 100;
    binaryImage = originalImage < thresholdValue;  % Bright objects will be chosen if you use >.
    % ========== IMPORTANT OPTION ============================================================
    % Use < if you want to find dark objects instead of bright objects.
    %   binaryImage = originalImage < thresholdValue; % Dark objects will be chosen if you use <.

    % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
    hold on;
    maxYValue = ylim;
    % Show the threshold as a vertical red bar on the histogram.
    line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
    % Place a text label on the bar chart showing the threshold.
    annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
    % For text(), the x and y need to be of the data class "double" so let's cast both to double.
    text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
    text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
    text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);
    hold off
    
    % Display the binary image.
    figure_2 = figure();
    movegui(figure_2, [50 50]);
    imshow(originalImage);
    caption = strcat('Binary Image, by original image_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize);
    
    % Every hole is filled
    binaryImage = imfill(binaryImage, 'holes');
    
    % The binary images obtained from the thresholding
    figure_3 = figure();
    movegui(figure_3, [50 50]);
    imshow(binaryImage);
    caption = strcat('Binary Image, obtained by thresholding_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize);
    
    % Identify individual blobs by seeing which pixels are connected to each other.
    % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
    % Do connected components labeling with either bwlabel() or bwconncomp().
    labeledImage = bwlabel(binaryImage, 8);    % Label each blob so we can make measurements of it
    % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
    figure_4 = figure();
    movegui(figure_4, [50 50]);
    imshow(labeledImage, []);   % Show the gray scale image.
    caption = strcat('Labeled Image, from bwlabel()_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize);
    
    % Let's assign each blob a different color to visually show the user the distinct blobs.
    coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
    % coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
    figure_5 = figure();
    movegui(figure_5, [50 50]);
    imshow(coloredLabels);
    axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
    caption = strcat('Pseudo colored labels, from label2rgb()_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize);
    
    % Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
    blobMeasurements = regionprops(labeledImage, originalImage, 'all');
    numberOfBlobs = size(blobMeasurements, 1);


	% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
    % Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
    figure_6 = figure();
    movegui(figure_6, [50 50]);
    imshow(originalImage);
    caption = strcat('Outlines, from bwboundaries()_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize); 
    axis image;  % Make sure image is not artificially stretched because of screen's aspect ratio.
    hold on;
    boundaries = bwboundaries(binaryImage);
    numberOfBoundaries = size(boundaries, 1);
    for k = 1 : numberOfBoundaries
        thisBoundary = boundaries{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
    end
    hold off;

    % Now, I'll show you another way to get centroids.
    % We can get the centroids of ALL the blobs into 2 arrays,
    % one for the centroid x values and one for the centroid y values.
    allBlobCentroids = [blobMeasurements.Centroid];
    centroidsX = allBlobCentroids(1:2:end-1);
    centroidsY = allBlobCentroids(2:2:end);
    labelShiftX = -7;	% It is used to center the labels into the object
    textFontSize = 14;	% It is used to control the blob size in the high part of the image
    % The label are put on the RGB image
    figure_7 = figure();
    movegui(figure_7, [50 50]);
    imshow(coloredLabels);
    for k = 1 : numberOfBlobs           % The loop runs for all the blobs
        text(centroidsX(k) + labelShiftX, centroidsY(k), num2str(k), 'FontSize', textFontSize, 'FontWeight', 'Bold');
    end

    
    % Starting from the found blobs, by using the size and the average
    % brightness, the ROI is automatically detected. The thresholds have 
    % obtained in a heuristic way. The area has to be greater than 10^5, 
    % while the brightness has been chosen the greatest of the blobs set.
    allBlobAreas = [blobMeasurements.Area];

    % Get a list of the blobs that meet our criteria and we need to keep.
    % These will be logical indexes- lists of true or false depending on whether the feature meets the criteria or not.
    % for example [1, 0, 0, 1, 1, 0, 1, .....].  Elements 1, 4, 5, 7, ... are true, others are false.
    allowableAreaIndexes = allBlobAreas > 10000 & allBlobAreas < 100000;  % Take the objects with a size similar to the car
    
    % Now let's get actual indexes, rather than logical indexes, of the  features that meet the criteria.
    % for example [1, 4, 5, 7, .....] to continue using the example from above.
    keeperIndexes = find(allowableAreaIndexes);
    
    % Extract only those blobs that meet our criteria, and
    % eliminate those blobs that don't meet our criteria.
    % Note how we use ismember() to do this.  Result will be an image - the same as labeledImage but with only the blobs listed in keeperIndexes in it.
    keeperBlobsImage = ismember(labeledImage, keeperIndexes);
    
    % Re-label with only the keeper blobs kept.
    labeledImage_selected = bwlabel(keeperBlobsImage, 8);     % Label each blob so we can make measurements of it
    
    % In the case that the number of the blobs is greater than 1, also the
    % brightness is taken into account
    lengthKeeperIndexes = length(keeperIndexes);
    if (lengthKeeperIndexes > 1)
        blobMeasurements_selected = regionprops(labeledImage_selected, originalImage, 'all');
        numberOfBlobs_selected = size(blobMeasurements_selected, 1);
        allBlobIntensities = [blobMeasurements_selected.MeanIntensity];
        allowableIntensityIndexes = max(allBlobIntensities);
        keeperIndexes_selected = find([blobMeasurements_selected.MeanIntensity]==allowableIntensityIndexes);
        keeperBlobsImage_selected = ismember(labeledImage_selected, keeperIndexes_selected);
        labeledImage_selected = bwlabel(keeperBlobsImage_selected, 8);     % Label each blob so we can make measurements of it
    end
    
    % Plot the image in which is depicted only the content of interest
    figure_8 = figure();
    movegui(figure_8, [50 50]);
    imshow(labeledImage_selected, []);
    axis image;
    caption = strcat('The final labeled image_{', num2str(i),'}');
    title(caption, 'FontSize', captionFontSize);

    % From the selected image is saved the ROI dimension
    blobMeasurement_final = regionprops(labeledImage_selected, originalImage, 'all');  
    
    % Plot the blob centroid in order to understand if the the car has been
    % detected or not
    blobMeasurements_selected = regionprops(labeledImage_selected, originalImage, 'all');
    numberOfBlobs = size(blobMeasurements_selected, 1);
    figure_9 = figure();
    movegui(figure_9, [50 50]);
    imshow(originalImageRGB);
    hold on
    for k = 1 : numberOfBlobs           % It can be removed if it is sure that the blob has been recognized
		% With the cross are highlighted the selected bounding box
    	plot(blobMeasurements_selected.Centroid(1,1), blobMeasurements_selected.Centroid(1,2), 'yx', 'MarkerSize', 10, 'LineWidth', 4);
        plot(300,400, 'bx', 'MarkerSize', 10, 'LineWidth', 4);
        caption = strcat('Centroid on original image_{', num2str(i),'}. In yellow the BB of blob, in blue the image centroid');
        title(caption, 'FontSize', captionFontSize);
    end
    hold off
    
    % To check if errors occur
    if (numberOfBlobs > 1)
        errors = errors + 1;
    end
     
    % The object of interest is cropped from the original image
    figure_10 = figure();
    movegui(figure_10, [50 50]);
    fileNameSubImageCroped = strcat('subImage_', num2str(i), '.tif');
	for k = 1 : numberOfBlobs           % It can be remove, the blob should be unique
        % Find the bounding box in the case there is more than one
		thisBlobsBoundingBox = blobMeasurements_selected(k).BoundingBox;  % A list of pixels of the current blob
		% A sub image is extracted taking into account the dimension of the
        % bounding box
		subImage = imcrop(originalImageRGB, thisBlobsBoundingBox);
		imshow(subImage);
        caption = strcat('Cropped sub image_{', num2str(i),'}');
		title(caption, 'FontSize', textFontSize);
        imwrite(subImage, fileNameSubImageCroped);
    end
    % Only if there are blobs, so if the image has been made
    if (numberOfBlobs>0)
        folderCropedSubImageView = 'cropedSubImageView';
        if ~(exist(folderCropedSubImageView, 'dir'))
            mkdir(folderCropedSubImageView);
        end
        movefile(fileNameSubImageCroped, folderCropedSubImageView);
    else   
        message = strcat('The image ', num2str(i), ' is not in the list');
        indexNoBlobsFigure(figureNoBlobsNumber, 1) = i; % Save the number of images for which the blobs have not been found. Such information is used in the mat file made in output
        figureNoBlobsNumber = figureNoBlobsNumber + 1;
    end
    
    % The figure file are saved and moved into a specific folder
    nameHistogramFigure = strcat('histogram_', num2str(i), '.fig');
    nameBinaryImage = strcat('binaryImage_', num2str(i), '.fig');
    nameBinaryImageTresholding = strcat('binaryImageThresholding_', num2str(i), '.fig');
    nameLabeledImage = strcat('labeledImage_', num2str(i), '.fig');
    nameLabeledImagePseudoColor = strcat('labeledImagePseudoColor_', num2str(i), '.fig');
    nameBoundariesImage = strcat('boundariesImage_', num2str(i), '.fig');
    nameRGBWithCentroids = strcat('rgbWithCentroids_', num2str(i), '.fig');
    nameLabeledImageSelected = strcat('labeledImageSelected_', num2str(i), '.fig');
    nameCentroidOnOriginalImage = strcat('centroidOnOriginalImage_', num2str(i), '.fig');
    nameCropedSubImage = strcat('cropedSubImage_', num2str(i), '.fig');
    
    nameFileBlobMeasurementFinal = strcat('nameFileBlobMeasurements_', num2str(i),'.mat'); 
    
    savefig(figure_1, nameHistogramFigure);
    savefig(figure_2, nameBinaryImage);
    savefig(figure_3, nameBinaryImageTresholding);
    savefig(figure_4, nameLabeledImage);
    savefig(figure_5, nameLabeledImagePseudoColor);
    savefig(figure_6, nameBoundariesImage);
    savefig(figure_7, nameRGBWithCentroids);
    savefig(figure_8, nameLabeledImageSelected);
    savefig(figure_9, nameCentroidOnOriginalImage);
    savefig(figure_10, nameCropedSubImage);
    
    save(nameFileBlobMeasurementFinal, 'blobMeasurement_final');
    
    folderNameFigureFile = 'figureFile';
    folderNameBinaryImage = 'binaryImage';
    folderNameBinaryImageThresholding = 'binaryImageThresholding';
    folderNameLabeledImage = 'labeledImage';
    folderNameLabeledImagePseudoColor = 'labeledImagePseudoColor';
    folderNameBoundariesImage = 'boundariesImage';
    folderNameRGBWithCentroids = 'rgbWithCentroids';
    folderNameLabeledImageSelected = 'labeledImageSelected';
    folderCentroidOnOriginalImage = 'centroidOnOriginalImage';
    folderCropedSubImage = 'cropedSubImage';
    folderBlobMeasurementFinal = 'blobMeasurementFinal';
    
    
    % The folders containing the data are created if they not exist
    if ~(exist(folderNameFigureFile, 'dir'))
        mkdir(folderNameFigureFile);
    end
    if ~(exist(folderNameBinaryImage, 'dir'))
        mkdir(folderNameBinaryImage);
    end
    if ~(exist(folderNameBinaryImageThresholding, 'dir'))
       mkdir(folderNameBinaryImageThresholding);
    end
    if ~(exist(folderNameLabeledImage, 'dir'))
        mkdir(folderNameLabeledImage);
    end
    if ~(exist(folderNameLabeledImagePseudoColor, 'dir'))
        mkdir(folderNameLabeledImagePseudoColor);
    end
    if ~(exist(folderNameBoundariesImage, 'dir'))
        mkdir(folderNameBoundariesImage);
    end
    if ~(exist(folderNameRGBWithCentroids, 'dir'))
        mkdir(folderNameRGBWithCentroids);
    end
    if ~(exist(folderNameLabeledImageSelected, 'dir'))
        mkdir(folderNameLabeledImageSelected);
    end
    if ~(exist(folderCentroidOnOriginalImage, 'dir'))
        mkdir(folderCentroidOnOriginalImage);
    end
    if ~(exist(folderCropedSubImage, 'dir'))
        mkdir(folderCropedSubImage);
    end
    if ~(exist(folderBlobMeasurementFinal, 'dir'))
        mkdir(folderBlobMeasurementFinal)
    end
    
    movefile(nameHistogramFigure, folderNameFigureFile);
    movefile(nameBinaryImage, folderNameBinaryImage);
    movefile(nameBinaryImageTresholding, folderNameBinaryImageThresholding);
    movefile(nameLabeledImage, folderNameLabeledImage);
    movefile(nameLabeledImagePseudoColor, folderNameLabeledImagePseudoColor);
    movefile(nameBoundariesImage, folderNameBoundariesImage);
    movefile(nameRGBWithCentroids, folderNameRGBWithCentroids);
    movefile(nameLabeledImageSelected, folderNameLabeledImageSelected);
    movefile(nameCentroidOnOriginalImage, folderCentroidOnOriginalImage);
    movefile(nameCropedSubImage, folderCropedSubImage);
    
    movefile(nameFileBlobMeasurementFinal, folderBlobMeasurementFinal);
end

% The percentage error of the non recognized frames
errorFigureNoBlobs = (figureNoBlobsNumber/numFile) * 100;
errorsPercentage = (errors/numFile) * 100;

% The info are displayed on the screen
display('');
display(strcat('Total number of figure:', num2str(numFile)));
display(strcat('Number of figure without blobs:', num2str(figureNoBlobsNumber)));
display(strcat('Percentage error:', num2str(errorFigureNoBlobs), '%'));
display(strcat('Number of images in which more than one ROI has been recognized:', num2str(errors)));
display(strcat('Percentage error of info above:', num2str(errorsPercentage)));

close all

%%                                                          THE FILE ARE SAVED INTO THE WORKSPACE


% In oder to synthesize the classifier an xml file is needed. Such file
% contains the path of each positive image and the bounding box size of ROI
% presented into, respectively.
structure = struct('imageFilename', [], 'objectBoundingBoxes', []);
lastValue = 1;
imagePath = 'Classifier_synthesis\PositiveImages_';
for i = 1: numFile
    
    structure(i).imageFilename = strcat(imagePath, date, '\screenCaptured_', num2str(i), '.tif');
    nameFileBlobMeasurementFinal = strcat(folderBlobMeasurementFinal, '\nameFileBlobMeasurements_', num2str(i),'.mat');
    load(nameFileBlobMeasurementFinal);
    % In the case that there are no blobs into the image, the blob found in the
    % image before is employed for the current image
    if isempty(blobMeasurement_final)
        nameFileBlobMeasurementFinal = strcat(folderBlobMeasurementFinal, '\nameFileBlobMeasurements_', num2str(lastValue),'.mat');
        load(nameFileBlobMeasurementFinal);
        structure(i).objectBoundingBoxes = blobMeasurement_final.BoundingBox;
    else
        structure(i).objectBoundingBoxes = blobMeasurement_final.BoundingBox;
        lastValue = i;
    end
end

% Finally, the .mat obtained mat file is saved and store into a suitable
% folder
nameFilePositiveInstances = strcat('positiveInstances_', date, '.mat');
save(nameFilePositiveInstances, 'structure');

% It allows to measure time elapsed
timeLapsed = toc(timeToROIExtraction);

% All the relevant data are stored into a suitable mat file
matFileName = strcat('informations_', date, '.mat');
save(matFileName, 'figureNoBlobsNumber', 'errorFigureNoBlobs', 'errors', 'errorsPercentage', 'indexNoBlobsFigure', 'timeLapsed');

