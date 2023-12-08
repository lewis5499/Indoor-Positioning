%% created by Hengzhen Liu, Oct.8, 2023
%% Load data
clc;clear;
load ..\dataset\data_default.mat
%% Process data and Plot
clear sensorsmatrix var1 var2;
%% 1st fig: rawdata=ACCE+GYRO+MAGN
rawdataPlot("rawSensorData",sec,rawGyro,rawAcce,rawMagn);
%% 2nd fig: Horizontal Angles according to the ACCE
[roll,pitch]=anglePlot("HorizontalAngles(without smoothing)",sec,rawAcce);
%% 3rd fig: SMOOTHED Horizontal Angles
sampling_rate=20; %Sampling rate: 20 Hz
window_len=1; %Smoothing window: 1 sec
smt_roll=vecsmooth(roll,sampling_rate*window_len);
smt_pitch=vecsmooth(pitch,sampling_rate*window_len);
sthAnglePlot("HorizontalAngles(smoothing window=1s)",sec,rad2deg(smt_roll),rad2deg(smt_pitch));
clear window_len;
%% 4th fig: Heading Angle from Magnetometer
C_b2n1=[];
for i=1:length(smt_pitch)
    C_b2n1=[C_b2n1;{rotMat("pitch",-smt_pitch(i))*rotMat("roll",-smt_roll(i))}];
end
magn_n1=[];
for i=1:length(C_b2n1)
    magn_n1=[magn_n1,C_b2n1{i}*[rawMagn.x_Magn(i);rawMagn.y_Magn(i);rawMagn.z_Magn(i)]];
end
magn_D=14.11;
magn_heAngle=(-atan2(magn_n1(2,:),magn_n1(1,:))+deg2rad(magn_D)).';
% magn angle-> [-180, 180)
magnAnglePlot("Heading from Magnetometers",sec,(rad2deg(magn_heAngle)));
% magn angle-> [0, 360)
%magnAnglePlot("Heading from magnetometers",sec,mod(rad2deg(magn_heAngle),360.0));
%% 5th fig: Heading Angle from Gyro
gyro_n1=[];
for i=1:length(C_b2n1)
    gyro_n1=[gyro_n1,C_b2n1{i}*[rawGyro.x_Gyro(i);rawGyro.y_Gyro(i);rawGyro.z_Gyro(i)]];
end
% Attention: Under the premise of a sampling rate of 20Hz, it is considered that
% the pedestrian's pace is close to a uniform speed within the sampling interval, 
% and the integration is performed based on the vertical angular velocity of the gyroscope.
zbias=0.2290;%0.2290
omega_D=deg2rad(gyro_n1(3,:)+zbias);
gyro_heAngle=microelementIntegral(sampling_rate,omega_D,deg2rad(-90));
gyroAnglePlot("Heading from Gyro",sec,(rad2deg(gyro_heAngle)));
%% 6th fig: Heading Angle Magnetometer+from Gyro
mgAnglePlot("Heading from Magnetometers+Gyro",sec,rad2deg(magn_heAngle),rad2deg(gyro_heAngle));
%% 7th fig: Steps Detection
acce=sqrt(rawAcce.x_Acce.^2+rawAcce.y_Acce.^2+rawAcce.z_Acce.^2);
acceNoG=acce-mean(acce);
[locs,countSteps1,countSteps2]=stepDetPlot("Steps Detection based on mag+thres","Steps Detection based on magNoG+std",sec,acce,acceNoG,8.2);
%% 8th fig: PDR based on magnetometer and locs
[PDRposGyro,PDRposMagn]=PDRPlot("PDR using heading from magnetometers and gyros",[0,0],locs,sec,magn_heAngle,gyro_heAngle);



