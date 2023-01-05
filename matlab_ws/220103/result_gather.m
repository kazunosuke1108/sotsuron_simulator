motherdir="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\220103\results\230104_parameter_study_D455_x7y4";

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
        
        writematrix([env.xmax,env.ymin,hmn.x0,hmn.y0,hmn.vx,t_slack,measured_length,continuous_check,min(norm_HR),soln.info.nlpTime,furikaeri,yukkuri,soln.info.exitFlag,soln.info.objVal,soln.info.iterations],motherdir+"\results.csv",'WriteMode','append');
        clearvars -except motherdir dirlist matpath fullmatpath n;
    catch
        disp(string(dirlist(n).name))
        continue
    end
    
    
    end