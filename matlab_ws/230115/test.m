clc;clear;

matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230115_constraint\230115_095850_1e3times_true\230115_095850_.mat"
load(matpath)

J=objF_pdf(t,z,u,env,rbt,hmn,sns);

[1,0]>0 & [1,1]>0
%161を最後に突如0