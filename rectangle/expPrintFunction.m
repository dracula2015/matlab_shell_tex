function expPrintFunction()
%% ===== Initial parameters
global P;
style={'k-','b--','g-.','r:','m:'};
lineWidth=2;
P.date=201705162221;
%P.date=20170507
P.lambdan=[5 10 15];
P.etime=63;
IAExp=[0;0];
set(0,'defaultfigurecolor','w')
F10=figure('name','x-y plane','position',[90 110 570 450]);
F11=figure('name','theta plane','position',[100 120 570 450]);
F12=figure('name','error','position',[110 130 570 450]);
F13=figure('name','output','position',[120 140 570 450]);

currentDir=pwd;
filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],'1 meters per second PID disturbance','RobotDesire.mat');
load(filePath)
filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],'1 meters per second PID disturbance','RobotError.mat');
load(filePath)
filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],'1 meters per second PID disturbance','RobotInfo.mat');
load(filePath)
filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],'1 meters per second PID disturbance','RobotData.mat');
load(filePath)

if 0
    if strcmp('win64',computer('arch'))
        load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second PID disturbance\RobotDesire.mat'])
        load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second PID disturbance\RobotError.mat'])
        load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second PID disturbance\RobotInfo.mat'])
        load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second PID disturbance\RobotData.mat'])
    elseif strcmp('glnxa64',computer('arch'))
        load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second PID disturbance/RobotDesire.mat'])
        load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second PID disturbance/RobotError.mat'])
        load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second PID disturbance/RobotInfo.mat'])
        load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second PID disturbance/RobotData.mat'])
    end
end
IAExp=iaeExp(robotPositionError,timeReceive);

%% Display
% F10=figure('Position',[40 60 1000 900],'name','PID');
%% X-Y plane
figure(F10)
plot(robotPositionDesire(:,1),robotPositionDesire(:,2),style{1},robotPosition(:,1),robotPosition(:,2),style{2},'LineWidth',lineWidth)
%rectangle
%axis([-0.2 1.2 -0.1 1.3])
%lemniscate
%axis([-2 2 -2 2])
%circle
axis([-1.5 1.5 -1.5 1.5])
xlabel('x(m)')
ylabel('y(m)')
hold on
%% theta plane
figure(F11)
plot(timeReceive(1,:),robotPositionDesire(:,3),style{1},timeReceive(1,:),robotPosition(:,3),style{2},'LineWidth',lineWidth)
axis([0 P.etime -3 10])
xlabel('t(s)')
ylabel('\theta(rad)')
hold on

%% error
figure(F12)
% X error
subplot(311)
plot(timeReceive(1,:),robotPositionError(:,1),style{1},'LineWidth',lineWidth)
axis([0 P.etime -0.3 0.3])
ylabel('e_x(m)')
hold on
% Y error
subplot(312)
plot(timeReceive(1,:),robotPositionError(:,2),style{1},'LineWidth',lineWidth)
axis([0 P.etime -0.3 0.3])
ylabel('e_y(m)')
hold on
% theta error
subplot(313)
plot(timeReceive(1,:),robotPositionError(:,3),style{1},'LineWidth',lineWidth)
axis([0 P.etime -0.3 0.3])
xlabel('t(s)')
ylabel('e_\theta(rad)')
hold on

%% output
figure(F13)
% u1 output
subplot(311)
plot(timeReceive(1,:),controlledU(:,1),style{1},'LineWidth',lineWidth)
axis([0 P.etime -30 30])
ylabel('u_1(V)')
hold on
% u2 output
subplot(312)
plot(timeReceive(1,:),controlledU(:,2),style{1},'LineWidth',lineWidth)
axis([0 P.etime -30 30])
ylabel('u_2(V)')
hold on
% u3 output
subplot(313)
plot(timeReceive(1,:),controlledU(:,3),style{1},'LineWidth',lineWidth)
axis([0 P.etime -30 30])
xlabel('t(s)')
ylabel('u_3(V)')
hold on

