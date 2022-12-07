footprint=getFootprint(t,z,u,env,rbt,hmn,sns,soln);
hmn_path=getHumanPath(t,hmn);

success_list=find(footprint>0,nnz(footprint));
first_success_idx=success_list(1);
last_success_idx=success_list(end);

continuous=all(footprint(success_list)>0)

hmn_path(1,first_success_idx)
hmn_path(1,last_success_idx)

observed_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx))
% 229~532