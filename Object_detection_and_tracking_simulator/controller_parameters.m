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

%%                                                   CONTROLLER PARAMTERS - REFERENCE GENERATOR

% The reference area employed by the reference generator
reference_area = 30000;                 % Empirical value computed during the frame acquisition phase [px^2]
radius = 15;                            % Distance used to compute the reference are during the frame acquisition phase [m]

% Images parameters
w_im = 600; %Width [px] 
h_im = 800; % Height [px]

% Attitude previous values (k-1 step)
yaw_regulator_pre = yaw_initial;                   % Previous step
pitch_regulator_pre = pitch_initial;               % Previous step
roll_regulator_pre = roll_initial;

% Position previous values (k-1 step) taking into account the virtual world
% reference system quite different with respect to the inertial one. For
% more details take a look at the paper.
z_next_pre = y_next;                 % Previous step
x_next_pre = x_next;                 % Previous step
y_next_pre = -z_next;                % Previous step

% The initial attitude errors at the previous step (k-1)
error_pitch_pre = pitch_initial;
error_yaw_pre = yaw_initial;

% The error initial value at the previous step (k-1)
error_pitch_angle_pre = 0;
error_yaw_angle_pre = 0;
error_distance_pre = 0;

% Proportional gains on the attitude angles: yaw and pitch
k_pitch_p = 0;
k_yaw_p = 0;

% Integral gains on the attitude angles: yaw and pitch
k_pitch_i = -1e-3;
k_yaw_i = -1e-3;

% Proportional gains of the position controller
k_area_p = 1e-6;
k_z_p = -15;           
k_y_p = 1e-2;          
       
% Integral gains of the position controller
k_area_i = -6e-6;
k_z_i = -57.5;
k_y_i = 1e-2;

% Derivate gains of the position controller
k_z_d = 3.75;

% The derivate part of the controller is initialized
derivate_action_z = 0;

% The integral actions are initialized. The integral contribute of the
% controller is computed as I(k+1) = I(k-1) + I_g * E, where I(k+1) is the
% contribute of the next step, I(k-1) the contribute of the previous step,
% I_g the integral gain and E the error
integral_action_pitch = 0;
integral_action_yaw = 0;
integral_action_x = 0;
integral_action_z = 0;
integral_action_y = 0;

% Supposed that the drone is able to see the car at first step. Such
% hypothesis is not strong. In fact, the drone orientation can me changed
% trying to understand what it happens when it is different respect to now.
angle_yaw_reference = yaw_initial;      
angle_pitch_reference =  pitch_initial;

%%                                                      INITIAL CONDITION CONTROLLER VARIABLES

% For more information take a look at the control section of the paper.

% Drone position errors at the previous step
chi_6_pre = 0;
chi_5_pre = 0;
    
% Drone angular velocities at the previous step
phi_dot_pre = 0;
theta_dot_pre = 0;
psi_dot_pre = 0;
    
% Drone linear velocity at the previous step
x_dot_pre = 0;
y_dot_pre = 0;
z_dot_pre = 0;

%%                                                              QUADROTOR POSITION CONTROL PARAMETERS

% Parameters for the trajectory tracking control
lambda_5 = 0.025;
lambda_6 = 0.025;

C_9 = 2;
C_10 = 0.5;
C_11 = 2; 
C_12 = 0.5;


%%                                                                  CONTROLLER GAINS VALUES

% PD on the Phi angle (roll)
kpp = 0.8e1;
kdp = 0.4e1;

% PD on the Theta angle (pitch)
kpt = 1.2e1;
kdt = 0.4e1;

% PD n the Psi angle (yaw)
kpps = 1e1;
kdps = 0.4e1;

% PD on the z-axis in VR reference system
kpz = 100e1;
kdz = 20e1;

%%                                                                  STORAGE SECTION

% The variable will be contain the drone position and orientation, the
% errors, the control contributes, and so on, are stored in vector in order
% to facilitate the analysis (the data are useful to better understand the
% detection algorithm and drone controller) at the end of the simulation
 
% The frame number is employed to understand how many the simulation has to
% be run
frameNumber = floor(end_time - start_time)/simulationStep;   % Take a look a the help of the floor function

% The vectors contain the errors come out from the image computing. For
% more information take a look at the paper, in particular the section
% about the image computing
error_x_pixel_vect = zeros(1, frameNumber);
error_y_pixel_vect = zeros(1, frameNumber);
error_area_vect = zeros(1, frameNumber);
error_angle_yaw_vect = zeros(1, frameNumber);
error_angle_pitch_vect = zeros(1, frameNumber);

% The vectors reported below allow to monitor the variables come out from
% the drone model and control
chi_6_pre_vect = zeros(1, frameNumber);
chi_5_pre_vect = zeros(1, frameNumber);
    
psi_dot_pre_vect = zeros(1, frameNumber);
phi_dot_pre_vect = zeros(1, frameNumber);
theta_dot_pre_vect = zeros(1, frameNumber);
    
x_dot_pre_vect = zeros(1, frameNumber);
y_dot_pre_vect = zeros(1, frameNumber);
z_dot_pre_vect = zeros(1, frameNumber);

% The observer position and orientation come out from the reference
% generator
observer_position_reference_generator_vect = zeros(3, frameNumber);
observer_orientation_reference_generator_vect = zeros(3, frameNumber);

% The car and drone positions are stored for comparing the trajectory at
% the end of the simulation
position_auto = zeros(frameNumber, 3);   %The rows are equal to the frame numbers while the columns are equal to positions along the axes [z, y, x]
position_drone = zeros(frameNumber, 3);
orientation_drone = zeros(frameNumber, 3);

% Such variable is used to detect the car at the first step
first_cycle=1;
