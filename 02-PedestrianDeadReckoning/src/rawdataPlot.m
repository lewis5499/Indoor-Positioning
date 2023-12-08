function [] = rawdataPlot(name,sec,rawGyro,rawAcce,rawMagn)
figure(1);
clf;
set(gcf,'Position',get(0,'ScreenSize'));

subplot(3,1,1)
plot(sec,rawGyro.x_Gyro,'Color',[0.28 0.57 0.54],LineWidth=1);hold on
plot(sec,rawGyro.y_Gyro,'Color',[0.26 0.45 0.80],LineWidth=1);
plot(sec,rawGyro.z_Gyro,'Color',[0.73 0.47 0.58],LineWidth=1);

set(gca,'linewidth',1.4,'fontsize',12,'fontname','Times','FontWeight','bold');
%set(gca,'XTick',0:2:10,'fontsize',12,'fontname','Times','FontWeight','bold')
%set(gca,'YTick',-200:50:200)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{Gx}$','$\bf{Gy}$','$\bf{Gz}$','interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
%ylim([-10,10]);
%xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(deg/s)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Gyro-data}$'}, 'interpreter','latex','FontSize', 18);

subplot(3,1,2)

plot(sec,rawAcce.x_Acce,'Color',[0.28 0.57 0.54],LineWidth=1);hold on
plot(sec,rawAcce.y_Acce,'Color',[0.26 0.45 0.80],LineWidth=1);
plot(sec,rawAcce.z_Acce,'Color',[0.73 0.47 0.58],LineWidth=1);

set(gca,'linewidth',1.4,'fontsize',12,'fontname','Times','FontWeight','bold');
%set(gca,'XTick',0:2:10,'fontsize',12,'fontname','Times','FontWeight','bold')
%set(gca,'YTick',-100:10:100)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{Ax}$','$\bf{Ay}$','$\bf{Az}$','interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
%ylim([-20,10]);
%xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(m/s^2)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Acce-data}$'}, 'interpreter','latex','FontSize', 18);

subplot(3,1,3)
plot(sec,rawMagn.x_Magn/1000,'Color',[0.28 0.57 0.54],LineWidth=1);hold on
plot(sec,rawMagn.y_Magn/1000,'Color',[0.26 0.45 0.80],LineWidth=1);
plot(sec,rawMagn.z_Magn/1000,'Color',[0.73 0.47 0.58],LineWidth=1);


set(gca,'linewidth',1.4,'fontsize',12,'fontname','Times','FontWeight','bold');
%set(gca,'XTick',0:50:1000)
%set(gca,'YTick',-100:500:100)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{Mx}$','$\bf{My}$','$\bf{Mz}$','interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
%ylim([-10,10]);

xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(Gauss)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Magn-data}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\tempfiles\
saveas(gcf,name, 'svg');
cd ..\src\
hold off
end

