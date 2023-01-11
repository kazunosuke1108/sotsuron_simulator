clc;clear;
matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230111\results\230111_initial_guess\230111_155227_DEV_2_1.2\230111_155227_.mat"
load(matpath);
hmn_path=getHumanPath(t,hmn);
footprint=getFootprint(t,z,u,env,rbt,hmn,sns);
success_list=find(footprint>0,nnz(footprint))
first_success_idx=success_list(1);
last_success_idx=success_list(end);

continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx));