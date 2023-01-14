clc;clear;

matpath="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230114_below5\230114_140105_y_5_y0_225\230114_140105_.mat"
load(matpath)

hmn_path=getHumanPath(t,hmn);
footprint=getFootprint(t,z,u,env,rbt,hmn,sns);
success_list=find(footprint>0,nnz(footprint))
first_success_idx=success_list(1);
last_success_idx=success_list(end);

continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,266))