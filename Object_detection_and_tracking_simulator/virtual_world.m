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

%%                                                THE CAR AND DRONE DYNAMICS ARE SIMULATED IN THE VIRTUAL WORLD   
    
% Th observer position is updated
observer_position = [z_pross y_pross x_pross];

% The observer orientation is updated. 
observer_orientation = [yaw_virtual pitch_virtual roll_virtual];

% The drone position and attitude are stored in vectors in order to analyze
% the data at the end of the simulation
position_drone(l,:) = [z_pross y_pross x_pross];
orientation_drone(l,:) = observer_orientation;

% The rotation matrix computing
R_z = [   cos(yaw_virtual)    sin(yaw_virtual)    0; 
         -sin(yaw_virtual)    cos(yaw_virtual)    0; 
                 0                   0            1];

R_y = [   cos(pitch_virtual)      0   -sin(pitch_virtual); 
                  0               1             0; 
          sin(pitch_virtual)      0   cos(pitch_virtual)];

R_x = [       1               0                     0; 
              0       cos(roll_virtual)   sin(roll_virtual); 
              0       -sin(roll_virtual)  cos(roll_virtual)];

rotation_matrix = R_z * R_y * R_x;

% The Simulink scheme is run for one step
mdl = 'virtual_world';
load_system(mdl);
sim(mdl);

% The car position is stored in a vector
position_auto(l,:) = car_position;
