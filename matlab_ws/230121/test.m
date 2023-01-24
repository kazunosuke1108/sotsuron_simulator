clc;clear;

% matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230115_constraint\230115_095850_1e3times_true\230115_095850_.mat"
% load(matpath)

% J=objF_pdf(t,z,u,env,rbt,hmn,sns);

% [1,0]>0 & [1,1]>0
% %161を最後に突如0

t=1:1:100
interp_t=1:0.01:100
v=rand([1 100])
interp_v=interp1(t,v,interp_t,'pchip')
plot(t,v)
hold on
plot(interp_t,interp_v)
