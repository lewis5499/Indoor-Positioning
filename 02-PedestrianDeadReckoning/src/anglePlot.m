function [roll,pitch] = anglePlot(name,sec,rawAcceleration)
%clf;
roll=atan2(-rawAcceleration.y_Acce,-rawAcceleration.z_Acce);
pitch=atan2(rawAcceleration.x_Acce,sqrt(rawAcceleration.y_Acce.^2+rawAcceleration.z_Acce.^2));

figure(2);
set(gcf,'Position',get(0,'ScreenSize'));

plot(sec,rad2deg(roll),'Color',[0.28 0.57 0.54],LineWidth=2);hold on%[0.62 0.49 0.31]%[0.73 0.47 0.58]%[0.26 0.45 0.80]%[0.28 0.57 0.54]
plot(sec,rad2deg(pitch),'Color',[0.73 0.47 0.58],LineWidth=2);

set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
%set(gca,'XTick',0:50:1000)
%set(gca,'YTick',-100:500:100)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{roll}$','$\bf{pitch}$','Interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
%ylim([-10,10]);

xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(deg)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Horizontal-Angles:without-smoothing}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\tempfiles\
saveas(gcf, name, 'svg');
cd ..\src\
hold off

end

