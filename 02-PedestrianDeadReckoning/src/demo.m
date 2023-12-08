% rawGyro=struct("x_Gyro",x_Gyro,"y_Gyro",y_Gyro,"z_Gyro",z_Gyro);
% rawAcce=struct("x_Acce",x_Acce,"y_Acce",y_Acce,"z_Acce",z_Acce);
% rawMagn=struct("x_Magn",x_Magn,"y_Magn",y_Magn,"z_Magn",z_Magn);
%omega_D=deg2rad(gyro_n1(3,:))+0.004326;
omega_D=deg2rad(gyro_n1(3,:))+0.0048055;
gyro_heAngle=microelementIntegral(sampling_rate,omega_D,deg2rad(-90));
gyroAnglePlot("Heading from Gyro",sec,(rad2deg(gyro_heAngle)));