function [newThetaVals] = thetaFix(originalThetaVals)
%{
    This fixes the angles so that they keep adding up past +/- 180
    degrees.  
%}

for i = 2:length(originalThetaVals)
    % If you went past -360 degrees
    if ((originalThetaVals(i) - originalThetaVals(i-1)) <=-350)
        
        originalThetaVals(i:end) = 360 + originalThetaVals(i:end);

    % If you went past +360 degrees
    elseif ((originalThetaVals(i) - originalThetaVals(i-1)) >=350)

        originalThetaVals(i:end) = -360 + originalThetaVals(i:end);
    end

    
end

newThetaVals = originalThetaVals;
end