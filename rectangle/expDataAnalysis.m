global P
%% Observation and error with optitrack feedback
F1=figure('Position',[40 60 1000 900],'name',['Observation and error with optitrack feedback, ','lambda = ',num2str(P.lambda)]);
%% observed qN x
subplot(621);
plot(P.T,P.NZ1(1,:),'b.-')
axis([0 P.instantTime -1.2 1.2])
ylabel('$x(m)$','interpret','latex')
hold on
%% observed qN y
subplot(623);
plot(P.T,P.NZ1(2,:),'b.-')
axis([0 P.instantTime -1.2 1.2])
ylabel('$y(m)$','interpret','latex')
L1=legend('observed qN');
set(L1,'Location','NorthWest','FontSize',10);
hold on
%% observed qN theta
subplot(625);
plot(P.T,P.NZ1(3,:),'b.-')
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$\theta(rad)$','interpret','latex')
hold on
%% observed dqN x
subplot(622);
plot(P.T,P.NZ2(1,:),'b.-')
axis([0 P.instantTime -1 1])
ylabel('$\dot{x}(m/s)$','interpret','latex')
hold on
%% observed dqN y
subplot(624);
plot(P.T,P.NZ2(2,:),'b.-')
axis([0 P.instantTime -1 1])
ylabel('$\dot{y}(m/s)$','interpret','latex')
L2=legend('observed dqN');
set(L2,'Location','NorthWest','FontSize',10);
hold on
%% observed dqN theta
subplot(626);
plot(P.T,P.NZ2(3,:),'b.-')
axis([0 P.instantTime -5 5])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{\theta}(rad/s)$','interpret','latex')
hold on
%% qN observed error x
subplot(627);
plot(P.T,P.NZ1(1,:)-P.QN(1,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_x(m)$','interpret','latex')
hold on
%% qN observed error y
subplot(6,2,9)
plot(P.T,P.NZ1(2,:)-P.QN(2,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_y(m)$','interpret','latex')
L3=legend('qN observed error');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% qN observed error theta
subplot(6,2,11);
plot(P.T,P.NZ1(3,:)-P.QN(3,:),'r.--');
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$e_\theta(rad)$','interpret','latex')
hold on
%% dqN observed error x
subplot(628);
plot(P.T,P.NZ2(1,:)-P.DQN(1,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_x}(m/s)$','interpret','latex')
hold on
%% dqN observed error y
subplot(6,2,10)
plot(P.T,P.NZ2(2,:)-P.DQN(2,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_y}(m/s)$','interpret','latex')
L4=legend('dqN observed error');
set(L4,'Location','NorthWest','FontSize',10)
hold on
%% dqN observed error theta
subplot(6,2,12);
plot(P.T,P.NZ2(3,:)-P.DQN(3,:),'r.--');
axis([0 P.instantTime -10 10])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{e_\theta}(rad/s)$','interpret','latex')
hold on

%% Optitrack feedback and KalmanFilterEstimation
F14=figure('Position',[40 60 1000 900],'name',['Optitrack feedback and KalmanFilterEstimation, ','lambda = ',num2str(P.lambda)]);
%% feedback qN x
subplot(621);
plot(P.T,P.QN(1,:),'b.-')
axis([0 P.instantTime -1.2 1.2])
ylabel('$x(m)$','interpret','latex')
hold on
%% feedback qN y
subplot(623);
plot(P.T,P.QN(2,:),'b.-')
axis([0 P.instantTime -1.2 1.2])
ylabel('$y(m)$','interpret','latex')
L1=legend('feedback qN');
set(L1,'Location','NorthWest','FontSize',10);
hold on
%% feedback qN theta
subplot(625);
plot(P.T,P.QN(3,:),'b.-')
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$\theta(rad)$','interpret','latex')
hold on
%% feedback dqN x
subplot(622);
plot(P.T,P.DQN(1,:),'b.-')
axis([0 P.instantTime -1 1])
ylabel('$\dot{x}(m/s)$','interpret','latex')
hold on
%% feedback dqN y
subplot(624);
plot(P.T,P.DQN(2,:),'b.-')
axis([0 P.instantTime -1 1])
ylabel('$\dot{y}(m/s)$','interpret','latex')
L2=legend('feedback dqN');
set(L2,'Location','NorthWest','FontSize',10);
hold on
%% feedback dqN theta
subplot(626);
plot(P.T,P.DQN(3,:),'b.-')
axis([0 P.instantTime -5 5])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{\theta}(rad/s)$','interpret','latex')
hold on
%% estimated q x
subplot(627);
plot(P.T,P.STATEST(1,:),'r.--');
axis([0 P.instantTime -1 1])
ylabel('$x(m)$','interpret','latex')
hold on
%% estimated q y
subplot(6,2,9)
plot(P.T,P.STATEST(2,:),'r.--');
axis([0 P.instantTime -1 1])
ylabel('$y(m)$','interpret','latex')
L3=legend('estimated q');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% estimated q theta
subplot(6,2,11);
plot(P.T,P.STATEST(3,:),'r.--');
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$\theta(rad)$','interpret','latex')
hold on
%% estimated dq x
subplot(628);
plot(P.T,P.STATEST(4,:),'r.--');
axis([0 P.instantTime -1 1])
ylabel('$\dot{x}(m/s)$','interpret','latex')
hold on
%% estimated dq y
subplot(6,2,10)
plot(P.T,P.STATEST(5,:),'r.--');
axis([0 P.instantTime -1 1])
ylabel('$\dot{y}(m/s)$','interpret','latex')
L4=legend('estimated dq');
set(L4,'Location','NorthWest','FontSize',10)
hold on
%% estimated dq theta
subplot(6,2,12);
plot(P.T,P.STATEST(6,:),'r.--');
axis([0 P.instantTime -5 5])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{\theta}(rad/s)$','interpret','latex')
hold on

%% Optitrack feedback error with reference trajectory and error with KalmanFilterEstimation
F15=figure('Position',[40 60 1000 900],'name',['Optitrack feedback error with reference trajectory and error with KalmanFilterEstimation, ','lambda = ',num2str(P.lambda)]);
%% qN error x
subplot(621);
plot(P.T,P.QN(1,:)-P.QD(1,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_x(m)$','interpret','latex')
hold on
%% qN error y
subplot(6,2,3)
plot(P.T,P.QN(2,:)-P.QD(2,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_y(m)$','interpret','latex')
L3=legend('qN error');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% qN error theta
subplot(6,2,5);
plot(P.T,P.QN(3,:)-P.QD(3,:),'r.--');
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$e_\theta(rad)$','interpret','latex')
hold on
%% dqN error x
subplot(622);
plot(P.T,P.DQN(1,:)-P.DQD(1,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_x}(m/s)$','interpret','latex')
hold on
%% dqN error y
subplot(6,2,4)
plot(P.T,P.DQN(2,:)-P.DQD(2,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_y}(m/s)$','interpret','latex')
L4=legend('dqN error');
set(L4,'Location','NorthWest','FontSize',10)
hold on
%% dqN error theta
subplot(6,2,6);
plot(P.T,P.DQN(3,:)-P.DQD(3,:),'r.--');
axis([0 P.instantTime -10 10])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{e_\theta}(rad/s)$','interpret','latex')
hold on
%% qN error x
subplot(627);
plot(P.T,P.STATEST(1,:)-P.QN(1,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_x(m)$','interpret','latex')
hold on
%% qN error y
subplot(6,2,9)
plot(P.T,P.STATEST(2,:)-P.QN(2,:),'r.--');
axis([0 P.instantTime -0.1 0.1])
ylabel('$e_y(m)$','interpret','latex')
L3=legend('qN error');
set(L3,'Location','NorthWest','FontSize',10);
hold on
%% qN error theta
subplot(6,2,11);
plot(P.T,P.STATEST(3,:)-P.QN(3,:),'r.--');
axis([0 P.instantTime -0.3 0.3])
xlabel('$t(s)$','interpret','latex')
ylabel('$e_\theta(rad)$','interpret','latex')
hold on
%% dqN error x
subplot(628);
plot(P.T,P.STATEST(4,:)-P.DQN(1,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_x}(m/s)$','interpret','latex')
hold on
%% dqN error y
subplot(6,2,10)
plot(P.T,P.STATEST(5,:)-P.DQN(2,:),'r.--');
axis([0 P.instantTime -2 2])
ylabel('$\dot{e_y}(m/s)$','interpret','latex')
L4=legend('dqN error');
set(L4,'Location','NorthWest','FontSize',10)
hold on
%% dqN error theta
subplot(6,2,12);
plot(P.T,P.STATEST(6,:)-P.DQN(3,:),'r.--');
axis([0 P.instantTime -10 10])
xlabel('$t(s)$','interpret','latex')
ylabel('$\dot{e_\theta}(rad/s)$','interpret','latex')
hold on
