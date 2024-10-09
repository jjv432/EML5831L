clc
clear all
close all
format compact

% J. Vranicar 10/09/24

%{
    Use section 1 to generate a new save file for data that you've
    collected from the Optitrack MoCap cameras.  Uncomment the line is
    Section 2 and comment the line in Section 1 if you want to read from a
    previously saved struct.  
%}
%% 1. Organize New Data

% Creates a struct to store the CSV data.  Only run this line one time for
% each csv, then read from the saved .mat file in the future.

%Robot = optitrack_R2();

%% 2. Read Saved Data
%{ 
    Only use this section if you have already ran Section 1 above and saved
    the data to a .json file.  The "FileName" variable will be the name of
    the .json file you created, without the .json extension.  i.e.
    "test1.json" has FileName "test1"
%}

FileName = "RotationTest_009";
Robot = readstruct(strcat(FileName, ".json"));



%% 3. Fix an Error with Angles

%{
    This section fixes the angles so that they keep adding up past +/- 180
    degrees.  You shouldn't need to change anything other than the input of
    the function.  The input will just be the values for the rotation about
    the y-axis.
%}

y_rotation = thetaFix(Robot.RigidBodyRotationY);

% Showing an example of how to plot the results of this function

figure()
plot(Robot.Time, y_rotation-y_rotation(1));

%% 4. Your Code Here
