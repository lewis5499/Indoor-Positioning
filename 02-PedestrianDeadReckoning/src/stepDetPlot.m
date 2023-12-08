function [locs,num1Steps,num2Steps] = stepDetPlot(name1,name2,sec,mag,magNoG,threshold)

%clf;
figure(7);
set(gcf,'Position',get(0,'ScreenSize'));box on;
MinPeakDistance=4;
[pks0,locs0]=findpeaks(-(mag-mean(mag)),"MinPeakHeight",abs(threshold-mean(mag)),"MinPeakDistance",MinPeakDistance);
num1Steps=numel(locs0);
plot(sec,mag,'Color',[0.28 0.57 0.54],LineWidth=2);hold on%[0.62 0.49 0.31]%[0.73 0.47 0.58]%[0.26 0.45 0.80]%[0.28 0.57 0.54]
plot(sec(locs0),-pks0+mean(mag) , 'r', 'Marker', '+', 'LineStyle', 'none');
%disp(numel(locs0));
set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{accelMag}$','$\bf{step}$','Interpreter','latex','FontSize',10.5);  
%legend1=legend('$\bf{AccelMag}$','latex','FontSize',10.5);
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);

xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(m/s^2)}$','interpreter','latex','FontSize', 16)  
%title({'$\bf{Steps-Detection}$'}, 'interpreter','latex','FontSize', 18);
title({'$\bf{Steps-Detection: based-on-mag}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\tempfiles\
%saveas(gcf,name1, 'svg');
hold off
%-------------------------------------------------------------------------------
figure(8);
scale=0.37;  
minPeakHeight=std(magNoG)*scale;
MinPeakDistance=7;
[pks1,locs1]=findpeaks(-magNoG,"MinPeakHeight",minPeakHeight);
[pks2,locs2]=findpeaks(-magNoG,"MinPeakDistance",MinPeakDistance);
locs = intersect(locs1, locs2);
%disp(numel(locs1));disp(numel(locs2));
num2Steps = numel(locs);
set(gcf,'Position',get(0,'ScreenSize'));box on;

plot(sec,magNoG,'Color',[0.28 0.57 0.54],LineWidth=2);hold on%[0.62 0.49 0.31]%[0.73 0.47 0.58]%[0.26 0.45 0.80]%[0.28 0.57 0.54]
plot(sec(locs),magNoG(locs), 'r', 'Marker', '+', 'LineStyle', 'none');

set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{accelMagNoG}$','$\bf{step}$','Interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);

xlabel('$\bf{Time(s)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{(m/s^2)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Steps-Detection: based-on-magNoG}$'}, 'interpreter','latex','FontSize', 18);
grid on;
saveas(gcf,name2, 'svg');
cd ..\src\
hold off
end

