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

%%                                                          VARIOUS PLOTS - ABSCISSA ERROR

% The abscissa error along the time
h_1 = figure;
time_vector = 1 : 1 : length(error_x_pixel_vect);
time_vector_2 = 1 : .1 : length(error_x_pixel_vect);
figure_abscissa = plot(time_vector, error_x_pixel_vett, 'b');
title('Abscissa error of the centroids distance vector');
if(abs(max(error_x_pixel_vect)) > abs(min(error_x_pixel_vect)))
    value_axis_abscissa = abs(max(error_x_pixel_vect));
else
    value_axis_abscissa = abs(min(error_x_pixel_vect));
end
ylabel('Error [pixel]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

% The same data are plotted by using the stem function
h_2 = figure;
figure_abscissa_stem = stem(time_vector, error_x_pixel_vect);
title('Abscissa error of the centroids distance vector');
if(abs(max(error_x_pixel_vect)) > abs(min(error_x_pixel_vect)))
    value_axis_abscissa = abs(max(error_x_pixel_vect));
else
    value_axis_abscissa = abs(min(error_x_pixel_vect));
end
ylabel('Error [pixel]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

%%                                                            VARIOUS PLOTS - ORDINATE ERROR

% The along the ordinate
h_3 = figure;
figure_ordinate = plot(time_vector, error_y_pixel_vect, 'b');
title('Ordinate error of the centroids distance vector');
if(abs(max(error_y_pixel_vect)) > abs(min(error_y_pixel_vect)))
    value_axis_ordinate = abs(max(error_y_pixel_vect));
else
    value_axis_ordinate = abs(min(error_y_pixel_vect));
end
ylabel('Error [pixel]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_ordinate value_axis_ordinate])

% The same plot by using the stem function
h_4 = figure;
figure_ordinate_stem = stem(time_vector, error_y_pixel_vect);
title('Ordinate error of the centroids distance vector');
if(abs(max(error_y_pixel_vect)) > abs(min(error_y_pixel_vect)))
    value_axis_ordinate = abs(max(error_y_pixel_vect));
else
    value_axis_ordinate = abs(min(error_y_pixel_vect));
end
ylabel('Error [pixel]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_ordinate value_axis_ordinate])

%%                                                            VARIOUS PLOTS - APPARENT DISTANCE

% The area error on the bounding box
h_5 = figure;
distance_apparent = error_area_vect/area_reference;  
figure_distance = plot(time_vector, distance_apparent, 'b');
title('Error on the apparent distance');
if(abs(max(distance_apparent)) > abs(min(distance_apparent)))
    value_axis_distance = abs(max(distance_apparent));
else
    value_axis_distance = abs(min(distance_apparent));
end
ylabel('Area [pixel^2]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_distance value_axis_distance])

%%                                                          VARIOUS PLOTS - DRONE AND AUTO POSITIONS

% On the the 3D plot are reported the auto and drone positions
h_6 = figure;
figure_system = plot3(position_auto(:,3), position_auto(:,1), position_auto(:,2), 'b');
hold on
plot3(position_drone(:,3), position_drone(:,1), position_drone(:,2),'b--');
hold off
legend('Position Auto', 'Position Drone');
str_1 ='\leftarrow Drone_i_n_t';
str_2 ='\leftarrow Auto_i_n_t';
str_3 ='\rightarrow Drone_e_n_d';
str_4 ='\rightarrow Auto_e_n_d';
text(position_drone(1,3), position_drone(1,1), position_drone(1,2), str_1);
text(position_auto(1,3), position_auto(1,1), position_auto(1,2), str_2);
text(position_drone(end,3), position_drone(end,1), position_drone(end,2), str_3);
text(position_auto(end,3), position_auto(end,1), position_auto(end,2), str_4);
xlabel('z [m]');
zlabel('y [m]');
ylabel('x [m]');
title('Drone and auto positions into the scenario');
grid

%%                                                    VARIOUS PLOTS - DISTANCE MODULE BETWEEN THE DRONE AND THE CAR

h_7 = figure;
module_vect_error = zeros(1, frameNumber);
for i = 1 : frameNumber
    module_vect_error(1,i) = sqrt((position_drone(i,1) - position_auto(i,1))^2 + (position_drone(i,2) - position_auto(i,2))^2 + ... 
                              + (position_drone(i,3) - position_auto(i,3))^2);
end
figure_vect_error = plot(time_vector, module_vect_error, 'b--');
hold on
plot(time_vector, radius, 'b*', 'LineWidth', 0.5);
hold off
xlabel('Frame Number [#]');
ylabel('Distance [m]');
title('Distance between the drone and the car');
legend('Measured value', 'Reference', 'Location', 'Best');
axis([0 frameNumber min(module_vect_error) max(module_vect_error)]);

%%                                                      THE PERFORMANCE INDEX OF THE CONTROL ALGORITHM

% The performance index of the control algorithm
offset_x = position_drone(1,3) - position_auto(1,3);
offset_y = position_drone(1,2) - position_auto(1,2);
offset_z = position_drone(1,1) - position_auto(1,1);

% Each step the offset computed before is subtracted on the drone position.
% The error module between the car and the drone is computed
error_module = zeros(1, frameNumber); % Storing the error module
for j = 2 : frameNumber
    actual_position_x = position_drone(j,3) - offset_x;
    actual_position_y = position_drone(j,2) - offset_y;
    actual_position_z = position_drone(j,1) - offset_z;
    
    error_module(1,j) = sqrt((actual_position_z - position_auto(j,1))^2 + (actual_position_y - position_auto(j,2))^2 + ... 
                              + (actual_position_x - position_auto(j,3))^2);
end

% The error is plotted by using the stem function
h_8 = figure;
error_time_vector = 1 : 1: frameNumber;
figure_error_index_stem = stem(error_time_vector, error_module);
title('Trajectory error');
ylabel('Error [m]');
xlabel('Frame Number [#]');
axis([1 error_time_vector(1, end) -1 max(error_module)]);

% The error is plotted by using the plot function
h_9 = figure;
figure_error_index_plot = plot(error_time_vector, error_module);
title('Trajectory error');
ylabel('Error [m]');
xlabel('Frame Number [#]');
axis([1 error_time_vector(1, end) -1 max(error_module)]);

% The performance index algorithm: the mean square error of error between
% the car and drone trajectories 
performance_index = rms(error_module);            
disp('Index performance of the algorithm: ');
disp(performance_index);

% The obtained results are saved into a MAT-file
save('performance_index.mat', 'peformance_index');

%%                                                          VARIOUS PLOTS - ERROR ON THE YAW ANGLE

% The information related to the yaw angle are plotted by using the
% standard MATLAB function plot
h_10 = figure;
figure_error_yaw = plot(time_vector, error_angle_yaw_vect, 'b');
title('Yaw Error');
if(abs(max(error_angles_yaw_vect)) > abs(min(error_angles_yaw_vect)))
    value_axis_abscissa = abs(max(error_angles_yaw_vect));
else
    value_axis_abscissa = abs(min(error_angles_yaw_vect));
end
ylabel('Error [rad]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

% The same information are plotted by using the stem function
h_11 = figure;
figure_errore_yaw_stem = stem(time_vector, error_angles_yaw_vect, 'b');
title('Yaw Error');
if(abs(max(error_angles_yaw_vect)) > abs(min(error_angles_yaw_vect)))
    value_axis_abscissa = abs(max(error_angles_yaw_vect));
else
    value_axis_abscissa = abs(min(error_angles_yaw_vect));
end
ylabel('Error [rad]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

%%                                                          VARIOUS PLOTS - ERROR ON THE PITCH ANGLE

% The same error computed before but on the pitch angle
h_12 = figure;
figure_error_pitch = plot(time_vector, error_angle_pitch_vect, 'b');
title('Pitch Error');
if(abs(max(error_angle_pitch_vect)) > abs(min(error_angle_pitch_vect)))
    value_axis_abscissa = abs(max(error_angle_pitch_vect));
else
    value_axis_abscissa = abs(min(error_angle_pitch_vect));
end
ylabel('Error [rad]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

% The same information are plotted by using the stem function
h_13 = figure;
figure_error_pitch_stem = stem(time_vector, error_angle_pitch_vect, 'b');
title('Pitch Error');
if(abs(max(error_angle_pitch_vect)) > abs(min(error_angle_pitch_vect)))
    value_axis_abscissa = abs(max(error_angle_pitch_vect));
else
    value_axis_abscissa = abs(min(error_angle_pitch_vect));
end
ylabel('Error [rad]');
xlabel('Frame Number [#]');
axis([1 time_vector(1, end) -value_axis_abscissa value_axis_abscissa])

%%                                                      VARIOUS PLOTS - DRONE AND CAR POSITIONS

h_14 = figure;
figure_position_x_drone_auto = plot(time_vector, position_auto(:,3), 'b');
hold on
plot(time_vector, position_drone(:,3), 'b-.');
hold off
xlabel('Frame Number [#]');
ylabel('Position [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Auto and Drone Position - Transverse movements (X)');

h_15 = figure;
figure_position_y_drone_auto = plot(time_vector, position_auto(:,2), 'b');
hold on
plot(time_vector, position_drone(:,2), 'b-.');
hold off
xlabel('Frame Number [#]');
ylabel('Position [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Auto and Drone Position - Quote (Y)');

h_16 = figure;
figure_position_z_drone_auto = plot(time_vector, position_auto(:,1), 'b');
hold on
plot(time_vector, position_drone(:,1), 'b-.');
hold off
xlabel('Frame Number [#]');
ylabel('Position [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Auto and Drone Position - Longitudinal Movements (Z)');

% Error with respect to the reference
error_x_drone_auto = median(position_drone(:,3) - position_auto(:,3));
error_y_drone_auto = median(position_drone(:,2) - position_auto(:,2));
error_z_drone_auto = median(position_drone(:,1) - position_auto(:,1));

% The computed indexes are displayed on the screen
disp('Transverse movements errors: ');
disp(error_x_drone_auto);
disp('Quote error: ');
disp(error_y_drone_auto);
disp('Longitudinal movements error: ');
disp(error_z_drone_auto);

% The errors are saved on a MAT-file
save('index_error_drone_auto.mat', 'error_x_drone_auto', 'error_y_drone_auto', 'error_z_drone_auto');

% The plots are saved on a file
saveas(figure_ordinate, 'figure_ordinate.tif', 'tif');
saveas(figure_abscissa, 'figure_abscissa.tif', 'tif');
saveas(figure_distance, 'figure_distance.tif', 'tif');
saveas(figure_system, 'figure_drone_follows_auto.tif', 'tif');
saveas(figure_vect_error, 'figure_vect_error.tif', 'tif');
saveas(figure_ordinate_stem, 'figure_ordinate_stem.tif', 'tif');
saveas(figure_abscissa_stem, 'figure_abscissa_stem.tif', 'tif');
saveas(figure_error_index_stem, 'figure_error_index_stem.tif','tif');
saveas(figure_error_index_plot, 'figure_error_index_plot.tif', 'tif');
saveas(figure_error_pitch, 'figure_error_angle_pitch.tif', 'tif');
saveas(figure_error_pitch_stem,'figure_error_angle_pitch_stem.tif', 'tif');
saveas(figure_error_yaw, 'figure_error_angle_yaw.tif', 'tif');
saveas(figure_error_yaw_stem,'figure_error_angle_yaw_stem.tif', 'tif');
saveas(figure_position_x_drone_auto,'figure_position_x_drone_auto.tif', 'tif');
saveas(figure_position_y_drone_auto,'figure_position_y_drone_auto.tif', 'tif');
saveas(figure_position_z_drone_auto,'figure_position_z_drone_auto.tif', 'tif');

% The files are moved in the suitable folder
folderName_dataComputing = 'Acquisitions';
movefile('figure_ordinate.tif', folderName_dataComputing);
movefile('figure_abscissa.tif', folderName_dataComputing);
movefile('figure_distance.tif', folderName_dataComputing);
movefile('figure_drone_follows_auto.tif', folderName_dataComputing);
movefile('figure_vect_errore.tif', folderName_dataComputing);
movefile('figure_ordinate_stem.tif', folderName_dataComputing);
movefile('figure_abscissa_stem.tif', folderName_dataComputing);
movefile('figure_error_index_stem.tif', folderName_dataComputing);
movefile('figure_error_index_plot.tif', folderName_dataComputing);
movefile('figure_error_angle_pitch.tif', folderName_dataComputing);
movefile('figure_error_angle_pitch_stem.tif', folderName_dataComputing);
movefile('figure_error_angle_yaw.tif', folderName_dataComputing);
movefile('figure_error_angle_yaw_stem.tif', folderName_dataComputing);
movefile('figure_position_x_drone_auto.tif', folderName_dataComputing);
movefile('figure_position_y_drone_auto.tif', folderName_dataComputing);
movefile('figure_position_z_drone_auto.tif', folderName_dataComputing);

% Figure files storing
savefig(h_1, 'figure_abscissa.fig');
savefig(h_2, 'figure_abscissa_stem.fig');
savefig(h_3, 'figure_ordinate.fig');
savefig(h_4, 'figure_ordinate_stem.fig');
savefig(h_5, 'figure_distance.fig');
savefig(h_6, 'figure_system.fig');
savefig(h_7, 'figure_vect_error.fig');
savefig(h_8, 'figure_error_index_stem.fig');
savefig(h_9, 'figure_error_index_plot.fig');
savefig(h_10, 'figure_error_angle_yaw.fig');
savefig(h_11, 'figure_error_angle_yaw_stem.fig');
savefig(h_12, 'figure_error_angle_pitch.fig');
savefig(h_13, 'figure_error_angle_pitch_stem.fig');
savefig(h_14, 'figure_position_x_drone_auto.fig');
savefig(h_15, 'figure_position_y_drone_auto.fig');
savefig(h_16, 'figure_position_z_drone_auto.fig');

% The fig files are moved into the suitable folder
movefile('figure_ordinate.fig', folderName_dataComputing);
movefile('figure_abscissa.fig', folderName_dataComputing);
movefile('figure_distance.fig', folderName_dataComputing);
movefile('figure_system.fig', folderName_dataComputing);
movefile('figure_vect_errore.fig', folderName_dataComputing);
movefile('figure_ordinate_stem.fig', folderName_dataComputing);
movefile('figure_abscissa_stem.fig', folderName_dataComputing);
movefile('figure_error_index_stem.fig', folderName_dataComputing);
movefile('figure_error_index_plot.fig', folderName_dataComputing);
movefile('figure_error_angle_yaw.fig', folderName_dataComputing);
movefile('figure_error_angle_yaw_stem.fig', folderName_dataComputing);
movefile('figure_error_angle_pitch.fig', folderName_dataComputing);
movefile('figure_error_angle_pitch_stem.fig', folderName_dataComputing);
movefile('figure_posizione_x_drone_auto.fig', folderName_dataComputing);
movefile('figure_posizione_y_drone_auto.fig', folderName_dataComputing);
movefile('figure_posizione_z_drone_auto.fig', folderName_dataComputing);

% Close all the plot windows
close all    