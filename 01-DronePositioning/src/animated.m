function [] = animated(time,X_total,elevation,~)
%clf;
figure(3);
set(gcf,'Position',[0 0 1000 1500])
grid on;
% prepare
X = X_total(:,2);
Y = X_total(:,1);
Z = elevation;
arrow_start = [0, 0, 0];
arrow_end_x = [max(X_total(:,2))+1, 0, 0];
arrow_end_y = [0, max(X_total(:,1))+1, 0];
arrow_end_z = [0, 0, max(elevation)+1];
% draw init
scatter3(X(1), Y(1), Z(1), 50, 'filled');hold on;
plot3(X(1), Y(1), Z(1), '-r', 'LineWidth', 2);
title({'$\bf{Drone-Trajectory-Animation(3D)}$'}, 'interpreter','latex','FontSize', 24);
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
    arrow_end_x(1), arrow_end_x(2), arrow_end_x(3), ...
    'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
    arrow_end_y(1), arrow_end_y(2), arrow_end_y(3), ...
    'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
quiver3(arrow_start(1), arrow_start(2), arrow_start(3), ...
    arrow_end_z(1), arrow_end_z(2), arrow_end_z(3), ...
    'r', 'LineWidth', 2, 'MaxHeadSize', 0.2);
set(gca,'fontsize',14,'fontname','Times','FontWeight','bold')
xlabel('$\bf{E(m)}$','interpreter','latex','FontSize', 17)
ylabel('$\bf{N(m)}$','interpreter','latex','FontSize', 17)
zlabel('$\bf{U(m)}$','interpreter','latex','FontSize', 17)
% make animation
for i = 2:length(time)
    % renew-add
    scatter3(X(i), Y(i), Z(i), 45, 'filled');hold on;
    plot3(X(i-1:i), Y(i-1:i), Z(i-1:i), '-r', 'LineWidth', 2);
    pause((time(i)-time(i-1))/5000);
    %pause(0.1);
end
hold off;
end

