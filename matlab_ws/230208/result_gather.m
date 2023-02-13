clc;clear;

motherdir="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230208\results\2022h_230211_1900_parameter_study_d455_ymax_4";
% motherdir="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230121\results\2022h_230122_1800_parameter_study_d455_no_offset";
dirlist=dir(motherdir);
fig=figure(1); clf;


for n = 3:length(dirlist)
    % try
        fullpath = fullfile(dirlist(n).folder, dirlist(n).name);
        matpath = dir(fullpath+"\*.mat");
        fullmatpath=string(matpath.folder)+"\"+string(matpath.name);
        load(fullmatpath)

        %% grid
        t = soln.grid.time;
        z = soln.grid.state;
        u = soln.grid.control;

        t_interp=linspace(t(1),t(end),15*(n-1)+1);
        z_interp=[interp1(t,z(1,:),t_interp);...
        interp1(t,z(2,:),t_interp);...
        interp1(t,z(3,:),t_interp);...
        interp1(t,z(4,:),t_interp);...
        interp1(t,z(5,:),t_interp);...
        interp1(t,z(6,:),t_interp)];
        u_interp=[interp1(t,u(1,:),t_interp);...
        interp1(t,u(2,:),t_interp);...
        interp1(t,u(3,:),t_interp)];


        footprint_interp=getFootprint(t_interp,z_interp,u_interp,env,rbt,hmn,sns);
        hmn_path_interp=getHumanPath(t_interp,hmn);
        footprint=getFootprint(t,z,u,env,rbt,hmn,sns);
        hmn_path=getHumanPath(t,hmn);

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
        measured_length=measure_length(t,z,u,env,rbt,hmn,sns,soln);
        
        vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[z(1,:);z(2,:)];
        e=[cos(z(3,:));sin(z(3,:))];
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        furikaeri=max(abs(z(3,:)));
        yukkuri=min(z(4,:));

        norm_vel=sqrt(z(4,:).^2+z(5,:).^2);

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
        v_min=min(norm_vel);
        v_max=max(norm_vel);
        omg_minim=min(z(6,:));
        omg_maxim=max(z(6,:));

        accx_min=min(u(1,:));
        accx_max=max(u(1,:));
        accy_min=min(u(2,:));
        accy_max=max(u(2,:));
        accth_min=min(u(3,:));
        accth_max=max(u(3,:));

        % env_x_minim=min(z(1,:));
        % env_x_maxim=max(z(1,:));
        % env_y_minim=min(z(2,:));
        % env_y_maxim=max(z(2,:));
        % env_th_minim=min(z(3,:));
        % env_th_maxim=max(z(3,:));
        % % env_vx_minim=min(z(4,:));
        % % env_vx_maxim=max(z(4,:));
        % % env_vy_minim=min(z(5,:));
        % % env_vy_maxim=max(z(5,:));
        % env_omg_minim=min(z(6,:));
        % env_omg_maxim=max(z(6,:));

        result_matrix=[
            env.xmin,... %制約 
            env.xmax,...
            env.ymin,...
            env.ymax,...
            rbt.thmin,...
            rbt.thmax,...
            rbt.vxmin,...
            rbt.vxmax,...
            rbt.vymin,...
            rbt.vymax,...
            rbt.vmax,...
            rbt.omgmin,...
            rbt.omgmax,...
            rbt.axmin,...
            rbt.axmax,...
            rbt.aymin,...
            rbt.aymax,...
            rbt.aangmin,...
            rbt.aangmax,...
            rbt.xF,...
            rbt.yF,...
            rbt.thFmin,...
            rbt.vx0,...
            rbt.vy0,...
            rbt.omg0,...
            env.final_tmax,...
            sns.r1,...
            env.l,...
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
            v_max,...
            omg_minim,...
            omg_maxim,...  
            accx_min,...
            accx_max,...
            accy_min,...
            accy_max,...
            accth_min,...
            accth_max,...
            z(1,end),...
            z(2,end),...
            z(3,end),...
            z(4,end),...
            z(5,end),...
            z(6,end),...
            t(1,end),...
            min(norm_HR),...
            measured_length,...
            continuous_check,...
            soln.info.nlpTime,...
            soln.info.exitFlag,...
            hmn.vx,...
            hmn.y0
            ];
            
            % pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);

        if measured_length<5
            figure(2); clf;
            savename_3_anim=savename+"_3_anim";
            % drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
            drawAnimation_z8(t,z,z8,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
        end
        if n ~= length(dirlist)
            hold on
        end
        % saveas(figure(1),motherdir+"\results_grid.png");
        writematrix(result_matrix,motherdir+"\results_grid.csv",'WriteMode','append');
        if n==length(dirlist)
            clearvars -except motherdir dirlist matpath fullmatpath n;
        end
        % catch
        %     disp(fullmatpath)
        %     continue
        % end
        disp("iter")
            
end

% results=readmatrix(motherdir+"\results_grid.csv");
% list_y0=results(:,61);
% list_vx=results(:,60)
% list_length=results(:,56);
% list_length=reshape(list_length,length(unique(list_y0)),[]);
% list_length=transpose(list_length);
% list_avoid=results(:,55);
% list_avoid=reshape(list_avoid,length(unique(list_y0)),[]);
% list_avoid=transpose(list_avoid);

% len_ok_idx=find(list_length>=5);
% len_ng_idx=find(list_length<5);
% avoid_ok_idx=find(list_avoid>=hmn.personal_r);
% avoid_ng_idx=find(list_avoid<hmn.personal_r);


% [X,Y]=meshgrid(unique(list_vx),unique(list_y0));
% subplot(1,2,1)
% % surf(X,Y,list_length)
% plot3(X(len_ok_idx),Y(len_ok_idx),list_length(len_ok_idx),'ob')
% hold on
% plot3(X(len_ng_idx),Y(len_ng_idx),list_length(len_ng_idx),'or')
% xlabel("vx [m/s]")
% ylabel("y0 [m]")
% zlabel("measured length [m]")
% title("measured length: vx:"+string(hmn.vx)+"[m/s] y0:"+string(hmn.y0)+" [m]")
% grid on

% subplot(1,2,2)
% plot3(X(avoid_ok_idx),Y(avoid_ok_idx),list_avoid(avoid_ok_idx),'ob')
% hold on
% plot3(X(avoid_ng_idx),Y(avoid_ng_idx),list_avoid(avoid_ng_idx),'or')
% xlabel("vx [m/s]")
% ylabel("y0 [m]")
% zlabel("minimum distance between hmn & rbt [m]")
% title("minimum distance hmn <--> rbt: vx:"+string(hmn.vx)+"[m/s] y0:"+string(hmn.y0)+" [m]")
% grid on
% saveas(fig,motherdir+"\results.fig")