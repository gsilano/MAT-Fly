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

%%                                                              SIMULATION PARAMETERS

% The index used to distinguish the image during the simulation is
% initialized and set equal to one
k = 1;

% The mat file contains the car dynamics
load('esp_on.mat');

% The name of the detector employed for the simulation
detector = 'carDetector_virtual_world_Haar.xml';

% The initial drone (camera) position expressed in the [xyz] reference
% system
y_next = 4; % [m]
x_next = 15; % [m]
z_next = 0; % [m]

% The initial drone attitude expressed in the [xyz] reference system
yaw_initial = 0; % [rad]
pitch_initial = 0; % [rad] 
roll_initial = 0; % [rad]

% Simulink parameters
end_time = 33;                      % The end time of the simulation [s]
step = 0.05;                        % Sampling time [s]
start_time = 0;                     % Start time of the simulation [s]
stop_time = start_time + step;      % Stop time of the simulation [s]

% The stop time will be updated every step. The reason is quite simple:
% Simulink does not allow to handle the image computation directly into the 
% scheme. In order to overcome such issue, the Simulink is synchronized
% with the MATLAB script. Each simulation step, Simulink is in charge to
% simulate the scenario while the MATLAB script computes the next drone
% position and attitude.
