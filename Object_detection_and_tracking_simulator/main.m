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

% The code reported below allows to choose the scenario will be simulated
disp('Which scenario are you interested in?');
disp('');
disp('Below the options are reported'); 
disp('    (1) The drone follows a car along a non trivial path ("vr_octavia_2cars" scenario)'); 
disp('    (2) The drone follows the red car superimposed on yellow one ("vr_octavia_2cars" scenario)'); 
disp('    (3) The drone follows the yellow car in front of the car one ("vr_octavia_2cars" scenario)'); 
disp('    (4) The drone follows a car along a non trivial path ("vr_octavia" scenario)');
disp('    (5) The drone follows the red car in front of the yellow one ("vr_octavia_2cars" scenario)'); 
disp('    (6) The drone follows the red car to the right of of the yellow one ("vr_octavia_2cars" scenario)'); 
disp('    (7) The drone follows the red car to the left of of the yellow one ("vr_octavia_2cars" scenario)'); 

option = input('');

% The file contains the simulation parameters
simulation_parameters;

% The file contains the controller parameters
controller_parameters;

% The file contains the drone parameters
drone_parameters;

% The variables is employed to select the detection algorithm at first
% step, while the tracking one is used in the later. 
first_cycle = 1;

% The simulation loop. The virtual world, the image computing and drone
% dynamics and control are simulated step by step. The output of the loop
% is a collection of images: the image captured by an idealized camera on
% the drone body.
for l = 1 : frameNumber
    
    % Virtual reality rendering
    virtual_world_script;
    
    % Image computing. In that script is included also the drone control
    % algorithms
    image_computing;
        
    % Drone dynamics
    drone_dynamics;
    
    
    %%                                                  PARAMTERS FOR THE NEXT SIMULATION STEP

    % The frame index is incremented
    k = k + 1;

    % The simulation time values are updated
    start_time =  stop_time;
    stop_time = stop_time + simulationStep; %+ simulation_time_drone;

    % The variables is turned low
    if(first_cycle && size(bbox,1) > 0)
        first_cycle = 0;
    end
   
end


% Data storing
data_storing;

% Data computing
data_computing;