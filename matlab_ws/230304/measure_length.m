function measured_length=measure_length(t,z,u,env,rbt,hmn,sns,soln)
    [z10,u5]=getz10(z,u,0)
    n=length(t);
    [t_interp,z_interp,z10_interp,u_interp]=linear_interp(t,z,z10,u);
    footprint_interp=getFootprint(t_interp,z_interp,u_interp,env,rbt,hmn,sns);
    hmn_path_interp=getHumanPath(t_interp,hmn);

    %%%%% how long measured?
    success_list=find(footprint_interp>0,nnz(footprint_interp));
    first_success_idx=success_list(1);
    last_success_idx=success_list(end);
    continuous_check=all(footprint_interp(first_success_idx:last_success_idx)>0);

    i=1;
    for success = success_list(1:end-1)
        if success+1==success_list(i+1)
            last_success_idx=success;
        else
            last_success_idx=success;
            break
        end
        i=i+1;
    end
    measured_length=abs(hmn_path_interp(1,first_success_idx)-hmn_path_interp(1,last_success_idx));
    % hmn_path_interp
    % hmn_path_interp(1,first_success_idx)
    % hmn_path_interp(1,last_success_idx)
    
end