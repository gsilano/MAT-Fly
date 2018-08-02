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

%%                                                          FRAMES ACQUIRING AND COMPUTING

% The frames are aqcuired and computed in order to detect and recognize the
% car into the scenario

% Each frame is distinguished from the other by using a name, in particular
% the variable k
frameName = strcat('screenCaptured_', num2str(k), '.tif');

% From the matrix extracted by the Simulink scheme is created an image and saved
% into a suitable file
imagine_virtual_world = image(:,:,:,end);
imwrite(imagine_virtual_world, frameName);

% The image is moved into a specific folder. If such folder does not exist,
% it is made
imageFolder = 'Acquisition';
if ~(exist(imageFolder, 'dir'))
  mkdir(imageFolder);
end
movefile(frameName, imageFolder);

% The image is computed in order to detect the target: the car
detector = vision.CascadeObjectDetector(detectorName);

% The image is read from the file
posizioneImg = strcat(imageFolder, '\', frameName);
img = imread(posizioneImg);

% If it is the first cycle or the car has been partially covered, the
% detection algorithm is employed with respect to the tracking one
if(first_cycle)
    bbox = step(detector,img);
end

% The car is not recognized inside the frame, the drone does not change its
% position and attitude. Thus, the image computing does not start.
if(size(bbox,1) > 0)

    if(first_cylce)
        % The bounding boxes are added to the image
        detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'carDetected');

        % Naming detected frame
        nameFrameDetected = strcat('carDetected_', num2str(k), '.tif');

        % The image is saved on file together with the bounding boxes
        imwrite(detectedImg, nameFrameDetected);
        movefile(nameFrameDetected, imageFolder);

        % The variables used to search the maximum bounding box are
        % initialized
        with_max = 0;
        height_max = 0;

        % The maximum bounding box is found by using such for cycle
        for i = 1 : size(bbox,1)

            if(with_max < bbox(i,3) && height_max < bbox(i,4))

                x_max = bbox(i,1);
                y_max = bbox(i,2);
                with_max = bbox(i,3);
                height_max = bbox(i,4);

            end

        end

        % The information related to the maximum bounding boxes size are
        % put into a vector
        bbox_max = [x_max y_max with_max height_max];

        % The CAM Shift tracking algorithm is employed
        [hueChannel,~,~] = rgb2hsv(img);
        tracker = vision.HistogramBasedTracker;
        initializeObject(tracker, hueChannel, [x_max+with_max y_max+height_max/2 54 38]); % Such number has been found in a empirical way

    else

        % If the detection is not required (the car has been already
        % detected) the tracking algorithm is employed to obtain information
        % about the car
        [hueChannel,~,~] = rgb2hsv(img);
        bbox_max = step(tracker, hueChannel);
        
    end


    % The final (maximum) bounding box is added on the image
    detectedImg_max = insertObjectAnnotation(img, 'rectangle', bbox_max, 'carDetected');

    % Naming the computed frame
    nameFrameDetected_max = strcat('carDetectedMax_', num2str(k), '.tif');

    % The frame is saved on a file
    imwrite(detectedImg_max, nameFrameDetected_max);
    movefile(nameFrameDetected_max, imageFolder);

    % The frames produced during the tracking algorithm procedure are also
    % saved
    nameFrameDetected_hueChannel = strcat('hueChannel_', num2str(k), '.tif');

    % The image in HSV space is also saved
    imwrite(hueChannel, nameFrameDetected_hueChannel);
    movefile(nameFrameDetected_hueChannel, imageFolder);

    %%                                                                  DATA EXTRACTION

    % The the function bbox2point the bounding box coordinates are obtained
    matrix_edges = bbox2points(bbox_max);

    % For more information take at the relative section into the paper
    x_bb = bbox_max(1,1);           %Horizontal distnace, bbox_max = [x, y, width, height]
    y_bb = bbox_max(1,2);           %Vertial distance, bbox_max = [x, y, width, height]

    % Width and height of the target covered by the bounding box
    w_bb = bbox_max(1,3);  %bbox_max = [x, y, width, height]
    h_bb = bbox_max(1,4);

    % The centroid coordinates of the bounding box
    x_centroid_bounding_box = x_bb + (w_bb/2);
    y_centroid_bounding_box = y_bb + (h_bb/2);

    % The centroid coordinates of the image
    x_centroid_img = w_im/2;
    y_centroid_img = h_im/2;

    % The two image centroids are inserted on the image
    figure_1 = figure();
    movegui(figure_1, [50 50]);
    imshow(detectedImg_max);
    hold on
    set(figure_1, 'Position', [50 50 576 631]);
    plot(x_centroid_img, y_centroid_img, 'yx', 'MarkerSize', 10, 'LineWidth', 4);

    % Boundin box centroid
    plot(x_centroid_bounding_box, y_centroid_bounding_box, 'gx', 'MarkerSize', 10, 'LineWidth', 4);

    % The arrow between the two centroid is inserted on the image
    length_bounding_box = length(x_bb + w_bb/2 : 1 : w_im/2);

    % The if-else structure is needed because we do not know exactly the
    % image centroids position with respect to the bounding box one
    if(length_bounding_box == 0)
        vector_bounding_box = x_bb + w_bb/2 : -1 : w_im/2;
    else
        vector_bounding_box = x_bb + w_bb/2 : 1 : w_im/2; 
    end

    f_vector_bounding_box = (((vector_bounding_box - (x_bb + w_bb/2)) / (w_im/2 - (x_bb + w_bb/2))) * (h_im/2 - (y_bb + (h_bb/2)))) + ...
                        y_bb + h_bb/2;

    pointDifferences = [x_centroid_bounding_box - x_centroid_img, y_centroid_bounding_box - y_centroid_img];
    quiver(x_centroid_img, y_centroid_img, pointDifferences(1,1), pointDifferences(1,2), 0, 'LineWidth', 1);
    hold off
    legend('Centroid IMG', 'Centroid BB', 'Distance vector');
    axis([0 600 0 800]);

    figureFolder = 'FileFigure';
    if ~(exist(figureFolder, 'dir'))
         mkdir(figureFolder);
    end

    %Salvo immagine su file .fig e .tif
    nameFrameVector = strcat('centroidsVector_', num2str(k), '.tif');
    nameFiguraVector = strcat('centroidsVector_', num2str(k), '.fig');
    F = getframe;
    [X,map] = frame2im(F);
    imwrite([X,map], nameFrameVector);
    savefig(figure_1, nameFiguraVector);
    close all
    movefile(nameFrameVector, imageFolder);
    movefile(nameFiguraVector, figureFolder);


%%                                                                  DRONE CONTROL

    % Matlab script in which the drone control algorithms are reported
    drone_control
    
end