function maxErr = getMaxErr(soln,test,scale)
%
% The function returns the maximum normalized error between the trajectory
% in soln and test, by evaluating soln at the grid-points in test.
%

t = test.grid.time;
xSoln = soln.interp.state(t);
uSoln = soln.interp.control(t);

xErr = xSoln - test.grid.state;
uErr = uSoln - test.grid.control;

qErr = xErr(1:5,:)/scale.angle;
dqErr = xErr(6:10,:)/scale.rate;
uErr = uErr/scale.control;

err = [qErr;dqErr;uErr];
maxErr = max(max(abs(err)));

end