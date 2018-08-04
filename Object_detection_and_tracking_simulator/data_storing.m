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

%%                                                              SAVING SIMULATION DATA


% The MAT-files are moved into a suitable folder. If such folder does not
% exist, it is created
folderMatFile = 'FileMat';
if ~(exist(folderMatFile, 'dir'))
    mkdir(folderMatFile);
end

% Mat-file naming
nameMatFileVariousInformation = 'variousInformation.mat';
nameMatFileErrorXPixel = 'errorXPixel.mat';
nameMatFileErrorYPixel = 'errorYPixel.mat';
nameMatFileErrorAreaPixel = 'errorAreaPixel.mat';
nameMatFileErrorAngleYawReferenceGenerator = 'errorYawReferenceGenerator.mat';
nameMatFileErrorAnglePitchReferenceGenerator = 'errorPitchReferenceGenerator.mat';
nameMatFileChi_6 = 'chi_6.mat';
nameMatFileChi_5 = 'chi_5.mat';
nameMatFilePsi_dot = 'psi_dot.mat';
nameMatFilePhi_dot = 'phi_dot.mat';
nameMatFileTheta_dot = 'theta_dot.mat';
nameMatFileX_dot = 'x_dot.mat';
nameMatFileY_dot = 'y_dot.mat';
nameMatFileZ_dot = 'z_dot.mat';
nameMatFileObserverPositionReferenceGenerator = 'observerPositionReferenceGenerator.mat';
nameMatFileObserverOrientationReferenceGenerator = 'observerOrientationReferenceGenerator.mat';
nameMatFilePositionAuto = 'positionAuto.mat';
nameMatFilePositionDrone = 'positionDrone.mat';
nameMatFileAttitudeDrone = 'attitudeDrone.mat';

% Mat-files storing
save(nameMatFileVariousInformation, 'simulation_time', 'step', 'reference_area', 'radius', 'g', 'm', 'l', 'd', 'b', 'Jr', 'Iz', 'Iy', 'Ix', ...
    'kpz', 'kdz', 'kpps', 'kdps', 'kpt', 'kdt', 'kpp', 'kdp', 'C_12', 'C_11', 'C_10', 'C_9', 'lambda_6', 'lambda_5', 'k_z_d', 'k_y_i', 'k_z_i', ...
    'k_area_i', 'k_y_p', 'k_z_p', 'k_area_p', 'k_yaw_i', 'k_pitch_i', 'k_yaw_p', 'k_pitch_p', 'w_im', 'h_im');
save(nameMatFileErrorXPixel, 'error_x_pixel_vett');
save(nameMatFileErrorYPixel, 'error_y_pixel_vett');
save(nameMatFileErrorAreaPixel , 'error_area_vett');
save(nameMatFileErrorAngleYawReferenceGenerator , 'error_angolo_yaw_vett');
save(nameMatFileErrorAnglePitchReferenceGenerator , 'error_angolo_pitch_vett');
save(nameMatFileChi_6 , 'chi_6_pre_vect');
save(nameMatFileChi_5 , 'chi_5_pre_vect');
save(nameMatFilePsi_dot , 'psi_dot_prec_vect');
save(nameMatFilePhi_dot , 'phi_dot_prec_vect');
save(nameMatFileTheta_dot , 'theta_dot_pre_vect');
save(nameMatFileX_dot , 'x_dot_pre_vect');
save(nameMatFileY_dot , 'y_dot_pre_vect');
save(nameMatFileZ_dot , 'z_dot_pre_vect');
save(nameMatFileObserverPositionReferenceGenerator , 'observer_position_reference_generator_vett');
save(nameMatFileObserverOrientationReferenceGenerator , 'observer_orientation_reference_generator_vett');
save(nameMatFilePositionAuto , 'position_auto'); 
save(nameMatFileAttitudeDrone , 'position_drone');
save(nameMatFileAttitudeDrone, 'attitude_drone');

% Moving the files into the folder
movefile(nameMatFileVariousInformation, folderMatFile);
movefile(nameMatFileErrorXPixel, folderMatFile);
movefile(nameMatFileErrorYPixel, folderMatFile);
movefile(nameMatFileErrorAreaPixel , folderMatFile);
movefile(nameMatFileErrorAngleYawReferenceGenerator , folderMatFile);
movefile(nameMatFileErrorAnglePitchReferenceGenerator , folderMatFile);
movefile(nameMatFileChi_6 , folderMatFile);
movefile(nameMatFileChi_5 , folderMatFile);
movefile(nameMatFilePsi_dot , folderMatFile);
movefile(nameMatFilePhi_dot , folderMatFile);
movefile(nameMatFileTheta_dot , folderMatFile);
movefile(nameMatFileX_dot , folderMatFile);
movefile(nameMatFileY_dot , folderMatFile);
movefile(nameMatFileZ_dot , folderMatFile);
movefile(nameMatFileObserverPositionReferenceGenerator , folderMatFile);
movefile(nameMatFileObserverOrientationReferenceGenerator , folderMatFile);
movefile(nameMatFilePositionDrone , folderMatFile); 
movefile(nameMatFilePositionAuto , folderMatFile); 
movefile(nameMatFileAttitudeDrone , folderMatFile);


