function maxErr = getMaxErrGrid(soln1,soln2,scale)
%
% The function returns the maximum normalized error between the trajectory
% in soln and test, by evaluating soln at a set of 100 uniformly spaced
% grid points.
%

t = linspace(soln1.grid.time(1),soln1.grid.time(end),100);

x1 = soln1.interp.state(t);
u1 = soln1.interp.control(t);

x2 = soln2.interp.state(t);
u2 = soln2.interp.control(t);

xErr = x1-x2;
uErr = u1-u2;

qErr = xErr(1:5,:)/scale.angle;
dqErr = xErr(6:10,:)/scale.rate;
uErr = uErr/scale.control;

err = [qErr;dqErr;uErr];
maxErr = max(max(abs(err)));

end