for i=1:1:length(P.lambdan)
    if 0
        if strcmp('win64',computer('arch'))
            load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotDesire.mat'])
            load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotError.mat'])
            load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotInfo.mat'])
            load(['D:\OMRS_Projection\OMRS\PID+NPID\rectangle\OMRS_Experiment_',num2str(P.date),'\1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotData.mat'])
        elseif strcmp('glnxa64',computer('arch'))
            load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotDesire.mat'])
            load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotError.mat'])
            load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotInfo.mat'])
            load(['/media/dracula/文档/OMRS_Projection/OMRS/PID+NPID/rectangle/OMRS_Experiment_',num2str(P.date),'/1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance/RobotData.mat'])
        end
    end
    
    filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],['1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance'],'RobotDesire.mat');
    load(filePath)
    filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],['1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance'],'RobotError.mat');
    load(filePath)
    filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],['1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance'],'RobotInfo.mat');
    load(filePath)
    filePath=fullfile(currentDir,['OMRS_Experiment_',num2str(P.date)],['1 meters per second NPID lmbda_',num2str(P.lambdan(i)),' disturbance'],'RobotData.mat');
    load(filePath)
    
    IAExp=[IAExp iaeExp(robotPositionError,timeReceive)];
    
    %% x-y plane
    figure(F10)
    plot(robotPosition(:,1),robotPosition(:,2),style{i+2},'LineWidth',lineWidth)
    hold on
    %% theta plane
    figure(F11)
    plot(timeReceive(1,:),robotPosition(:,3),style{i+2},'LineWidth',lineWidth)
    hold on
    %% error
    figure(F12)
    % X error
    subplot(311);
    plot(timeReceive(1,:),robotPositionError(:,1),style{i+1},'LineWidth',lineWidth)
    hold on
    % Y error
    subplot(312)
    plot(timeReceive(1,:),robotPositionError(:,2),style{i+1},'LineWidth',lineWidth)
    hold on
    % theta error
    subplot(313);
    plot(timeReceive(1,:),robotPositionError(:,3),style{i+1},'LineWidth',lineWidth)
    hold on
    %% output
    figure(F13)
    % u1 output
    subplot(311);
    plot(timeReceive(1,:),controlledU(:,1),style{i+1},'LineWidth',lineWidth)
    hold on
    % u2 output
    subplot(312)
    plot(timeReceive(1,:),controlledU(:,2),style{i+1},'LineWidth',lineWidth)
    hold on
    % u3 output
    subplot(313);
    plot(timeReceive(1,:),controlledU(:,3),style{i+1},'LineWidth',lineWidth)
    hold on
