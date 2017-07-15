function UpdateInstruction( frameOfData )
%UpdateInstruction 此处显示有关此函数的摘要
%   此处显示详细说明
global P;
global s;
global frameRate;
persistent initialFrameTime;
persistent lastFrameTime;
persistent initial;
persistent qd_pre;
persistent dqd_pre;
persistent qN_pre;
persistent dqN_pre;
persistent theta;
persistent qd;
persistent dqd;
persistent ddqd;
persistent qN;
persistent dqN;
persistent ddqN;
persistent voltage;
persistent lastNewFrameTime;
%% initialize statics
if isempty(initial)
    lastFrameTime = frameOfData.fLatency;
    lastNewFrameTime = frameOfData.fLatency;
    initialFrameTime = frameOfData.fLatency;
    % Desired attitude
    theta=0;
    qd=[0;0;0];
    dqd=[0.1;0;0];
    ddqd=[0;0;0];
    qd_pre=[0;0;0];
    dqd_pre=[0;0;0];
    % Robot attitude
    qN=[0;0;0];
    dqN=[0;0;0];
    ddqN=[0;0;0];
    qN_pre=[0;0;0];
    dqN_pre=[0;0;0];
    voltage=[0;0;0;0;0;0];
    fwrite(s,'g');
end
% calculate the frame increment based on mocap frame's timestamp
% in general this should be monotonically increasing according
% To the mocap framerate, however frames are not guaranteed delivery
% so to be accurate we test and report frame drop or duplication
newFrame = true;
droppedFrames = false;
frameTime = frameOfData.fLatency;

P.instantTime = frameTime - initialFrameTime;
wew=P.instantTime;
wew

calcFrameInc = round( (frameTime - lastFrameTime) * frameRate );
if(calcFrameInc > 1)
    % debug
    % fprintf('\nDropped Frame(s) : %d\n\tLastTime : %.3f\n\tThisTime : %.3f\n', calcFrameInc-1, lastFrameTime, frameTime);
    droppedFrames = true;
elseif(calcFrameInc == 0)
    % debug
    % display('Duplicate Frame')
    newFrame = false;
end

% debug
% fprintf('FrameTime: %0.3f\tFrameID: %d\n',frameTime, frameID);
%% main loop
try
    if(newFrame)
        if(frameOfData.RigidBodies.Length() > 0)
            
            rigidBodyData = frameOfData.RigidBodies(1);
            % Test : Marker Y Position Data
            % angleY = data.LabeledMarkers(1).y;
            
            % Test : Rigid Body Y Position Data
            % angleY = rigidBodyData.y;
            
            % Test : Rigid Body 'Yaw'
            % Note : Motive display euler's is X (Pitch), Y (Yaw), Z (Roll), Right-Handed (RHS), Relative Axes
            % so we decode eulers heres to match that.
            q = quaternion( rigidBodyData.qx, rigidBodyData.qy, rigidBodyData.qz, rigidBodyData.qw );
            qRot = quaternion( 0, 0, 0, 1);     % rotate pitch 180 to avoid 180/-180 flip for nicer graphing
            q = mtimes(q, qRot);
            angles = EulerAngles(q,'zyx');
            angleX = -angles(1) * 180.0 / pi;   % must invert due to 180 flip above
            angleY = angles(2) * 180.0 / pi;
            angleZ = -angles(3) * 180.0 / pi;   % must invert due to 180 flip above
            qN(1) = rigidBodyData.x;
            qN(2) = -rigidBodyData.z;
            %qN(3) = angleY;
            qN(3) = angles(2);
            
            %% Reference trajectory
            % rectangle
            if(0<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<P.rectLength)
                x=mod(P.instantTime*P.speed,4*P.rectLength);
                y=0;
            elseif(P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<2*P.rectLength)
                x=P.rectLength;
                y=mod(P.instantTime*P.speed,4*P.rectLength)-P.rectLength;
            elseif(2*P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<3*P.rectLength)
                x=3*P.rectLength-mod(P.instantTime*P.speed,4*P.rectLength);
                y=P.rectLength;
            elseif(3*P.rectLength<=mod(P.instantTime*P.speed,4*P.rectLength) && mod(P.instantTime*P.speed,4*P.rectLength)<4*P.rectLength)
                x=0;
                y=4*P.rectLength-mod(P.instantTime*P.speed,4*P.rectLength);
            end;
            if (P.instantTime > 15)
                theta = 0.35 * (P.instantTime - 15);
            end
            theta=0;
            %% Attitude
            P.dt = frameTime - lastNewFrameTime;
            qd=[x;y;theta];
            % Desired attitude
            dqd=(qd-qd_pre)/P.dt;
            ddqd=(dqd-dqd_pre)/P.dt;
            % Robot attitude
            dqN = (qN - qN_pre)/P.dt;
            ddqN = (dqN-dqN_pre)/P.dt;
            %% Calculate control voltage
            controlVoltage = int32(1000*OMRS_NPID_controller(qd,dqd,ddqd,qN,dqN))
            %controlVoltage=[24000;-24000;24000];
            P.ctrlVolt=[P.ctrlVolt controlVoltage];
            for i = 1:3
                if controlVoltage(i)<0
                    controlVoltage(i)=abs(controlVoltage(i))+32768;
                end
                voltage(2*i-1)=mod(controlVoltage(i),256);
                voltage(2*i)=floor(controlVoltage(i)/256);
            end
            for i=1:6
                if voltage(i)==117 || voltage(i)==115 || voltage(i)==103
                    voltage(i)=voltage(i)+1;
                end
            end
            
