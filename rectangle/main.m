clc 
%% ===== Initial parameters
Parameters;
style={'k-','b--','g-.','r:','m:'};
P.gp=20;
P.lambdan=[5,10,15];
P.lambda=15;
P.iaeExp=[];
P.iaeSim=[];

tuning_parameter;
P.Q=[0;0;0];
P.QN=[0;0;0];
P.QD=[0;0;0];
P.U=[0;0;0];
P.UN=[0;0;0];
P.T=[0];
P.dt=0.01;
P.stime=40;
qd_pre=[0;0;0];
dqd_pre=[0;0.25;0];

P.Z1=[0;0;0];
P.Z2=[0;0;0];
P.Z3=[0;0;0];
P.NZ1=[0;0;0];
P.NZ2=[0;0;0];
P.NZ3=[0;0;0];
P.K=[0;0;0];
P.NU=[0;0;0];
P.DDQD=[0;0;0];
P.DQD=[0;0;0];
P.F=[0;0;0];

P.NPIDKP=[0;0;0];
P.BASCIKP=[0;0;0];
%% Initial state for OMRS_RAC_controller
dq_pre=[0;0;0];
dq=dq_pre;
q_pre=[0;0;0];          %[0;0;0];->[0.6;0;0]; 
q=q_pre;
%% Initial state for OMRS_NPID_controller
dqN_pre=[0;0;0];
dqN=dqN_pre;
qN_pre=[0;0;0];
qN=qN_pre;
set(0, 'defaultfigurecolor', 'w')
F1=figure('Position',[40 60 1000 900],'name',['lambda = ',num2str(P.lambda)]);
st=P.stime/4;
%% Main loop
for t=0:P.dt:P.stime
%% rectangle
if(0<=mod(t,4*st) && mod(t,4*st)<st)
    x=mod(t,4*st);
    y=0;
elseif(st<=mod(t,4*st) && mod(t,4*st)<2*st)
    x=st;
    y=mod(t,4*st)-st;
elseif(2*st<=mod(t,4*st) && mod(t,4*st)<3*st)
    x=3*st-mod(t,4*st);
    y=st;
elseif(3*st<=mod(t,4*st) && mod(t,4*st)<4*st)
    x=0;
    y=4*st-mod(t,4*st);
end;
x=x/10;
y=y/10;
%% lemniscate
% x=2*sin(0.05*t*pi);
% y=sin(0.1*t*pi);
%% circle
% x=0.8*cos(pi/15*t);
% y=0.8*sin(pi/15*t);
if t>15
     theta=0.35*(t-15); 
else theta=0;
end;
%theta=0;

%% Desired attitude
qd=[x;y;theta];
dqd=(qd-qd_pre)/P.dt;
qd_pre=qd;
ddqd=(dqd-dqd_pre)/P.dt;
dqd_pre=dqd;

%% OMRS_controller
ddq=OMRS_model(OMRS_controller(qd,dqd,ddqd,q,dq),q,dq);
dq=dq_pre+ddq*P.dt;
%dq_pre=dq;
q=q_pre+dq*P.dt; 
%q_pre=q;

%% OMRS_NPID_controller
ddqN=OMRS_model(OMRS_NPID_controller(qd,dqd,ddqd,qN,dqN),qN,dqN);
dqN=dqN_pre+ddqN*P.dt;
%dqN_pre=dqN;
qN=qN_pre+dqN*P.dt;
%qN_pre=qN;

%% disturbance
if(t==25)
    q(2)=q(2)+0.2;
    qN(2)=qN(2)+0.2;
end;
if(t==35)
    q(1)=q(1)+0.2;
    qN(1)=qN(1)+0.2;
