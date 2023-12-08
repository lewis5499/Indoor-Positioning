function [PDRposGyro,PDRposMagn] = PDRPlot(name,initPos,locs,sec,mheadingAngle,gheadingAngle)
% prepare init INFO
x0=initPos(1);      y0=initPos(2);      time=sec(locs);     steplength=0.7;  
mheading=mheadingAngle(locs);   gheading=gheadingAngle(locs);
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
%magn---------------------------------------------------------------------------
x=x0;   y=y0;
for i=2:length(locs)
    scale=dt(i-1)/mean(dt)*steplength;
    dy=scale*cos(mheading(i-1));
    dx=scale*sin(mheading(i-1));
    x=x+dx;
    y=y+dy;
    PDRposMagn=[PDRposMagn;x,y];
end
%plot---------------------------------------------------------------------------
%clf;
figure(9);
set(gcf,'Position',[0,0,1200,1200]);

plot(PDRposGyro(:,1),PDRposGyro(:,2),'Color',[0.73 0.47 0.58],LineWidth=2,LineStyle='--');hold on;
plot(PDRposMagn(:,1),PDRposMagn(:,2),'Color',[0.28 0.57 0.54],LineWidth=2,LineStyle='-');

set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
%set(gca,'XTick',-1000:50:1000)
%set(gca,'YTick',-1000:20:1000)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{posGyro}$','$\bf{posMagn}$','Interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
%xlim([-200,100]);

xlabel('$\bf{East(m)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{North(m)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{PDR-using-heading-from-magnetometers-and-gyros}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\tempfiles\
saveas(gcf,name, 'svg');
cd ..\src\
hold off
end

