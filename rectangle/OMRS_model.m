function [DDQ] = OMRS_model(u,q,dq,beta0,beta1,beta2,m,La,Iv)
%OMRS_model Summary of this function goes here
%Detailed explanation goes here
% tic
% t5=clock;
% global T
%global P;
Rav=[cos(q(3)), -sin(q(3)), 0;
     sin(q(3)), cos(q(3)), 0;
     0, 0, 1];
DRav=[-sin(q(3))*dq(3), -cos(q(3))*dq(3), 0;
      cos(q(3))*dq(3), -sin(q(3))*dq(3), 0;
      0, 0, 0];
M2av=[1.5*beta0 + m, 0, 0; 
      0, 1.5*beta0 + m, 0; 
      0 , 0, 3*beta0*La^2 + Iv];
C2av=[1.5*beta1, -m*dq(3), 0;
      m*dq(3), 1.5*beta1, 0;
      0, 0, 3*beta1*La^2];
Mav=M2av*Rav';
Cav=C2av*Rav'-M2av*Rav'*DRav*Rav';
Bav=beta2*[-0.5, -0.5, 1;
            0.866, -0.866, 0;
            La, La, La;];
DDQ=Mav\(Bav*u-Cav*dq);
% t6=clock;
% T.modelTime=etime(t6,t5);
% P.modelTime=toc;
end