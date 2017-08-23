%Parameters
global P;
P.m=11.4;                     %kg
P.Iv=0.65;                  %kg*m^2
P.r=0.05;                   %m
P.Din=0.147;                %m
P.Dout=0.236;               %m
%P.La=(P.Din+P.Dout)/2;      %m
P.La=0.2425;
P.I0=6*10^(-6);          %kg*m^2
P.kt=0.0208;                %N*m/A
P.kb=0.02076;               %�˴�Ϊ1/328 V/rpm������ʽ���ù�ʵ�λ����V*s/rad��1 V/rpm=30/pi V*s/rad������Ϊ1/328*30/pi=1/34.34;                 
P.n=71;                    %������
P.b0=6.0*10^(-5);           %N*m*s/rad
P.Ra=1.53;                  %��
P.beta0=P.n^2*P.I0/P.r^2;   %beta0,beta1,beta2������
P.beta1=P.n^2*(P.b0+P.kt*P.kb/P.Ra)/P.r^2;
P.beta2=P.n*P.kt/P.r/P.Ra;

% P.w0 = 4;
% P.wc = 8;

% P.w0 = 1;
% P.wc = 20;
% wo =6;

P.w0=1;
% P.wc=5;
% P.wc=8;
P.wc=6;
wo=5;

%wo=15 wo=3~5wc
P.k = [0 0 0]';

P.z1=[0 0 0]';
P.z2=[0 0 0]';
P.z3=[0 0 0]';
P.z4=[0 0 0]';
P.z5=[0 0 0]';
P.nz1=[0 0 0]';
P.nz2=[0 0 0]';
P.nz3=[0 0 0]';
P.nz4=[0 0 0]';
P.nz5=[0 0 0]';
% P.z1=[0.8 0 0]';
% P.z2=[0 -0.8*pi/15 0]';
% P.z3=[-0.8*pi*pi/15/15 0 0]';
%% three order
% P.bt1=[3*wo 0 0;0 3*wo 0;0 0 3*wo];         
% P.bt2=[3*wo*wo 0 0;0 3*wo*wo 0;0 0 3*wo*wo];
% P.bt3=[wo*wo*wo 0 0;0 wo*wo*wo 0;0 0 wo*wo*wo];
%% four order
% P.bt1=[4*wo 0 0;0 4*wo 0;0 0 4*wo];         
% P.bt2=[6*wo*wo 0 0;0 6*wo*wo 0;0 0 6*wo*wo];
% P.bt3=[4*wo*wo*wo 0 0;0 4*wo*wo*wo 0;0 0 4*wo*wo*wo];
% P.bt4=[wo*wo*wo*wo 0 0;0 wo*wo*wo*wo 0;0 0 wo*wo*wo*wo];
% P.bt1=4*wo*eye(3);
% P.bt2=6*wo^2*eye(3);
% P.bt3=4*wo^3*eye(3);
% P.bt4=wo^4*eye(3);
% %% five order
% P.bt1=5*wo*eye(3);
% P.bt2=10*wo^2*eye(3);
% P.bt3=10*wo^3*eye(3);
% P.bt4=5*wo^4*eye(3);
% P.bt5=wo^5*eye(3);
%% three order
P.bt1=3*wo*eye(3);
P.bt2=3*wo^2*eye(3);
P.bt3=wo^3*eye(3);

P.u=[0 0 0]';   
P.nu=[0 0 0]';