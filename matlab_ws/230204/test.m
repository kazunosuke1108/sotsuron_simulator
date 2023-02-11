clc;clear;

% matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230115_constraint\230115_095850_1e3times_true\230115_095850_.mat"
matpath="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230115_constraint\230115_095850_1e3times_true\230115_095850_.mat"
load(matpath)

% J=objF_pdf(t,z,u,env,rbt,hmn,sns);

% [1,0]>0 & [1,1]>0
% %161を最後に突如0
t=linspace(soln.grid.time(1),soln.grid.time(end),15*(n-1)+1);
size(soln.grid.state)
size(soln.grid.time)
z=interp1(soln.grid.time,soln.grid.state(5,:),t);
u=interp1(soln.grid.time,soln.grid.control(1,:),t);
plot(soln.grid.time,soln.grid.state(5,:))
hold on
plot(t,z)