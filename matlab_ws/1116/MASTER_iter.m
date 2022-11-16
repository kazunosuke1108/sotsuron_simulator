% MASTER.m

% integrated system

clc; clear;

addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole';
% addpath 'C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole'
mkdir('results');
savedir="results\1116_debug";
mkdir(savedir);
savedir=string(savedir+"\"+datestr(now,'yymmdd_hhMMss'));
mkdir(savedir);
for candidate =[NaN]
    for candidate2=[NaN]
        try
            savename=string(savedir+"\"+datestr(now,'yymmdd_hhMMss'));
            graph_title="DEV debug";

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            %                           seq.0  環境                                   %
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

            env=getEnvironmentParams();
            rbt=getRobotParams();
            hmn=getHumanParams();
            sns=getSensorParams();

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            %                     Overwrite variables                                 %
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

            rbt.vx0=0.15;
            rbt.vy0=0;
            hmn.vx=-0.6;



            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            %                           seq.1  検知                                   %
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            % センサからの取得値を準備
            %% 時系列を設定
            sensor_fps=30;
            sensor_dt=1/sensor_fps;
            seq1_tmax=100;
            t=linspace(0,seq1_tmax,(seq1_tmax-0)*sensor_fps);
            %% 等速直線運動の歩行経路を算出
            hmn_path=getHumanPath(t,hmn);
            %% 等速直線運動で巡回中のロボット経路を算出
            rbt_path=getRobotPath(t,rbt);

            % 歩行速度推定
            num_obs=5; % 移動平均に使用するフレーム数

            vel_list=[];
            relative_path=hmn_path(1:2,:)-rbt_path(1:2,:);
            size(relative_path);
            observed_old=relative_path(:,1);

            for i = 2:num_obs
                observed=relative_path(:,i);
                vel=(observed-observed_old)/sensor_dt;
                vel_list=[vel_list vel];
                observed_old=observed;
            end
            relative_vel=mean(vel_list,2);
            hmn_vel=relative_vel+[rbt.vx0;rbt.vy0];
            hmn.vx=hmn_vel(1);
            hmn.vy=hmn_vel(2);

            % ROI変更
            %% 計測開始時刻を決定
            t0=(hmn_path(1,num_obs)-env.L+env.l)/(abs(hmn.vx)+abs(rbt.vx0));

            %% ROIを決定
            env.roi.xmin=rbt.vx0*t0-env.l;
            env.roi.xmax=env.roi.xmin+env.L;

            %% y方向回避動作
            avoid_dist=3

            rbt.vy0=-avoid_dist/t0;

            %% phi方向照準動作
            rbt.omg0=atan(avoid_dist/(env.L-env.l))/t0;

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            %                           seq.2  移動                                   %
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            % 現在地から初期地点到達までの軌跡をプロット
            current_time=num_obs*sensor_dt;
            t=linspace(current_time,t0,(t0-current_time)*sensor_fps);
            z=getRobotPath(t,rbt);
            hmn_path=getHumanPath(t,hmn);
            u=[0*t;0*t;0*t;0*t;0*t;0*t;];

            % figure(1); clf;
            % savename_2_path=savename+"_2_path.png";
            % drawPath(t,z,u,env,rbt,hmn,sns,NaN,savename_2_path,graph_title); % solnはないのでNaN
            % saveas(figure(1),savename_2_path);

            % figure(2); clf;
            % title(graph_title);
            % savename_2_anim=savename+"_2_anim";
            % drawAnimation(t,z,u,env,rbt,hmn,sns,NaN,savename_2_anim,graph_title);



            % ここで時刻t0を迎える 以降，この時刻を再度t=0と定義し直す
            %% ロボット・人間の現在位置を初期値として上書きする
            rbt.x0=z(1,end);
            rbt.y0=z(2,end);
            rbt.th0=z(3,end);
            rbt.vx0=z(4,end);
            rbt.vy0=z(5,end);
            rbt.omg0=z(6,end);

            hmn.x0=hmn_path(1,end);
            hmn.y0=hmn_path(2,end);
            hmn.th0=hmn_path(3,end);
            hmn.vx0=hmn_path(4,end);
            hmn.vy0=hmn_path(5,end);
            hmn.omg0=hmn_path(6,end);


            %% ロボットの終端点を設定
            rbt.xF=env.roi.xmax;

            %% 狭い方への進行を阻止する
            % 人の現在地から，余裕の大きい方向を判断する
            % left_clearance=env.kabe.ymax-hmn.y0;
            % right_clearance=hmn.y0-env.kabe.ymin;
            % if left_clearance>right_clearance
            %     env.ymin=hmn.y0;
            % else
            %     env.ymax=hmn.y0;
            % end

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            %                           seq.3  計測                                   %
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            % Overwrite variables
            % rbt.vxmin=0.0; % <== default  


            % Set up function handles
            problem.func.dynamics=@(t,z,u)(dynamics(z,u,env,rbt,hmn,sns));
            % problem.func.pathObj=@(t,z,u)(objF(t,z,u,env,rbt,hmn,sns));
            % problem.func.pathObj=@(t,z,u)(objF_sum_minus(t,z,u,env,rbt,hmn,sns,env.minus_power));
            % problem.func.pathObj=@(t,z,u)(objF_sgmd(t,z,u,env,rbt,hmn,sns));
            problem.func.pathObj=@(t,z,u)(objF_if(t,z,u,env,rbt,hmn,sns));
            % problem.func.pathObj=@(t,z,u)(objF_01(t,z,u,env,rbt,hmn,sns));


            % Set up problem bounds
            problem.bounds.initialTime.low = env.tmin;
            problem.bounds.initialTime.upp = env.tmin;
            problem.bounds.finalTime.low = env.tmax;
            problem.bounds.finalTime.upp = env.tmax;

            problem.bounds.initialState.low = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
            problem.bounds.initialState.upp = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
            problem.bounds.finalState.low = [rbt.xF;rbt.yF;rbt.thFmin;rbt.vx0;rbt.vy0;rbt.omg0];
            problem.bounds.finalState.upp = [rbt.xF;rbt.yF;rbt.thFmax;rbt.vx0;rbt.vy0;rbt.omg0];

            problem.bounds.state.low = [rbt.x0;env.ymin+rbt.sizer;rbt.thFmin;rbt.vxmin;rbt.vymin;rbt.omgmin];
            problem.bounds.state.upp = [rbt.xF;env.ymax-rbt.sizer;rbt.thFmax;rbt.vxmax;rbt.vymax;rbt.omgmax];

            problem.bounds.control.low = [rbt.axmin;rbt.aymin;rbt.aangmin];
            problem.bounds.control.upp = [rbt.axmax;rbt.aymax;rbt.aangmax];


            % Initial guess at trajectory
            problem.guess.time = [env.tmin,env.tmax];
            problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
            problem.guess.control = [0,0;0,0;0,0];


            % Solver options
            problem.options.nlpOpt = optimset(...
            'Display','iter',...
            'MaxFunEvals',1e6);

            % problem.options.method = 'trapezoid'; 
            problem.options.method = 'hermiteSimpson';  


            % Solve!
            soln = trajOpt(problem);


            % Summarize conditions & results
            writeCSV(problem,env,rbt,hmn,sns,soln,savename);
            getFootprint(t,z,u,env,rbt,hmn,sns,soln)


            % Display Solution
            n = length(soln.grid.time);
            t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
            z = soln.interp.state(t);
            u = soln.interp.control(t);

            % Plots
            %% add score to fig name
            graph_title=graph_title+" J="+soln.info.bestfeasible.fval;
            %% History
            figure(3); clf;
            pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
            savename_png = savename+"_3_hist.png";
            saveas(figure(3),savename_png);

            %% Animation
            figure(4); clf;
            title(graph_title);
            savename_3_anim=savename+"_3_anim";
            drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);


            %% Path:
            figure(5); clf;
            drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
            savename_3_path = savename+"_3_path.png";
            saveas(figure(5),savename_3_path);

            %% Potential map
            % figure(6); clf;
            % savename_3_ptnt = savename+"_3_ptnt";
            % drawPotential(t,z,u,env,rbt,hmn,sns,soln,savename_3_ptnt);

            clc;clf;
            % clearvars -except candidate candidate2 savedir;
        catch
            continue
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                           seq.4  離脱                                   %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    end
end
git_auto_push()