end;
dq_pre=dq;
q_pre=q;
dqN_pre=dqN;
qN_pre=qN;
%% record data
P.Q=[P.Q q];
P.QN=[P.QN qN];
P.QD=[P.QD qd];
P.U=[P.U P.uavc];
P.UN=[P.UN P.nuavc];
P.T=[P.T t];
P.Z1=[P.Z1 P.z1];
P.Z2=[P.Z2 P.z2];
P.Z3=[P.Z3 P.z3];
P.NZ1=[P.NZ1 P.nz1];
P.NZ2=[P.NZ2 P.nz2];
P.NZ3=[P.NZ3 P.nz3];
P.K=[P.K P.k];
P.NU=[P.NU P.nu];
P.DDQD=[P.DDQD ddqd];
P.DQD=[P.DQD dqd];
P.F=[P.F P.f];
t;
P
end
%% Display
%% X-Y plane
subplot(221);
plot(P.QD(1,:),P.QD(2,:),'b.-',P.Q(1,:),P.Q(2,:),'g.-.',P.QN(1,:),P.QN(2,:),'r.--')
%rectangle
axis([-0.2 1.2 -0.1 1.3])
%lemniscate
%axis([-2 2 -2 2])
xlabel('x(m)')
ylabel('y(m)')
L1=legend('Reference','Response(PID)','Response(NPID)');
set(L1,'Location','SouthEast')
hold on
%% theta plane
subplot(222);
plot(P.T,P.QD(3,:),'b.-',P.T,P.Q(3,:),'g.-.',P.T,P.QN(3,:),'r.--');
axis([0 P.stime -3 10])
xlabel('t(s)')
ylabel('\theta(rad)')
L2=legend('Reference','Response(PID)','Response(NPID)');
set(L2,'Location','SouthEast')
hold on

%% X error
subplot(627);
plot(P.T,P.Q(1,:)-P.QD(1,:),'g.-.',P.T,P.QN(1,:)-P.QD(1,:),'r.--');
axis([0 P.stime -0.5 0.5])
ylabel('e_x(m)')
hold on
%% Y error
subplot(6,2,9)
plot(P.T,P.Q(2,:)-P.QD(2,:),'g.-.',P.T,P.QN(2,:)-P.QD(2,:),'r.--');
axis([0 P.stime -0.5 0.5])
ylabel('e_y(m)')
L3=legend('PID','NPID');
set(L3,'Location','NorthWest','FontSize',6);
hold on
%% theta error
subplot(6,2,11);
plot(P.T,P.Q(3,:)-P.QD(3,:),'g.-.',P.T,P.QN(3,:)-P.QD(3,:),'r.--');
axis([0 P.stime -0.5 0.5])
xlabel('t(s)')
ylabel('e_\theta(rad)')
hold on
%% u1 output
subplot(628);
plot(P.T,P.U(1,:),'g.-.',P.T,P.UN(1,:),'r.--');
axis([0 P.stime -40 40])
ylabel('u_1(V)')
hold on
%% u2 output
subplot(6,2,10)
plot(P.T,P.U(2,:),'g.-.',P.T,P.UN(2,:),'r.--');
axis([0 P.stime -40 40])
ylabel('u_2(V)')
L4=legend('PID','NPID');
set(L4,'Location','NorthWest','FontSize',6)
hold on
%% u3 output
subplot(6,2,12);
plot(P.T,P.U(3,:),'g.-.',P.T,P.UN(3,:),'r.--','linewidth',1);
axis([0 P.stime -40 40])
xlabel('t(s)')%,'fontname','times new roman','fontweight','bold')
ylabel('u_3(V)')
hold on

%% paper graphics
%% x-y plane
F2=figure('name','x-y plane','position',[50 70 570 450]);
plot(P.QD(1,:),P.QD(2,:),'b.-',P.Q(1,:),P.Q(2,:),'g.-.',P.QN(1,:),P.QN(2,:),'r.--')
%rectangle
axis([-0.2 1.2 -0.1 1.3])
%lemniscate
%axis([-2 2 -2 2])
xlabel('x(m)')
ylabel('y(m)')
L1=legend('Reference','Response(PID)','Response(NPID)');
set(L1,'Location','northeast')
hold on

