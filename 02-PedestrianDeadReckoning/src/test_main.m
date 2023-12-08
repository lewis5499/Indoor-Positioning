%% created by Hengzhen Liu, Oct.8, 2023
%% Load data
clc;clear;
load ..\dataset\data_demo.mat
mode="L";
zbias=[];
zscale=[];
initYaw=[];
%% Process data and Plot
%% 1st fig: rawdata=ACCE+GYRO+MAGN
rawGyro.x_Gyro=rad2deg(rawGyro.x_Gyro);
rawGyro.y_Gyro=rad2deg(rawGyro.y_Gyro);
rawGyro.z_Gyro=rad2deg(rawGyro.z_Gyro);
rawdataPlot("rawSensorData",sec,rawGyro,rawAcce,rawMagn);
%% 2nd fig: Horizontal Angles according to the ACCE
[roll,pitch]=anglePlot("HorizontalAngles(without smoothing)",sec,rawAcce);
roll(roll<0)=roll(roll<0)+2*pi;
%% 3rd fig: SMOOTHED Horizontal Angles
sampling_rate=80; %60 %Sampling rate: 100 Hz
window_len=1; %Smoothing window: 1 sec
smt_roll=vecsmooth(roll,sampling_rate*window_len);
smt_pitch=vecsmooth(pitch,sampling_rate*window_len);
smt_roll(smt_roll>pi)=smt_roll(smt_roll>pi)-2*pi;
sthAnglePlot("HorizontalAngles(smoothing window=1s)",sec,rad2deg(smt_roll),rad2deg(smt_pitch));
clear window_len;
%% 4th fig: Heading Angle from Magnetometer
C_b2n1=[];
for i=1:length(smt_pitch)
    C_b2n1=[C_b2n1;{myrotMat("pitch",-smt_pitch(i),mode)*myrotMat("roll",-smt_roll(i),mode)}];
end
magn_n1=[];
for i=1:length(C_b2n1)
    magn_n1=[magn_n1,C_b2n1{i}*[rawMagn.x_Magn(i);rawMagn.y_Magn(i);rawMagn.z_Magn(i)]];
end
magn_D=5.11;
magn_heAngle=(-atan2(magn_n1(2,:),magn_n1(1,:))+deg2rad(magn_D)).';
% magn angle-> [-180, 180)
magnAnglePlot("Heading from Magnetometers",sec,(rad2deg(magn_heAngle)));
%  % magn angle-> [0, 360)
%magnAnglePlot("Heading from magnetometers",sec,mod(rad2deg(magn_heAngle),360.0));
%% 5th fig: Heading Angle from Gyro
gyro_n1=[];
for i=1:length(C_b2n1)
    gyro_n1=[gyro_n1,C_b2n1{i}*[rawGyro.x_Gyro(i);rawGyro.y_Gyro(i);rawGyro.z_Gyro(i)]];
end
% Attention: Under the premise of a sampling rate of 20Hz, it is considered that
% the pedestrian's pace is close to a uniform speed within the sampling interval, 
% and the integration is performed based on the vertical angular velocity of the gyroscope.
if mode=="R"
    %NED
    zbias=0.13;%0.15
    zscale=1.20;%1.27
    initYaw=-40;
end
if mode=="L"
    %NEU
    zbias=-0.03;
    zscale=1.19;%1.7
    initYaw=-40;
end
omega_D=deg2rad(gyro_n1(3,:)+zbias)/zscale;
gyro_heAngle=microelementIntegral(sampling_rate,omega_D,deg2rad(initYaw));%-39.75
gyroAnglePlot("Heading from Gyro",sec,rad2deg(gyro_heAngle));

%% 6th fig: Heading Angle Magnetometer+from Gyro
mgAnglePlot("Heading from Magnetometers+Gyro",sec,rad2deg(magn_heAngle),rad2deg(gyro_heAngle));
%% 7th fig: Steps Detection
acce=sqrt(rawAcce.x_Acce.^2+rawAcce.y_Acce.^2+rawAcce.z_Acce.^2);
acceNoG=acce-mean(acce);
[locs,countSteps1,countSteps2]=stepDetPlot("Steps Detection based on mag+thres","Steps Detection based on magNoG+std",sec,acce,acceNoG,8.2);
%% 8th fig: PDR based on magnetometer and locs
[PDRposGyro,PDRposMagn]=PDRPlot("PDR using heading from magnetometers and gyros",[0,0],locs,sec,magn_heAngle,gyro_heAngle);

function [mat_rotated] = myrotMat(name,angle,mode)
%% NED-R
if mode=="R"
    if name=="roll"
        mat_rotated=[ 1,       0,            0;
                      0,  cos(angle),  -sin(angle);
                      0,  sin(angle),   cos(angle)];
    elseif name=="pitch"
        mat_rotated=[ cos(angle),   0,   sin(angle);
                          0,        1,       0;
                      -sin(angle),   0,   cos(angle)];
    elseif name=="yaw"
        mat_rotated=[ cos(angle),  -sin(angle),    0;
                      sin(angle),   cos(angle),    0;
                          0,            0,         1];
    end
end
% NEU-L
if mode=="L"
    if name=="roll"
        mat_rotated=[ 1,       0,            0;
                      0,   cos(angle),   sin(angle);
                      0,  -sin(angle),   cos(angle)];
    elseif name=="pitch"
        mat_rotated=[ cos(angle),   0,   -sin(angle);
                          0,        1,       0;
                      sin(angle),   0,   cos(angle)];
    elseif name=="yaw"
        mat_rotated=[  cos(angle),   sin(angle),    0;
                      -sin(angle),   cos(angle),    0;
                           0,            0,         1];
    end
end
end





