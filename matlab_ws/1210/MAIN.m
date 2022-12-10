clc;clear;
% res=MAIN_func();
res=MAIN_func_iter();
t=res.t;
z=res.z;
disp(size(t))
disp(size(z))
