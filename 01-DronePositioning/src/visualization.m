function [] = visualization(time,X_total,elevation,baseinfo)%designed by hzLiu,2023.7.4
%% Drone-Trajectory2D
clf;
figure(1);
name='DroneTrajectory2D';
set(gcf,'Position',[100 100 1080 680])
scatter(X_total(:,2),X_total(:,1),25,[0, 0.45, 0.75],"filled");hold on
%scatter(baseinfo(:,2),baseinfo(:,3),28,"black","filled");
plot(X_total(:,2),X_total(:,1),'Color',[0.88, 0.4, 0.4],LineWidth=2);
box on
set(gca,'linewidth',1.8);
set(gca,'XTick',-200:5:200,'fontsize',18,'fontname','Times','FontWeight','bold')
set(gca,'YTick',-300:5:600,'fontsize',18) 
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{Pos}$','$\bf{Trace}$','interpreter','latex','FontSize',10.5); 
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',13);
xlim([-5,25]);
ylim([-10,10]);
xlabel('$\bf{E(m)}$','interpreter','latex','FontSize', 18)
ylabel('$\bf{N(m)}$','interpreter','latex','FontSize', 18)  
title({'$\bf{Drone-Trajectory(2D)}$'}, 'interpreter','latex','FontSize', 22);
cd ../tempfiles/
saveas(gcf, name, 'svg');
hold off
cd ../src/
%% Drone-Trajectory3D
%clf;
figure(2);
set(gcf,'Position',[100 100 1080 680])
name='DroneTrajectory3D';
grid on; 
%plot3(X_total(:,2),X_total(:,1),elevation,'*','MarkerSize',6);
scatter3(X_total(:,2),X_total(:,1),elevation, 22, 'filled', 'MarkerFaceColor', [0,0.44,0.74]);hold on;
scatter3(0,0,0, 40, 'filled', 'MarkerFaceColor', [1,0,0]);
scatter3(baseinfo(:,2),baseinfo(:,3),baseinfo(:,6),38,"black","filled");
zlim([0 4]);
arrow_start = [0, 0, 0];
arrow_end_x = [max(X_total(:,2))+1, 0, 0];
arrow_end_y = [0, max(X_total(:,1))+1, 0];
arrow_end_z = [0, 0, max(elevation)+1];
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
        arrow_end_x(1), arrow_end_x(2), arrow_end_x(3), ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
        arrow_end_y(1), arrow_end_y(2), arrow_end_y(3), ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
        arrow_end_z(1), arrow_end_z(2), arrow_end_z(3), ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
title({'$\bf{Drone-Trajectory(3D)}$'}, 'interpreter','latex','FontSize', 22);
xlabel('$\bf{E(m)}$','interpreter','latex','FontSize', 18)
ylabel('$\bf{N(m)}$','interpreter','latex','FontSize', 18)  
zlabel('$\bf{U(m)}$','interpreter','latex','FontSize', 18)
%box on;
legend1=legend('$\bf{devicePos}$','$\bf{O-xyz}$','$\bf{basePos}$','interpreter','latex','FontSize',10.5,'Location','northeast'); 
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',13);
set(gca,'linewidth',1.2);
set(gca,'XTick',-600:4:600,'fontsize',18,'fontname','Times','FontWeight','bold')
set(gca,'YTick',-600:4:600,'fontsize',18) 
set(gca,'ZTick',-600:1:600,'fontsize',18)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off','ZGrid','on','ZMinorGrid','off');
%axis tight equal;  
hold off;
cd ../tempfiles/
saveas(gcf, name, 'svg');
cd ../src/




