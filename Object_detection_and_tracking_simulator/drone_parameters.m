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

%%                                                          DRONE PARAMETERS

Ix = 7.5*10^(-3);   % Quadrotor moment of inertia around X axis [Kg * m^2]
Iy = 7.5*10^(-3);   % Quadrotor moment of inertia around Y axis [Kg * m^2]
Iz = 1.3*10^(-2);   % Quadrotor moment of inertia around Z axis [Kg * m^2]
Jr = 6.5*10^(-5);   % Total rotational moment of inertia around the propeller axis [Kg * m^2]
b = 3.13*10^(-5);   % Thrust factor [1]
d = 7.5*10^(-7);    % Drag factor [1]
l = 0.23;           % Distance to the center of the Quadrotor [m]
m = 0.65;           % Mass of the Quadrotor in [Kg]
g = 9.81;           % Gravitational acceleration [m/s^2]