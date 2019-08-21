[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![first-timers-only](https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square)](https://www.firsttimersonly.com/)

# MAT-Fly
MAT-Fly is a numerical simulation platform for multi-rotor aircraft characterized by the ease of use and control development. The platform is based on MATLAB and the MathWorks Virtual Reality (VR) Toolbox that work together to simulate the behavior of a drone in a 3D environment while tracking a car that moves along a non trivial path.

The VR toolbox has been chosen due to the familiarity that students have with MATLAB and because it allows to move the attention to the classifier, the tracker, the reference generator and the trajectory tracking control thanks to its simple structure. The overall architecture is quite modular so that each block can be easily replaced with others by simplifying the development phase and by allowing to add even more functionalities.

The code is released under Apache license, thus making it available for scientific and educational activities.

The platform has been developed using the 2015b release of MATLAB but it is compatible with any other successive MATLAB release. The MathWorks Computer Vision System Toolbox is needed for running the Simulink schemes and Matlab scripts.

Below we provide the instructions necessary for getting started. 

If you are using the simulator within the research for your publication, please take a look at the [Publications](https://github.com/gsilano/MAT-Fly/wiki/Publications) page. 
 
# Basic Usage

Starting the simulation is quite simple as well as customizing it. Indeed, it is enough to run the MATLAB ```main``` script reported in the ```Object_detection_and_tracking_simulator``` repository. A menu shows the simulation options:

```
(1) The drone follows a car along a non trivial path ("vr_octavia_2cars" scenario)
(2) The drone follows the red car superimposed on yellow one ("vr_octavia_2cars" scenario)
(3) The drone follows the yellow car in front of the car one ("vr_octavia_2cars" scenario) 
(4) The drone follows a car along a non trivial path ("vr_octavia" scenario)
(5) The drone follows the red car in front of the yellow one ("vr_octavia_2cars" scenario) 
(6) The drone follows the red car to the right of of the yellow one ("vr_octavia_2cars" scenario) 
(7) The drone follows the red car to the left of of the yellow one ("vr_octavia_2cars" scenario) 
```

Once selected the simulation scenario, the simulator starts taking screenshots from the 3D simulation scenario and making them available into the ```Acquisition``` folder (it is created at runtime if not yet available).

With the aim of making easy the reuse of the proposed software platform, an offline dataset has been created and made available (links are reported below). The dataset allows to quickly design the classifier and the flight control system, to check the perfomance of the MATLAB script for automatically recognize the ROIs (Region Of Interests) within the frames, etc..

* [Images_cropped](https://mega.nz/#!psdBhSqC!SSIVPsrEstTuze0cYI9ZETBcC2nevCjySeRerE_S9lg);
* [Negative_images](https://mega.nz/#!IoFDmChY!UgtC4ml__xQrLv2i7jiqCUIzD8KPZ2-KRhhtgrcV3Tw);
* [Positive_images](https://mega.nz/#!89cziS7B!s9DNYg004tl-N-Za2QzP8a-y-IsIozWXBiGH5hxy_dE).

# Bugs & Feature Requests

Please report bugs and request features by using the [Issue Tracker](https://github.com/gsilano/MAT-Fly/issues). Furthermore, please see the [Contributing.md](https://github.com/gsilano/MAT-Fly/blob/master/CONTRIBUTING.md) file if you plan to help us improve the features of MAT-Fly.

# YouTube video

In this section, a video provides in a direct way the effectiveness of the proposed platform. Links to other videos are available in the related papers and on the YouTube channel. Enjoy! :)

[![MAT-Fly YouTube video. Drone follows the car along a non trivial scenario.](https://github.com/gsilano/MAT-Fly/wiki/images/Miniature_MAT-Fly.png)](https://youtu.be/b8mTHRkRDmA "MAT-Fly, YouTube video. Drone follows the car along a non trivial scenario.")
