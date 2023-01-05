function param = getStepTargets(param)

% This function just adds the step length and step time to the param
% struct, so that all scripts are using the same parameters.

param.stepLength = 0.5;
param.stepTime = 0.8;

end