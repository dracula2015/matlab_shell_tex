clc 
clear all
%% ===== Initial parameters
P.stime=63;
load('C:\Users\dracula\Desktop\OMRS_Experiment_20170409\1 meters per second PID disturbance\RobotDesire.mat')
load('C:\Users\dracula\Desktop\OMRS_Experiment_20170409\1 meters per second PID disturbance\RobotError.mat')
load('C:\Users\dracula\Desktop\OMRS_Experiment_20170409\1 meters per second PID disturbance\RobotInfo.mat')
load('C:\Users\dracula\Desktop\OMRS_Experiment_20170409\1 meters per second PID disturbance\RobotData.mat')
%% Display
F1=figure('Position',[40 60 1000 900],'name','PID')
%% X-Y plane
subplot(221);
plot(robotPositionDesire(:,1),robotPositionDesire(:,2),'b.-',robotPosition(:,1),robotPosition(:,2),'g.-.')
%rectangle
%axis([-0.2 1.2 -0.1 1.3])
%lemniscate
%axis([-2 2 -2 2])
%circle
axis([-1.5 1.5 -1.5 1.5])
xlabel('x(m)')
ylabel('y(m)')
L1=legend('Reference','Response(NPID)')
set(L1,'Location','SouthEast')
hold on
%% theta plane
subplot(222);
plot(timeReceive(1,:),robotPositionDesire(:,3),'b.-',timeReceive(1,:),robotPosition(:,3),'g.-.')
axis([0 P.stime -3 10])
xlabel('t(s)')
ylabel('\theta(rad)')
L2=legend('Reference','Response(NPID)')
set(L2,'Location','SouthEast')
hold on

%% X error
subplot(627);
plot(timeReceive(1,:),robotPositionError(:,1),'g.-.')
axis([0 P.stime -0.5 0.5])
ylabel('e_x(m)')
hold on
%% Y error
subplot(6,2,9)
plot(timeReceive(1,:),robotPositionError(:,2),'g.-.')
axis([0 P.stime -0.5 0.5])
ylabel('e_y(m)')
L3=legend('NPID')%,'NPID')
set(L3,'Location','NorthWest','FontSize',6)
hold on
%% theta error
subplot(6,2,11);
plot(timeReceive(1,:),robotPositionError(:,3),'g.-.')
axis([0 P.stime -0.5 0.5])
xlabel('t(s)')
ylabel('e_\theta(rad)')
hold on
%% u1 output
subplot(628);
plot(timeReceive(1,:),controlledU(:,1),'g.-.')
axis([0 P.stime -40 40])
ylabel('u_1(V)')
hold on
%% u2 output
subplot(6,2,10)
plot(timeReceive(1,:),controlledU(:,2),'g.-.')
axis([0 P.stime -40 40])
ylabel('u_2(V)')
L4=legend('NPID')%,'NPID')
set(L4,'Location','NorthWest','FontSize',6)
hold on
%% u3 output
subplot(6,2,12);
plot(timeReceive(1,:),controlledU(:,3),'g.-.')
axis([0 P.stime -40 40])
xlabel('t(s)','fontname','times new roman','fontweight','bold')
ylabel('u_3(V)')
hold on