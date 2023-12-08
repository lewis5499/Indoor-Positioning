% created by Hengzhen Liu, Sept. 21st, 2023
%% load data and prepare matrix
load ..\dataset\data_demo.mat;
outfile='../tempfiles/demo_output2d_LS.txt';
fop=fopen(outfile,'w+');
% 2D perspective
NUM_baseOBS=6;
Dimension=2;
% MODEL: v= B*x-l, B=[vecbN,vecbE]
vecbN=zeros(NUM_baseOBS,1);
vecbE=zeros(NUM_baseOBS,1);
% vecbU=zeros(NUM_baseOBS,1);
l=zeros(NUM_baseOBS,1);
d0=zeros(NUM_baseOBS,1);
d=zeros(NUM_baseOBS,1);
% default:  P=Q=I (NUM_baseOBS*NUM_baseOBS)
% we do not know the variance INFO
P=eye(NUM_baseOBS);
Q=inv(P);
% corr
x=zeros(Dimension,1);
MAXCorr=1;
% params
X=zeros(Dimension,1);
allX=[];
allVal=[];
bounded_data=[];
B=zeros(NUM_baseOBS,Dimension);
Q_dop=zeros(Dimension,Dimension);
% set the initial info
% X0=[mean(base_E(:,2));mean(base_N(:,3))];
X0=[mean(matbasestat(:,2));mean(matbasestat(:,3))];
statN=matbasestat(:,2);  %base_E
statE=matbasestat(:,3);  %base_N
%% Calculation
maxepoch=height(range);
for nepoch=1:maxepoch
    %% LS-single epoch: Iterations
    n=1;
    MAXCorr=1;
    while abs(MAXCorr)>1e-8&&n<10
        for i=1:NUM_baseOBS
            d0(i)=sqrt((statN(i)-X0(1))^2+(statE(i)-X0(2))^2);
            vecbN(i)=-(statN(i)-X0(1))/d0(i);
            vecbE(i)=-(statE(i)-X0(2))/d0(i);
        end
        d=[base1D(nepoch);base2D(nepoch);base3D(nepoch);base4D(nepoch);base5D(nepoch);base6D(nepoch)];
        l=d-d0;
        B=[vecbN,vecbE];
        x=inv(B'*P*B)*B'*P*l;
        X0=X0+x;
        MAXCorr=max(x);
        n=n+1;
    end
    v=B*x-l;
    X=X0';

    Q_dop=inv(B'*P*B);
    N_dop=Q_dop(1,1);
    E_dop=Q_dop(2,2);
    m0=sqrt(v'*P*v/(NUM_baseOBS-Dimension));
    Dxx=m0*m0*Q_dop;
    % we set the prior mean square error as the unit weight mean square error
    % and P=Q=I 
    Val=v'*v;
    iter=n-1;
    allX=[allX;X];
    allVal=[allVal;Val];
    disp("Epoch "+string(nepoch)+" : iteration times = "+string(iter));
    disp("MAXCorr = "+string(MAXCorr));
    % save data
    fprintf(fop,'%s','>');
    fprintf(fop,'%13s %14s %14s\r\n','E(m)','N(m)','Time(ms)');
    fprintf(fop,'%14.4f %14.4f %14.4f\r\n',X(1),X(2),sec(nepoch));
    fprintf(fop,"Posterior Unit Weight Error(m):%13.8f\r\n",m0);
    fprintf(fop,"Posterior Estimated Variance(m^2):\r\n");
    fprintf(fop,'%14.4f %14.4f\r\n',Dxx(1,:));
    fprintf(fop,'%14.4f %14.4f\r\n',Dxx(2,:));
    fprintf(fop,"N_dop:%10.4f       E_dop:%10.4f\r\n",N_dop,E_dop);
end
% eliminate the outliers: Chi-Square Distribution test
% Attention! it has changed the sec, allX, Up (delete outliers' lines)
bounded_data=[sec,allVal,allX,Up];
%[sec,allX,Up,bounded_data]=eliminate_outliers(bounded_data(:,:),0.15,NUM_baseOBS-Dimension,Dimension);
%[sec,allX,Up,bounded_data]=eliminate_outliers(bounded_data(1:6600,:),0.15,NUM_baseOBS-Dimension,Dimension);
[sec,allX,Up,bounded_data]=eliminate_outliers(bounded_data(6600:end,:),0.15,NUM_baseOBS-Dimension,2);
fclose(fop);
%% Visualization
test_visualization(sec,allX,Up,matbasestat);
%animated(sec,allX,Up,matbasestat);

%% function: test_visualization
function [] =test_visualization(time,X_total,elevation,baseinfo)%designed by hzLiu,2023.7.4
% Drone-Trajectory2D
clf;
figure(1);
name='DroneTrajectory2D';
set(gcf,'Position',[0 0 600 1500])
scatter(X_total(:,2),X_total(:,1),10,[0, 0.45, 0.75],"filled");hold on
scatter(baseinfo(:,3),baseinfo(:,2),28,"black","filled");
plot(X_total(:,2),X_total(:,1),'Color',[0.88, 0.4, 0.4],LineWidth=1);
box on
set(gca,'linewidth',1.8);
set(gca,'fontsize',14,'fontname','Times','FontWeight','bold')
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{Pos}$','$\bf{basePos}$','$\bf{Trace}$','interpreter','latex','FontSize',10.5); 
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
xlim([-1,8]);
%ylim([-10,10]);
xlabel('$\bf{E(m)}$','interpreter','latex','FontSize', 17)
ylabel('$\bf{N(m)}$','interpreter','latex','FontSize', 17)  
title({'$\bf{Drone-Trajectory(2D)}$'}, 'interpreter','latex','FontSize', 19);
cd ../tempfiles/
saveas(gcf, name, 'svg');
hold off
cd ../src/
% Drone-Trajectory3D
%clf;
figure(2);
set(gcf,'Position',[100 100 1080 680])
name='DroneTrajectory3D';
grid on; 
scatter3(X_total(:,2),X_total(:,1),elevation, 10, 'filled', 'MarkerFaceColor', [0,0.44,0.74]);hold on;
scatter3(0,0,0, 40, 'filled', 'MarkerFaceColor', [1,0,0]);
scatter3(baseinfo(:,3),baseinfo(:,2),baseinfo(:,4),28,"black","filled");
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
title({'$\bf{Drone-Trajectory(3D)}$'}, 'interpreter','latex','FontSize', 19);
xlabel('$\bf{E(m)}$','interpreter','latex','FontSize', 17)
ylabel('$\bf{N(m)}$','interpreter','latex','FontSize', 17)  
zlabel('$\bf{U(m)}$','interpreter','latex','FontSize', 17)
%box on;
legend1=legend('$\bf{devicePos}$','$\bf{O-xyz}$','$\bf{basePos}$','interpreter','latex','FontSize',10.5,'Location','northeast'); 
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
set(gca,'linewidth',1.2);
set(gca,'XTick',-600:2:600,'fontsize',14,'fontname','Times','FontWeight','bold')
set(gca,'YTick',-600:2:600,'fontsize',14) 
set(gca,'ZTick',-600:1:600,'fontsize',14)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off','ZGrid','on','ZMinorGrid','off');
%axis tight equal;  
hold off;
cd ../tempfiles/
saveas(gcf, name, 'svg');
cd ../src/
end