%             controlVoltage=[100;1000;1000];
            %controlVoltage=[32868;42768;1000]
%             controlVoltage=[42767;1000;1000]
            %controlVoltage=dec2hex(controlVoltage);
%             controlVoltage=[10000+int32(10000*sin(0.001*P.instantTime));0;0]
%             10000+int32(10000*sin(0.001*P.instantTime))
            fwrite(s,'u');
            %fwrite(s,'%d %d %d',controlVoltage);            
%             fwrite(s,controlVoltage,'uint16');
            fwrite(s,voltage,'uint8');
            %if(droppedFrames)
            if(0)
                j=size(P.T);
                len=j(2);
                for i = 1 : calcFrameInc-1
                    P.T = [P.T (lastFrameTime-initialFrameTime+i/frameRate)];
                    P.QN = [P.QN (qN_pre+(qN-qN_pre)/calcFrameInc*i)];
                    P.QD = [P.QD (qd_pre+(qd-qd_pre)/calcFrameInc*i)];
                    P.NU = [P.NU (P.NU(:,len)+(P.nuavc-P.NU(:,len))/calcFrameInc*i)];
                    P.NZ1 = [P.NZ1 (P.NZ1(:,len)+(P.nz1-P.NZ1(:,len))/calcFrameInc*i)];
                    P.NZ2 = [P.NZ2 (P.NZ2(:,len)+(P.nz2-P.NZ2(:,len))/calcFrameInc*i)];
                    P.NZ3 = [P.NZ3 (P.NZ3(:,len)+(P.nz3-P.NZ3(:,len))/calcFrameInc*i)];
                    P.K = [P.K (P.K(:,len)+(P.k-P.K(:,len))/calcFrameInc*i)];
                    P.DDQD = [P.DDQD (P.DDQD(:,len)+(ddqd-P.DDQD(:,len))/calcFrameInc*i)];
                    P.DQD = [P.DQD (P.DQD(:,len)+(dqd-P.DQD(:,len))/calcFrameInc*i)];
                    P.F = [P.F (P.F(:,len)+(P.f-P.F(:,len))/calcFrameInc*i)];
                end
            end
            P.QD=[P.QD qd];
            P.DQD=[P.DQD dqd];
            P.DDQD=[P.DDQD ddqd];
            P.QN=[P.QN qN];
            P.DQN=[P.DQN dqN];
            P.DDQN=[P.DDQN ddqN];
            P.NU=[P.NU P.nuavc];
            P.T=[P.T P.instantTime];
            P.NZ1=[P.NZ1 P.nz1];
            P.NZ2=[P.NZ2 P.nz2];
            P.NZ3=[P.NZ3 P.nz3];
            P.K=[P.K P.k];
            
            P.F=[P.F P.f];
            if isempty(P.time)
                P.time=P.eventTime;
            else
                P.time=[P.time P.eventTime];
            end
            
            qd_pre=qd;
            dqd_pre=dqd;
            qN_pre=qN;
            dqN_pre=dqN;
            lastNewFrameTime = frameTime;
        end
    end
catch err
    display(err);
end

%% record data
lastFrameTime = frameTime;
initial = 0;
end