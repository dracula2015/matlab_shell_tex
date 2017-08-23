function desiredAttitude = RefTrajectory
%RefTrajectory 此处显示有关此函数的摘要
%   此处显示详细说明
global initFinished initialAttitude onStartAttitude P;
if initFinished
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
    desiredAttitude = [x;y;theta];
else
    if P.instantTime < 10
        desiredAttitude = onStartAttitude' + P.instantTime*(initialAttitude - onStartAttitude')/10;
    else desiredAttitude = initialAttitude;
    end
end
end