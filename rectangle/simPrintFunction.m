function simPrintFunction()
%% ===== Initial parameters
global P;
style={'k-','b--','g-.','r:','m:'};
lineWidth=2;
P.lambdan=[5 10 15];
IAESim=[0;0];
%% paper graphics
F6=figure('name','x-y plane','position',[50 70 570 450]);
F7=figure('name','theta plane','position',[60 80 570 450]);
F8=figure('name','error','position',[70 90 570 450]);
F9=figure('name','output','position',[80 100 570 450]);
if strcmp('win64',computer('arch'))
    load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\PID+NPID_lambda=',num2str(P.lambda),'.mat'])
elseif strcmp('glnxa64',computer('arch'))
    load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/PID+NPID_lambda=',num2str(P.lambda),'.mat'])
end

IAESim=iaeSim(P.Q-P.QD,P.T);

%% Reference and PID response
%% x-y plane
figure(F6)
plot(P.QD(1,:),P.QD(2,:),style{1},P.Q(1,:),P.Q(2,:),style{2},'LineWidth',lineWidth)
axis([-0.2 1.2 -0.1 1.3])
xlabel('x(m)')
ylabel('y(m)')
hold on
%% theta plane
figure(F7)
plot(P.T,P.QD(3,:),style{1},P.T,P.Q(3,:),style{2},'LineWidth',lineWidth)
axis([0 P.stime -3 10])
xlabel('t(s)')
ylabel('\theta(rad)')
hold on
%% error
figure(F8)
% X error
subplot(311);
plot(P.T,P.Q(1,:)-P.QD(1,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -0.3 0.3])
ylabel('e_x(m)')
hold on
% Y error
subplot(312)
plot(P.T,P.Q(2,:)-P.QD(2,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -0.3 0.3])
ylabel('e_y(m)')
hold on
% theta error
subplot(313);
plot(P.T,P.Q(3,:)-P.QD(3,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -0.3 0.3])
xlabel('t(s)')
ylabel('e_\theta(rad)')
hold on
%% output
figure(F9)
% u1 output
subplot(311);
plot(P.T,P.U(1,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -30 30])
ylabel('u_1(V)')
hold on
% u2 output
subplot(312)
plot(P.T,P.U(2,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -30 30])
ylabel('u_2(V)')
hold on
% u3 output
subplot(313);
plot(P.T,P.U(3,:),style{1},'LineWidth',lineWidth);
axis([0 P.stime -30 30])
xlabel('t(s)','fontname','times new roman','fontweight','bold')
ylabel('u_3(V)')
hold on

for i=1:1:length(P.lambdan)
if strcmp('win64',computer('arch'))
    load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\PID+NPID_lambda=',num2str(P.lambdan(i)),'.mat'])
elseif strcmp('glnxa64',computer('arch'))
    load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/PID+NPID_lambda=',num2str(P.lambdan(i)),'.mat'])
end

IAESim=[IAESim iaeSim(P.QN-P.QD,P.T)];