%% theta plane
F3=figure('name','\theta plane','position',[60 80 570 450]);
plot(P.T,P.QD(3,:),'b.-',P.T,P.Q(3,:),'g.-.',P.T,P.QN(3,:),'r.--');
axis([0 P.stime -3 10])
xlabel('t(s)')
ylabel('\theta(rad)')
L2=legend('Reference','Response(PID)','Response(NPID)');
set(L2,'Location','SouthEast')
hold on

%% error
F4=figure('name','error','position',[70 90 570 450]);
% X error
subplot(311);
plot(P.T,P.Q(1,:)-P.QD(1,:),'g.-.',P.T,P.QN(1,:)-P.QD(1,:),'r.--');
axis([0 P.stime -0.5 0.5])
ylabel('e_x(m)')
hold on
% Y error
subplot(312)
plot(P.T,P.Q(2,:)-P.QD(2,:),'g.-.',P.T,P.QN(2,:)-P.QD(2,:),'r.--');
axis([0 P.stime -0.5 0.5])
ylabel('e_y(m)')
L3=legend('PID','NPID');
set(L3,'Location','NorthWest','FontSize',6)
hold on
% theta error
subplot(313);
plot(P.T,P.Q(3,:)-P.QD(3,:),'g.-.',P.T,P.QN(3,:)-P.QD(3,:),'r.--');
axis([0 P.stime -0.5 0.5])
xlabel('t(s)')
ylabel('e_\theta(rad)')
hold on

%% output
F5=figure('name','output','position',[80 100 570 450]);
% u1 output
subplot(311);
plot(P.T,P.U(1,:),'g.-.',P.T,P.UN(1,:),'r.--');
axis([0 P.stime -40 40])
ylabel('u_1(V)')
hold on
% u2 output
subplot(312)
plot(P.T,P.U(2,:),'g.-.',P.T,P.UN(2,:),'r.--');
axis([0 P.stime -40 40])
ylabel('u_2(V)')
L4=legend('PID','NPID');
set(L4,'Location','NorthWest','FontSize',6)
hold on
% u3 output
subplot(313);
plot(P.T,P.U(3,:),'g.-.',P.T,P.UN(3,:),'r.--','linewidth',1);
axis([0 P.stime -40 40])
xlabel('t(s)','fontname','times new roman','fontweight','bold')
ylabel('u_3(V)')
hold on
%% Traditional Format Conversion
if 0
    xy_frame=getframe(F2);
    xy_image=frame2im(xy_frame);
    if strcmp('win64',computer('arch'))
        imwrite(xy_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(xy_image,'~/Desktop/paper/latex/ieeeconf/xy_plane.bmp','bmp')
    end
    
    theta_frame=getframe(F3);
    theta_image=frame2im(theta_frame);
    if strcmp('win64',computer('arch'))
        imwrite(theta_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(theta_image,'~/Desktop/paper/latex/ieeeconf/theta_plane.bmp','bmp')
    end
    
    error_frame=getframe(F4);
    error_image=frame2im(error_frame);
    if strcmp('win64',computer('arch'))
        imwrite(error_image,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error.bmp','bmp')
    elseif strcmp('glnxa64',computer('arch'))
        imwrite(error_image,'~/Desktop/paper/latex/ieeeconf/error.bmp','bmp')
    end
    
    output_frame=getframe(F5);
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
    figure(F2)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\xy_plane_origin.eps','epsc')
    figure(F3)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\theta_plane_origin.eps','epsc')
    figure(F4)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\error_origin.eps','epsc')
    figure(F5)
    saveas(gcf,'C:\Users\dracula\Desktop\paper\latex\ieeeconf\output_origin.eps','epsc')
elseif strcmp('glnxa64',computer('arch'))
    figure(F2)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/xy_plane_origin.eps','epsc')
    figure(F3)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/theta_plane_origin.eps','epsc')
    figure(F4)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/error_origin.eps','epsc')
    figure(F5)
    saveas(gcf,'~/Desktop/paper/latex/ieeeconf/output_origin.eps','epsc')
end

%save(['PID+NPID_LAMBDA=',num2str(P.lambda)],'P')
num=['PID+NPID_lambda=',num2str(P.lambda)];
save(num,'P')
simPrintFunction()
expPrintFunction()