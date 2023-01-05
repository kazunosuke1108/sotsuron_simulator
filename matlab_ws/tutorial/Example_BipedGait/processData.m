function Data = processData(Data)
%
% This function runs through the raw data produced by the optimization and
% collects the batch run into some useful statistics.
%

OptSoln = Data.raw;

nTrial = length(OptSoln);
Data.cpuTime = zeros(nTrial,1);
Data.funCount = zeros(nTrial,1);
Data.iterCount = zeros(nTrial,1);
Data.exitFlag = false(nTrial,1);
Data.objVal = zeros(nTrial,1);

for i=1:nTrial
    Data.cpuTime(i) = OptSoln{i}.info.nlpTime;
    Data.funCount(i) = OptSoln{i}.info.funcCount;
    Data.iterCount(i) = OptSoln{i}.info.iterations;
    Data.exitFlag(i) = OptSoln{i}.info.exitFlag;
    Data.objVal(i) = OptSoln{i}.info.objVal;
end

end