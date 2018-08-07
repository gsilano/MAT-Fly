[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# MAT-Fly
MAT-Fly provides an easy to use virtual reality environment based on the MathWorks Virtual Reality (VR) Toolbox aimed to simulate flying platforms together with detection and tracking algorithms.

The main motiviation of this work is to propose the simulation-in-the-loop approach for educational purposes within the UAV field. The MathWorks VR Toolbox is employed to simulate the behavior of a drone in a 3D environment when detection, tracking and control algorithms are run. Matlab VR has been chosen due to the familiarity that students have with. In this way the attention can be moved to the classifier, the tracker, the references generator and the trajectory tracking control. The overall architecture is quite modular so that each block can be easily replaced with others thus simplifying the development phase. A simple case study is described below in order to show the effectiveness of the approach.

The code is released under Apache license, thus making it available for scientific and educational activities.

The platform has been developed by using the 2015b release of MATLAB but it is compatible with any successive MATLAB release. The Computer Vision System Toolbox is needed to run both Simulink schemes and Matlab scripts.

Below we provide the instructions necessary for getting started. 

If you are using the simulator within the research for your publication, please cite the paper reported below. An extension work is under review. When it will be available, further references will be reported below.

```
@INPROCEEDINGS{Silano2016, 
author={G. Silano and L. Iannelli}, 
booktitle={2016 IEEE Conference on Control Applications (CCA)}, 
title={An educational simulation platform for GPS-denied unmanned Aerial 
Vehicles aimed to the detection and tracking of moving objects}, 
year={2016},
pages={1018-1023},  
month={Sept}
}
 ```
 
# Basic Usage
 
# YouTube videos

In such section a video providing the effectiveness of the platform is reported. Further videos are reported in the paper mentioned before. They can be found in the related YouTube channel. Have fun! :)

[![MAT-Fly YouTube video. Drone follows the car along a non trivial scenario.](https://github.com/gsilano/MAT-Fly/wiki/images/Miniature_YouTube_JIRS.png)]( "MAT-Fly, YouTube video. Drone follows the car along a non trivial scenario.")
