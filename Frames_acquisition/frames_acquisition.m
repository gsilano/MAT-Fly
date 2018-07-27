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

%%                                                  THE PROCEDURE ALLOWS TO SELECT THE SCENARIO TO RUN

disp('Which scenario are you interested in?');
disp('');
disp('Below the options are reported'); 
disp('    (1) With the car'); 
disp('    (2) Without the car');

option = input('');

%%                                                         VIRTUAL ENVIRONMENT PARAMETERS

% The sphere radius, the distance between the car and the drone
radius=15; 

% Initial values of the frames index
k=1;

% Simulation step
sampleTime = 0.04;
simulationStop = 5.04; % To move the drone (camera) away from car

% The .mat file contains the car dyamics
load('test_lap.mat');

% The folder name in which the frames will be stored
folderName = 'Acquired_frame';

% Angles step size
anglesStepSize = pi/50;

% Take a look at Figure 6
beta = 0: anglesStepSize : pi/2;
alpha = 0 : anglesStepSize : 2*pi;


%%                                                           FRAMES ACQUIRING PROCEDURE


for i=1:length(beta)
    
    % The next value of drone (camera) position along the y-axis
    y_next = radius*cos(beta(i));
    
    for j = 1:length(alpha)
        
        % The next value of drone (camera) position along the x and z-axis
        x_next = radius*sin(beta(i))*sin(alpha(j));
        z_next = radius*sin(beta(i))*cos(alpha(j));
        
        % The vector contains the observer position
        observer_position = [0 z_next y_next x_next];
        
        % The drone (camera) attitude
        roll = (pi/2) - beta(i);
        pitch = (3*pi/2) + alpha(j);
        yaw = 0;
        
        % Rotation matrices
        R_z =[   cos(yaw)    sin(yaw)    0; 
                -sin(yaw)    cos(yaw)    0; 
                   0           0         1];
            
        R_y =[   cos(pitch)      0   -sin(pitch); 
                     0           1       0; 
                 sin(pitch)      0   cos(pitch)];
        
        R_x =[       1           0           0; 
                     0       cos(roll)   sin(roll); 
                     0       -sin(roll)  cos(roll)];
            
        rotation_matrix = R_z * R_y * R_x;
       
        % The Simulink is run for one step (0.04 seconds)
        if (option == 1)
            mdl = 'virtual_world_with_car';
        else
            mdl = 'virtual_world_without_car';
        end
        load_system(mdl);
        sim(mdl);
    
        % Label associated to frames acquired from the virtual environment
        frameName = strcat('screenCaptured_', num2str(k), '.tif');
        object = image(:,:,:,end);
        imwrite(object, frameName);
    
        % Frames are moved into a specific folder
        if ~(exist(folderName, 'dir'))
            mkdir(folderName);
        end
        movefile(frameName, folderName);
        
        % The index of the nex frame
        k = k+1;
        
    end
    
end

    
    
    
    