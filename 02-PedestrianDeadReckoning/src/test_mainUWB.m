%% created by Hengzhen Liu, Oct.8, 2023
%% Load data
clc;clear;
load ..\dataset\data_demoUWB1.mat
%% Process data and Plot
%% 1st fig: rawdata=ACCE+GYRO+MAGN
%rawdataPlot("rawSensorData",sec,rawGyro,rawAcce,rawMagn);
%% 2nd fig: Horizontal Angles according to the ACCE
[roll,pitch]=anglePlot("HorizontalAngles(without smoothing)",sec,rawAcce);
roll(roll<0)=roll(roll<0)+2*pi;
%% 3rd fig: SMOOTHED Horizontal Angles
sampling_rate=50; %Sampling rate: 20 Hz
window_len=1; %Smoothing window: 1 sec
% smt_roll=vecsmooth(roll,sampling_rate*window_len);
% smt_pitch=vecsmooth(pitch,sampling_rate*window_len);
smt_roll=smoothdata(roll,1,"movmean",sampling_rate*window_len);
smt_pitch=smoothdata(pitch,1,"movmean",sampling_rate*window_len);
smt_roll(smt_roll>pi)=smt_roll(smt_roll>pi)-2*pi;
sthAnglePlot("HorizontalAngles(smoothing window=1s)",sec,rad2deg(smt_roll),rad2deg(smt_pitch));
clear window_len;
%% 4th fig: Heading Angle from Gyro
C_b2n1=[];
for i=1:length(smt_pitch)
    C_b2n1=[C_b2n1;{rotMat("pitch",-smt_pitch(i))*rotMat("roll",-smt_roll(i))}];
end
gyro_n1=[];
for i=1:length(C_b2n1)
    gyro_n1=[gyro_n1,C_b2n1{i}*[rawGyro.x_Gyro(i);rawGyro.y_Gyro(i);rawGyro.z_Gyro(i)]];
end
% Attention: Under the premise of a sampling rate of 20Hz, it is considered that
% the pedestrian's pace is close to a uniform speed within the sampling interval, 
% and the integration is performed based on the vertical angular velocity of the gyroscope.
%zbias=0.0056855;%0.0056855  0.0063155
zbias=0.001;
%zbias=0;
omega_D=deg2rad(gyro_n1(3,:)+zbias);
gyro_heAngle=microelementIntegral(sampling_rate,omega_D,deg2rad(-90));
gyroAnglePlot("Heading from Gyro",sec,(rad2deg(gyro_heAngle)));

%gyroAnglePlot("Heading from Gyro",sec,medfilt1((rad2deg(gyro_heAngle)),60));
%gyroAnglePlot("Heading from Gyro",sec,((gyro_heAngle)));
%gyroAnglePlot("Heading from Gyro",sec,smoothdata(gyro_heAngle,1,"gaussian",120));
%gyroAnglePlot("Heading from Gyro",sec,medfilt1((rad2deg(gyro_heAngle+30/180*pi)),70));

%% 6th fig: Heading Angle Magnetometer+from Gyro
%MYmgAnglePlot("Heading from Magnetometers+Gyro",sec,rad2deg(gyro_heAngle));
%% 7th fig: Steps Detection
acce=sqrt(rawAcce.x_Acce.^2+rawAcce.y_Acce.^2+rawAcce.z_Acce.^2);
acceNoG=acce-mean(acce);
[locs,countSteps1,countSteps2]=stepDetPlot("Steps Detection based on mag+thres","Steps Detection based on magNoG+std",sec,acce,acceNoG,8.2);
%% 8th fig: PDR based on magnetometer and locs
[PDRposGyro]=myPDRPlot("PDR using heading from magnetometers and gyros",[0,0],locs,sec,gyro_heAngle);
                                                                                                   %smoothdata(gyro_heAngle,1,"gaussian",80)
                                                                                                   %medfilt1((gyro_heAngle),70)
                                                                                                   %gyro_heAngle
% seclocs=sec(locs);
% dseclocs=diff(seclocs);



function [PDRposGyro,PDRposMagn] = myPDRPlot(name,initPos,locs,sec,gheadingAngle)
% prepare init INFO
x0=initPos(1);      y0=initPos(2);      time=sec(locs);     steplength=0.7;    gheading=gheadingAngle(locs);
PDRposGyro=[x0, y0];            PDRposMagn=[x0, y0];        dt=diff(sec);
%gyro---------------------------------------------------------------------------
x=x0;   y=y0;
for i=2:length(locs)
    scale=dt(i-1)/mean(dt)*steplength;
    dy=scale*cos(gheading(i-1));
    dx=scale*sin(gheading(i-1));
    x=x+dx;
    y=y+dy;
    PDRposGyro=[PDRposGyro;x,y];
end
%plot---------------------------------------------------------------------------
%clf;
figure(9);
set(gcf,'Position',[0,0,800,1200]);

plot(PDRposGyro(:,1),PDRposGyro(:,2),'Color',[0.73 0.47 0.58],LineWidth=2,LineStyle='--');hold on;

set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{posGyro}$','Interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);

xlabel('$\bf{East(m)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{North(m)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{PDR-using-heading-from-and-gyros}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\outfiles\
saveas(gcf,name, 'png');
cd ..\src\
hold off
end







