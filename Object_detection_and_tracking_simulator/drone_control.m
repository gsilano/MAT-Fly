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

%%                                                          ATTITUDE CONTROL - REFERENCE GENERATOR

% Error computing
error_pitch = y_centroid_img - y_centroid_bounding_box;
error_yaw = x_centroid_img - x_centroid_bounding_box;

% The errors values are stored in suitable vectors
error_x_pixel_vect(1,l) = error_yaw;
error_y_pixel_vect(1,l) = error_pitch;

% Attitude control
integral_action_pitch = integral_action_pitch + simulationStep*k_pitch_i*error_pitch;
proportional_action_pitch = k_pitch_p*error_pitch;  
delta_pitch_regulator =  integral_action_pitch + proportional_action_pitch;
pitch_regulator = delta_pitch_regulator + pitch_initial;

integral_action_yaw = integral_action_yaw + simulationStep*k_yaw_i*error_yaw;
proportional_action_yaw = k_yaw_p*error_yaw;
delta_yaw_regulator = integral_action_yaw + proportional_action_yaw;
yaw_regulator = delta_yaw_regulator + yaw_initial;

% The previous values are updated
error_pitch_pre  = error_pitch;
error_yaw_pre = error_yaw;


%%                                                    POSITION CONTROL - REFERENCE GENERATOR    

% Bounding box are
area_bounding_box = w_bb * h_bb; 

% Error computing
error_area = reference_area - area_bounding_box;
error_angle_yaw = angle_yaw_reference - yaw_regulator;
error_angle_pitch = angle_pitch_reference - pitch_regulator;

% The error are saved into vectors. They will be used in the plotting
% section of script
error_area_vect(1,l) = error_area;
error_angle_yaw_vect(1,l) = error_angle_yaw;
error_angle_pitch_vect(1,l) = error_angle_pitch;

integral_action_x = integral_action_x + simulationStep*k_area_i*error_area;
proportional_action_x = k_area_p*error_area;
delta_x_next =  proportional_action_x + integral_action_x;         
x_next = delta_x_next + x_initial;

integral_action_z = integral_action_z + simulationStep*k_z_i*error_angle_yaw;
derivative_action_z = k_z_d*((error_angle_yaw - error_yaw_angle_pre)/simulationStep);
proportional_action_z = k_z_p*error_angle_yaw;
delta_z_next = proportional_action_z + integral_action_z + derivative_action_z;
z_next = delta_z_next + z_initial;

integral_action_y =  integral_action_y + simulationStep*k_y_i*error_angle_pitch;
proportional_action_y = k_y_p*error_angle_pitch;
delta_y_next =  proportional_action_y + integral_action_y; 
y_next = delta_y_next + y_initial;

% The error variable at the previous step are updated
error_yaw_angle_pre = error_angle_yaw;
error_pitch_angle_pre =  error_angle_pitch;
error_distance_pre = error_area;
