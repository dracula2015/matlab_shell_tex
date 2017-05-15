function IAE = iaeSim( simPositionError, simTime )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
iae_xy=0;
iae_theta=0;
for i=1:length(simTime)
    if i==1
        iae_xy=iae_xy+(abs(simPositionError(1,i))+abs(simPositionError(2,i)))*simTime(i);
    else
        iae_xy=iae_xy+(abs(simPositionError(1,i))+abs(simPositionError(2,i)))*(simTime(i)-simTime(i-1));
    end
    
    if i==1
        iae_theta=iae_theta+abs(simPositionError(3,i))*simTime(i);
    else
        iae_theta=iae_theta+abs(simPositionError(3,i))*(simTime(i)-simTime(i-1));
    end  
end
IAE=[iae_xy;iae_theta];
end

