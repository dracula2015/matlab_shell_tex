function [uavc] = OMRS_NPID_controller(qd,dqd,ddqd,q,dq)
global P;
middleTime=toc;
tic
t3=clock;
global T
%%
deta=0.001;
Ravc=[cos(q(3)), -sin(q(3)), 0;
      sin(q(3)), cos(q(3)), 0;
      0, 0, 1];
DRavc=[-sin(q(3))*dq(3), -cos(q(3))*dq(3), 0;
       cos(q(3))*dq(3), -sin(q(3))*dq(3), 0;
       0, 0, 0];
M2avc=[1.5*P.beta0 + P.m, 0, 0; 
       0, 1.5*P.beta0 + P.m, 0; 
       0 , 0, 3*P.beta0*P.La^2 + P.Iv];
C2avc=[1.5*P.beta1, -P.m*dq(3), 0;
       P.m*dq(3), 1.5*P.beta1, 0;
       0, 0, 3*P.beta1*P.La^2];
Mavc=M2avc*Ravc';
Cavc=C2avc*Ravc'-M2avc*Ravc'*DRavc*Ravc';
Bavc=P.beta2*[-0.5, -0.5, 1;
              0.866, -0.866, 0;
              P.La, P.La, P.La;];
P.f=Mavc^(-1)*Cavc*dq;
P.ne=P.nz1-q;
s=P.nz2-dq+P.nz1-q;
%% NESO
%% four order
%    P.ne=P.nz1-q;
%    P.nz4=P.nz4+P.dt*(-P.bt4*P.ne)
%    P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*P.ne)
%    P.nz2=P.nz2+P.dt*(P.nz3+(Mavc^-1)*Bavc*P.nu-P.bt2*P.ne)
%    P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne)
%% five order GPI
%    P.ne=P.nz1-q;
%    P.nz5=P.dt*(-P.bt5*P.ne);
%    P.nz4=P.nz4+P.dt*(P.nz5-P.bt4*P.ne);
%    P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*P.ne);
%    P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*P.ne);
%    P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne);

%% five order fal s function
%    P.nz5=P.dt*(-P.bt5*fal(s,0.0625,deta));
%    P.nz4=P.nz4+P.dt*(P.nz5-P.bt4*fal(s,0.125,deta));
%    P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*fal(s,0.25,deta));
%    P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*fal(s,0.5,deta));
%    P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*fal(s,1,deta));
% %% five order fal e function
%    P.nz5=P.dt*(-P.bt5*fal(P.ne,0.0625,deta));
%    P.nz4=P.nz4+P.dt*(P.nz5-P.bt4*fal(P.ne,0.125,deta));
%    P.nz3=P.nz3+P.dt*(P.nz4-P.bt3*fal(P.ne,0.25,deta));
%    P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*fal(P.ne,0.5,deta));
%    P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*fal(P.ne,1,deta));
   
% %% three order fal e function
%    P.nz3=P.nz3+P.dt*(-P.bt3*fal(P.ne,0.25,deta));
%    P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*fal(P.ne,0.5,deta));
%    P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*fal(P.ne,1,deta));
%% three order 
   P.nz3=P.nz3+P.dt*(-P.bt3*P.ne);
   P.nz2=P.nz2+P.dt*(P.nz3+P.nu-P.bt2*P.ne);
   P.nz1=P.nz1+P.dt*(P.nz2-P.bt1*P.ne);
%% error of q
   edq=dq-dqd;
   eq=q-qd;   
% %% channel one
%    if (P.lambda*eq(1))^2 > 1
%        P.k(1)=P.wc*P.wc*eq(1)^2;
%    else
%            P.k(1)=P.wc*P.wc*abs(eq(1)^0.5);
%    end
% %% channel two
%    if (P.lambda*eq(2))^2 > 1
%        P.k(2)=P.wc*P.wc*eq(2)^2;
%    else
%            P.k(2)=P.wc*P.wc*abs(eq(2)^0.5);
%    end
% %% channel three   
%    if (P.lambda*eq(3))^2 > 1
%        P.k(3)=P.wc*P.wc*eq(3)^2;
%    else
%            P.k(3)=P.wc*P.wc*abs(eq(3)^0.5);
%    end   
%    P.k(1)=min(P.k(1),5*P.wc*P.wc);
%    P.k(2)=min(P.k(2),5*P.wc*P.wc);
%    P.k(3)=min(P.k(3),5*P.wc*P.wc);
%    P.k=P.gp*P.k;

% %% channel one
%    if (P.lambda*eq(1))^2 > 1
%        P.k(1)=(P.lambda*eq(1))^2;
%    else
%            P.k(1)=abs((P.lambda*eq(1))^0.5);
%    end
% %% channel two
%    if (P.lambda*eq(2))^2 > 1
%        P.k(2)=(P.lambda*eq(2))^2;
%    else
%            P.k(2)=abs((P.lambda*eq(2))^0.5)
%    end
% %% channel three   
%    if (P.lambda*eq(3))^2 > 1
%        P.k(3)=(P.lambda*eq(3))^2;
%    else
%            P.k(3)=abs((P.lambda*eq(3))^0.5);
%    end  

%% channel one
   if (P.lambda*eq(1))^2 > 1
       P.k(1)=(eq(1))^2;
   else
       P.k(1)=abs(eq(1))^0.5;
   end
%% channel two
   if (P.lambda*eq(2))^2 > 1
       P.k(2)=(eq(2))^2;
   else
       P.k(2)=abs(eq(2))^0.5;
   end
%% channel three   
   if (P.lambda*eq(3))^2 > 1
       P.k(3)=(eq(3))^2;
   else
       P.k(3)=abs(eq(3))^0.5;
   end  

   P.k=P.gp*P.k;
   P.k(1)=min(P.k(1),5*P.wc*P.wc);
   P.k(2)=min(P.k(2),5*P.wc*P.wc);
   P.k(3)=min(P.k(3),5*P.wc*P.wc);
   
%%
   P.KpN=[P.wc*P.wc+P.k(1)*P.wc*P.wc 0 0;0 P.wc*P.wc+P.k(2)*P.wc*P.wc 0;0 0 P.wc*P.wc+P.k(3)*P.wc*P.wc];
   P.KdN=[2*P.w0*P.wc 0 0;0 2*P.w0*P.wc 0;0 0 2*P.w0*P.wc];

   P.nu=ddqd-(P.KpN*eq)-(P.KdN*edq)-(P.nz3);
   uavc=((Bavc)^-1)*Mavc*P.nu;
%    uavc=min(uavc,24);
%    uavc=max(uavc,-24);
   if uavc(1) > 24
      uavc(1) = 24;
   elseif uavc(1) < -24
          uavc(1) = -24;
   end
   
   if uavc(2) > 24
      uavc(2) = 24;
   elseif uavc(2) < -24
          uavc(2) = -24;
   end
      
   if uavc(3) > 24
      uavc(3) = 24;
   elseif uavc(3) < -24
          uavc(3) = -24;
   end
   P.nuavc = uavc;
   %%uavc=inv(Bavc)*Mavc*(ddqd-P.Kd*(dq-dqd)-P.Kp*(q-qd))+inv(Bavc)*Cavc*dq
   P.NPIDKP=[P.NPIDKP P.k];
   P.BASCIKP=[P.BASCIKP [P.KpN(1); P.KpN(5); P.KpN(9)]];
   t4=clock;
   T.npidTime=etime(t4,t3);
   P.npidTime=toc;
   tic;
   P.eventTime=[P.npidTime;middleTime+P.npidTime];
%    P.npidTime=toc;
end