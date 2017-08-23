function stateEst = KalmanFilter( statePre, measurement, controlInput, dt )
%kalmanFilter 此处显示有关此函数的摘要
%   此处显示详细说明
persistent Q R;
persistent stateCovPre;
if isempty(stateCovPre)
    stateCovPre=eye(6);
end
Q=0.1*eye(6);
%Q=zeros(6);
R=zeros(3);
% R=zeros(6);

transmitMatrix = [1 0 0 dt 0 0;
                  0 1 0 0 dt 0;
                  0 0 1 0 0 dt;
                  0 0 0 1 0 0;
                  0 0 0 0 1 0;
                  0 0 0 0 0 1;];
transformMatrix = [eye(3) zeros(3)];
% transformMatrix = [eye(3) zeros(3);
%                    zeros(3) eye(3);];

controlMatrix=[zeros(3) zeros(3);
               zeros(3) eye(3)*dt;];
% Prediction stage
statePredict = transmitMatrix * statePre + controlMatrix * controlInput;

stateCovPredic = transmitMatrix * stateCovPre * transmitMatrix' + Q;

% Update stage
kalmanGain = stateCovPredic * transformMatrix' / ( transformMatrix * stateCovPredic * transformMatrix' + R );

stateEst = statePre + kalmanGain * ( measurement - transformMatrix * statePredict );

stateCov = stateCovPredic - kalmanGain * transformMatrix * stateCovPredic;

stateCovPre = stateCov;
end