%% x-y plane
figure(F6)
plot(P.QN(1,:),P.QN(2,:),style{i+2},'LineWidth',lineWidth)
hold on
%% theta plane
figure(F7)
plot(P.T,P.QN(3,:),style{i+2},'LineWidth',lineWidth);
hold on
%% error
figure(F8)
% X error
subplot(311);
plot(P.T,P.QN(1,:)-P.QD(1,:),style{i+1},'LineWidth',lineWidth);
hold on
% Y error
subplot(312)
plot(P.T,P.QN(2,:)-P.QD(2,:),style{i+1},'LineWidth',lineWidth);
hold on
% theta error
subplot(313);
plot(P.T,P.QN(3,:)-P.QD(3,:),style{i+1},'LineWidth',lineWidth);
hold on
%% output
figure(F9)
% u1 output
subplot(311);
plot(P.T,P.UN(1,:),style{i+1},'LineWidth',lineWidth);
hold on
% u2 output
subplot(312)
plot(P.T,P.UN(2,:),style{i+1},'LineWidth',lineWidth);
hold on
% u3 output
subplot(313);
plot(P.T,P.UN(3,:),style{i+1},'LineWidth',lineWidth);
hold on
end
figure(F6)
L1=legend('Reference','Response(PID)',['Response(NPID)-\lambda=',num2str(P.lambdan(1))],['Response(NPID)-\lambda=',num2str(P.lambdan(2))],['Response(NPID)-\lambda=',num2str(P.lambdan(3))]);
%set(L1,'Location','SouthEast')
%set(L1,'box','off','Location','SouthEast');
set(L1,'box','on','position',[0.45 0.35 0.2877 0.1911]);
figure(F7)
L2=legend('Reference','Response(PID)',['Response(NPID)-\lambda=',num2str(P.lambdan(1))],['Response(NPID)-\lambda=',num2str(P.lambdan(2))],['Response(NPID)-\lambda=',num2str(P.lambdan(3))]);
%set(L2,'Location','SouthEast')
%set(L2,'box','off','Location','SouthEast');
set(L2,'box','on','position',[0.2 0.6 0.2877 0.1911]);
figure(F8)
L3=legend('PID',['NPID-\lambda=',num2str(P.lambdan(1))],['NPID-\lambda=',num2str(P.lambdan(2))],['NPID-\lambda=',num2str(P.lambdan(3))]);
%set(L3,'Location','NorthWest','FontSize',6)
%set(L3,'box','off','Location','West');
set(L3,'box','on','position',[0.135 0.3 0.1789 0.1544]);
figure(F9)
L4=legend('PID',['NPID-\lambda=',num2str(P.lambdan(1))],['NPID-\lambda=',num2str(P.lambdan(2))],['NPID-\lambda=',num2str(P.lambdan(3))]);
%set(L4,'Location','NorthWest','FontSize',6)
%set(L4,'box','off','Location','West');
set(L4,'box','on','position',[0.135 0.3 0.1789 0.1544]);
%% Traditional Format Conversion
if 0
    xy_frame=getframe(F6);
    xy_image=frame2im(xy_frame);
    if strcmp('win64',computer('arch'))
        imwrite(xy_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(xy_image,'~/Desktop/paper/latex/ieeeconf/xy_plane.bmp','bmp')
    end
    theta_frame=getframe(F7);
    theta_image=frame2im(theta_frame);
    if strcmp('win64',computer('arch'))
        imwrite(theta_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(theta_image,'~/Desktop/paper/latex/ieeeconf/theta_plane.bmp','bmp')
    end
    error_frame=getframe(F8);
    error_image=frame2im(error_frame);
    if strcmp('win64',computer('arch'))
        imwrite(error_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(error_image,'~/Desktop/paper/latex/ieeeconf/error.bmp','bmp')
    end
    output_frame=getframe(F9);
    output_image=frame2im(output_frame);
    if strcmp('win64',computer('arch'))
        imwrite(output_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\output.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(output_image,'~/Desktop/paper/latex/ieeeconf/output.bmp','bmp')
    end
    if strcmp('glnxa64',computer('arch'))
        unix('cd ~/Desktop/paper/latex/ieeeconf;convert xy_plane.bmp xy_plane.eps; convert theta_plane.bmp theta_plane.eps; convert error.bmp error.eps; convert output.bmp output.eps')
    elseif strcmp('win64',computer('arch'))
        cd C:\Users\dracula\Desktop\paper\latex\ieeeconf\
        system('bitmap2eps xy_plane.bmp xy_plane.eps')
        system('bitmap2eps theta_plane.bmp theta_plane.eps')
        system('bitmap2eps error.bmp error.eps')
        system('bitmap2eps output.bmp output.eps')
        cd D:\OMRS_Projection\OMRS\PID+NPID\rectangle\
    end
end
%% New Format Conversion
if strcmp('win64',computer('arch'))
    figure(F6)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane.eps','epsc')
    figure(F7)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane.eps','epsc')
    figure(F8)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error.eps','epsc')
    figure(F9)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\output.eps','epsc')
elseif strcmp('glnxa64',computer('arch'))
    figure(F6)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/xy_plane.eps','epsc')
    figure(F7)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/theta_plane.eps','epsc')
    figure(F8)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/error.eps','epsc')
    figure(F9)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/output.eps','epsc')
end
IAESim
P.iaeSim=IAESim;
end