function IAE = iaeExp( robotPositionError, timeReceive )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
iae_xy=0;
iae_theta=0;
for i=1:length(timeReceive)
    if i==1
        iae_xy=iae_xy+(abs(robotPositionError(i,1))+abs(robotPositionError(i,2)))*timeReceive(i);
    else
        iae_xy=iae_xy+(abs(robotPositionError(i,1))+abs(robotPositionError(i,2)))*(timeReceive(i)-timeReceive(i-1));
    end
    
    if i==1
        iae_theta=iae_theta+abs(robotPositionError(i,3))*timeReceive(i);
    else
        iae_theta=iae_theta+abs(robotPositionError(i,3))*(timeReceive(i)-timeReceive(i-1));
    end  
end
IAE=[iae_xy;iae_theta];
end

