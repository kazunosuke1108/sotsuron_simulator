motherdir="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230106\results\230107_0000_parameter_study_LRF";

dirlist=dir(motherdir);

for n = 1:length(dirlist)
    try
        fullpath = fullfile(dirlist(n).folder, dirlist(n).name);
        matpath = dir(fullpath+"\*.mat");
        fullmatpath=string(matpath.folder)+"\"+string(matpath.name);
        load(fullmatpath)
        footprint=getFootprint(t,z,u,env,rbt,hmn,sns);

        %%%%% how long measured?
        success_list=find(footprint>0,nnz(footprint));
        first_success_idx=success_list(1);
        last_success_idx=success_list(end);
        continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
        hmn_path=getHumanPath(t,hmn);
        measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx));
        
        vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[z(1,:);z(2,:)];
        e=[cos(z(3,:));sin(z(3,:))];
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        furikaeri=max(abs(z(3,:)));
        yukkuri=min(z(4,:));

        x_minim=min(z(1,:));
        x_maxim=max(z(1,:));
        y_minim=min(z(2,:));
        y_maxim=max(z(2,:));
        th_minim=min(z(3,:));
        th_maxim=max(z(3,:));
        vx_minim=min(z(4,:));
        vx_maxim=max(z(4,:));
        vy_minim=min(z(5,:));
        vy_maxim=max(z(5,:));
        omg_minim=min(z(6,:));
        omg_maxim=max(z(6,:));

        env_x_minim=min(z(1,:));
        env_x_maxim=max(z(1,:));
        env_y_minim=min(z(2,:));
        env_y_maxim=max(z(2,:));
        env_th_minim=min(z(3,:));
        env_th_maxim=max(z(3,:));
        env_vx_minim=min(z(4,:));
        env_vx_maxim=max(z(4,:));
        env_vy_minim=min(z(5,:));
        env_vy_maxim=max(z(5,:));
        env_omg_minim=min(z(6,:));
        env_omg_maxim=max(z(6,:));

        result_matrix=[
            env.xmin,... %制約 
            env.xmax,...
            env.ymin,...
            env.ymax,...
            rbt.thFmin,...
            rbt.thFmax,...
            rbt.vxmin,...
            rbt.vxmax,...
            rbt.vymin,...
            rbt.vymax,...
            rbt.omgmin,...
            rbt.omgmax,...
            x_minim,... % 実際
            x_maxim,...
            y_minim,...
            y_maxim,...
            th_minim,...
            th_maxim,...
            vx_minim,...
            vx_maxim,...
            vy_minim,...
            vy_maxim,...
            omg_minim,...
            omg_maxim,...            

        ]
        
        

        writematrix([env.xmax,env.ymin,hmn.x0,hmn.y0,hmn.vx,t_slack,measured_length,continuous_check,min(norm_HR),soln.info.nlpTime,furikaeri,yukkuri,soln.info.exitFlag,soln.info.objVal,soln.info.iterations],motherdir+"\results.csv",'WriteMode','append');
        clearvars -except motherdir dirlist matpath fullmatpath n;
    catch
        disp(string(dirlist(n).name))
        continue
    end
    
    
    end