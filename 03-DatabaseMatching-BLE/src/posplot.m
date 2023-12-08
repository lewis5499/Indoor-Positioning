function [] = posplot(name,probpos,refpos)
clf;
figure(1);
set(gcf,'Position',[0,0,800,600]);
%[0.62 0.49 0.31]%[0.73 0.47 0.58]%[0.26 0.45 0.80]%[0.28 0.57 0.54]
plot(probpos(:,1),probpos(:,2),'Color',[0.28 0.57 0.54],LineWidth=2,Marker='o');hold on
scatter(refpos(:,1),refpos(:,2),36,'red',"*");

set(gca,'linewidth',1.4,'fontsize',15,'fontname','Times','FontWeight','bold');
set(gca,'XTick',-100:5:100)
set(gca,'YTick',-100:2.5:100)
set(gca,'XGrid','on','XMinorGrid','off','YGrid','on','YMinorGrid','off');
legend1=legend('$\bf{probPos}$','$\bf{refPos}$','Interpreter','latex','FontSize',10.5);  
set(legend1,'LineWidth',1,'Interpreter','latex','FontSize',10.5);
xlim([-10,15]);
ylim([-5,17.5])
xlabel('$\bf{east(m)}$','interpreter','latex','FontSize', 16)
ylabel('$\bf{north(m)}$','interpreter','latex','FontSize', 16)  
title({'$\bf{Position-solution-and-reference}$'}, 'interpreter','latex','FontSize', 18);
grid on;
cd ..\output\
saveas(gcf,name, 'png');
cd ..\src\
hold off

end

