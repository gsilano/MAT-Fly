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

%%                                                                  DRONE MODEL

% The reference value extracted from the each frame are used as reference
% for the drone trajectory
% The simulation does not work in synchronized way. For more information
% take a look at the paper.
start_simulation_drone = 0;      %[s]
end_simulation_drone = 10;       %[s]

% Position reference computed by the reference generator
observer_position_reference_generator = [z_next y_next x_next];
observer_position_reference_generator_vect (:,l) = observer_position_reference_generator;

observer_orientation_reference_generator = [yaw_regulator pitch_regulator 0];
observer_orientation_reference_generator_vect(:,l) = observer_orientation_reference_generator;

% The reference system changing. The drone model is described in the fixed
% inertial frame and not in the MathWorks VR one
x_next_drone = x_next;
y_next_drone = -z_next;
z_next_drone = y_next;

% Simulation start
mdl_drone = 'PDQuadrotor_with_the_position_control';
load_system(mdl_drone);
sim(mdl_drone);

% The drone state variables are store. They will be used into the next step
% Position errors at the previous step
chi_6_pre = chi_6(end);
chi_5_pre = chi_5(end);

% Angular accelerations at the previous step are updating
phi_dot_pre = phi_dot(end);
theta_dot_pre = theta_dot(end);
psi_dot_pre = psi_dot(end);

% Linear velocities at the previous step are updating
x_dot_pre = x_dot(end);
y_dot_pre = y_dot(end);
z_dot_pre = z_dot(end);

% The angle values at the previous step are updating
pitch_regolatore_pre = theta_meas(end);
yaw_regolatore_pre = psi_meas(end);
roll_regolatore_pre = phi_meas(end);

% The position at the previous step is updated
z_next_pre = z_meas(end);
x_next_pre = x_meas(end);
y_next_pre = y_meas(end);

% The drone pose is updated. Later, it will be used in the virtual world
% reality environment
z_next = -y_meas(end);
y_next = z_meas(end);
x_next = x_meas(end);

% The drone attitude. It is used for the analysis part of the script
roll_virtual = phi_meas(end);
yaw_virtual = psi_meas(end);
pitch_virtual = theta_meas(end); 

% The variables values along the time are monitored. The aim is to monitor
% the error when the system evolves
chi_6_pre_vect(1,l) = chi_6_pre;
chi_5_pre_vect(1,l) = chi_5_pre;

psi_dot_pre_vect(1,l) = psi_dot_pre;
phi_dot_pre_vect(1,l) = phi_dot_pre;
theta_dot_pre_vect(1,l) = theta_dot_pre;

x_dot_pre_vect(1,l) = x_dot_pre;
y_dot_pre_vect(1,l) = y_dot_pre;
z_dot_pre_vect(1,l) = z_dot_pre;