end
figure(F10)
L1=legend('Reference','Response(PID)',['Response(NPID)-\lambda=',num2str(P.lambdan(1))],['Response(NPID)-\lambda=',num2str(P.lambdan(2))],['Response(NPID)-\lambda=',num2str(P.lambdan(3))]);
%set(L1,'Location','SouthEast','box','off')
set(L1,'box','on','position',[0.4 0.35 0.2877 0.1911]);
figure(F11)
L2=legend('Reference','Response(PID)',['Response(NPID)-\lambda=',num2str(P.lambdan(1))],['Response(NPID)-\lambda=',num2str(P.lambdan(2))],['Response(NPID)-\lambda=',num2str(P.lambdan(3))]);
%set(L2,'Location','SouthEast','box','off')
set(L2,'box','on','position',[0.2 0.6 0.2877 0.1911]);
figure(F12)
L3=legend('PID',['NPID-\lambda=',num2str(P.lambdan(1))],['NPID-\lambda=',num2str(P.lambdan(2))],['NPID-\lambda=',num2str(P.lambdan(3))]);
%set(L3,'Location','NorthWest','FontSize',6,'box','off')
set(L3,'box','on','position',[0.15 0.3 0.1789 0.1544]);
figure(F13)
L4=legend('PID',['NPID-\lambda=',num2str(P.lambdan(1))],['NPID-\lambda=',num2str(P.lambdan(2))],['NPID-\lambda=',num2str(P.lambdan(3))]);
%set(L4,'Location','NorthWest','FontSize',6,'box','off')
set(L4,'box','on','position',[0.15 0.3 0.1789 0.1544]);
%% Traditional Format Conversion
if 0
    xy_frame=getframe(F10);
    xy_image=frame2im(xy_frame);
    if strcmp('win64',computer('arch'))
        imwrite(xy_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane_exp.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(xy_image,'~/Desktop/paper/latex/ieeeconf/xy_plane_exp.bmp','bmp')
    end
    theta_frame=getframe(F11);
    theta_image=frame2im(theta_frame);
    if strcmp('win64',computer('arch'))
        imwrite(theta_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane_exp.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(theta_image,'~/Desktop/paper/latex/ieeeconf/theta_plane_exp.bmp','bmp')
    end
    error_frame=getframe(F12);
    error_image=frame2im(error_frame);
    if strcmp('win64',computer('arch'))
        imwrite(error_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error_exp.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(error_image,'~/Desktop/paper/latex/ieeeconf/error_exp.bmp','bmp')
    end
    output_frame=getframe(F13);
    output_image=frame2im(output_frame);
    if strcmp('win64',computer('arch'))
        imwrite(output_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\output_exp.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(output_image,'~/Desktop/paper/latex/ieeeconf/output_exp.bmp','bmp')
    end
    if strcmp('glnxa64',computer('arch'))
        unix('cd ~/Desktop/paper/latex/ieeeconf;convert xy_plane_exp.bmp xy_plane_exp.eps; convert theta_plane_exp.bmp theta_plane_exp.eps; convert error_exp.bmp error_exp.eps;convert output_exp.bmp output_exp.eps;texi2pdf paper1012.tex')
    elseif strcmp('win64',computer('arch'))
        cd C:\Users\dracula\Desktop\paper\latex\ieeeconf\
        system('bitmap2eps xy_plane_exp.bmp xy_plane_exp.eps &')
        system('bitmap2eps theta_plane_exp.bmp theta_plane_exp.eps &')
        system('bitmap2eps error_exp.bmp error_exp.eps &')
        system('bitmap2eps output_exp.bmp output_exp.eps &')
        cd D:\OMRS_Projection\OMRS\PID+NPID\rectangle\
    end
end
%% New Format Conversion
if 0
    if strcmp('win64',computer('arch'))
        figure(F10)
        saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane_exp.eps','epsc')
        figure(F11)
        saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane_exp.eps','epsc')
        figure(F12)
        saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error_exp.eps','epsc')
        figure(F13)
        saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\output_exp.eps','epsc')
    elseif strcmp('glnxa64',computer('arch'))
        figure(F10)
        saveas(gcf,'~/Desktop/paper/latex/ieeeconf/xy_plane_exp.eps','epsc')
        figure(F11)
        saveas(gcf,'~/Desktop/paper/latex/ieeeconf/theta_plane_exp.eps','epsc')
        figure(F12)
        saveas(gcf,'~/Desktop/paper/latex/ieeeconf/error_exp.eps','epsc')
        figure(F13)
        saveas(gcf,'~/Desktop/paper/latex/ieeeconf/output_exp.eps','epsc')
    end
end
filePath=fullfile(currentDir,'SimExpImages');
figure(F10)
saveas(gcf,[filePath,'\xy_plane_exp.eps'],'epsc')
figure(F11)
saveas(gcf,[filePath,'\theta_plane_exp.eps'],'epsc')
figure(F12)
saveas(gcf,[filePath,'\error_exp.eps'],'epsc')
figure(F13)
saveas(gcf,[filePath,'\output_exp.eps'],'epsc')

IAExp
P.iaeExp=IAExp;
end