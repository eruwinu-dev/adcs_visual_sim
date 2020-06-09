# adcs_visual_sim
An ADCS Simulation and Visualization Tool. Partial requirements for ECE 198.

## Requirements for Use
* MATLAB 2017b or later versions.

## Overview of The Tool
  * This script shows the 3D visualization of a satellite's attitude determination and control system (ADCS). Three controllers, namely Linear Quadratic Regulator, Sliding Mode Controller, and Integrator Backstepping Controller were implemented using Simulink can be used to observe the attitude, angular velocity, and reaction wheel speed of the ADCS.
  * To use the tool, run **main.m** on the MATLAB command prompt.

## Code Organization
* *main.m*
  * runs the graphical user interface (GUI).
  * calls the selected control algorithm to simulate the closed-loop response of the satellite.
  * shows the 3D visualization and tracks the attitude, angular velocity, and wheel speed during the course of the animation.
  * shows the steady state parameters

* *construct_sat_model.m*
  * from the user inputs, this script constructs the visual model for the satellite ADCS.

* *visualize_rot.m*
  * from simulated attitude data, this script computes for the quaternion difference between samples to rotate the satellite ADCS model during each sample time.
  * shows the attitude, angular velocity, and wheel speed graphs
  
* *lqr_c.slx*
  * implementation of the LQR controller
  
* *smc.slx*
  * implementation of the SMC controller
  
* *backstepping.slx*
  * implementation of the LQR controller
