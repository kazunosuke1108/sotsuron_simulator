function z=MAIN_func()
    % MAIN.m

    %% initialization
    clc; clear;
    addpath '/home/ytpc2022h/kazu_ws/sotsuron_simulator/matlab_ws/tutorial/cartPole'
    addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole';
    % addpath 'C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole';
    % addpath 'C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole'

    date="1126";
    abst="DEV_anim";
    detail="";
    mkdir('results');
    % savedir="results\"+date+"_"+abst;
    savedir="results/"+date+"_"+abst;
    mkdir(savedir);
    % savedir=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
    savedir=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
    mkdir(savedir);

    % for ...

    graph_title="rbtdirection";
    % savename=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);
    savename=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           seq.0  環境                                   %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    %% load default variables
    env=getEnvironmentParams();
    sns=getSensorParams();
    rbt=getRobotParams();
    hmn=getHumanParams(sns);

    %% overwrite variables

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           seq.1  検知                                   %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

    % 検知
    %% 検知・速度推定用の時系列の定義
    sensor_fps=30;
    sensor_dt=1/sensor_fps;
    seq1_tmax=100;
    t=linspace(0,seq1_tmax,(seq1_tmax-0)*sensor_fps);
    %% 等速直線運動の歩行経路を算出
    hmn_path=getHumanPath(t,hmn);
    %% 等速直線運動で巡回中のロボット経路を算出
    rbt_path=getRobotPath(t,rbt);

    %% 検知待ちループ
    for i=1:length(t)
        if abs(hmn_path(1,i)-rbt_path(1,i))<=sns.r0
            disp(abs(hmn_path(1,i)-rbt_path(1,i)))
            %% 検出地点を初期地点に設定
            rbt.x0=rbt_path(1,i);
            rbt.y0=rbt_path(2,i);
            rbt.th0=rbt_path(3,i);
            rbt.vx0=rbt_path(4,i);
            rbt.vy0=rbt_path(5,i);
            rbt.omg0=rbt_path(6,i);

            hmn.x0=hmn_path(1,i);
            hmn.y0=hmn_path(2,i);
            hmn.th0=hmn_path(3,i);
            hmn.vx0=hmn_path(4,i);
            hmn.vy0=hmn_path(5,i);
            hmn.omg0=hmn_path(6,i);
            break
        end
    end

    % 歩行速度推定
    num_obs=5; % 移動平均に使用するフレーム数
    vel_list=[];
    relative_path=hmn_path(1:2,:)-rbt_path(1:2,:);
    observed_old=relative_path(:,i);

    for j = i+1:i+num_obs
        observed=relative_path(:,i);
        vel=(observed-observed_old)/sensor_dt;
        vel_list=[vel_list vel];
        observed_old=observed;
    end
    relative_vel=mean(vel_list,2);
    hmn_vel=relative_vel+[rbt.vx0;rbt.vy0];
    hmn.vx=-hmn_vel(1);
    hmn.vy=hmn_vel(2);

    % 計測領域の再定義
    rbt.x0=rbt_path(1,j+1);
    rbt.y0=rbt_path(2,j+1);
    rbt.th0=rbt_path(3,j+1);
    rbt.vx0=rbt_path(4,j+1);
    rbt.vy0=rbt_path(5,j+1);
    rbt.omg0=rbt_path(6,j+1);

    hmn.x0=hmn_path(1,j+1);
    hmn.y0=hmn_path(2,j+1);
    hmn.th0=hmn_path(3,j+1);
    hmn.vx0=hmn.vx;
    hmn.vy0=hmn.vy;
    hmn.omg0=hmn_path(6,j+1);

    env.roi.xmin=rbt.x0;
    env.roi.xmax=env.roi.xmin+env.L;

    rbt.xF=env.roi.xmax;

    % 計測所要時間の推定
    %% ロボットの走行所要時間
    t_rbt=abs(env.L/rbt.vxmax);
    t_measure=abs(env.l/hmn.vx); % env.l=ロボットが立ち止まって人を計測したい歩行距離
    t_slack=0.05;
    env.final_tmax=(t_rbt+t_measure)*(1-t_slack);
    env.final_tmax=(t_rbt+t_measure)*(1+t_slack);

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           seq.2  計測                                   %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    % Set up function handles
    problem.func.dynamics=@(t,z,u)(dynamics(z,u,env,rbt,hmn,sns));
    problem.func.pathObj=@(t,z,u)(objF_line(t,z,u,env,rbt,hmn,sns));

    % Set up problem bounds
    problem.bounds.initialTime.low = env.init_tmin;
    problem.bounds.initialTime.upp = env.init_tmax;
    problem.bounds.finalTime.low = env.final_tmin;
    problem.bounds.finalTime.upp = env.final_tmax;

    problem.bounds.initialState.low = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
    problem.bounds.initialState.upp = [rbt.x0;rbt.y0;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
    problem.bounds.finalState.low = [rbt.xF;rbt.yF;rbt.thFmin;rbt.vx0;rbt.vy0;rbt.omg0];
    problem.bounds.finalState.upp = [rbt.xF;rbt.yF;rbt.thFmax;rbt.vx0;rbt.vy0;rbt.omg0];

    problem.bounds.state.low = [rbt.x0;env.ymin+rbt.sizer;rbt.thFmin;rbt.vxmin;rbt.vymin;rbt.omgmin];
    problem.bounds.state.upp = [rbt.xF;env.ymax-rbt.sizer;rbt.thFmax;rbt.vxmax;rbt.vymax;rbt.omgmax];

    problem.bounds.control.low = [rbt.axmin;rbt.aymin;rbt.aangmin];
    problem.bounds.control.upp = [rbt.axmax;rbt.aymax;rbt.aangmax];


    % Initial guess at trajectory
    problem.guess.time = [(problem.bounds.initialTime.low+problem.bounds.initialTime.upp)/2,(problem.bounds.finalTime.low+problem.bounds.finalTime.upp)/2];
    problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
    problem.guess.control = [0,0;0,0;0,0];


    % Solver options
    problem.options.nlpOpt = optimset(...
    'Display','iter',...
    'MaxIter',1e3,... % 可能な反復の最大数 (正の整数)
    'TolFun',1e-12,... % 1 次の最適性に関する終了許容誤差 (正のスカラー)
    'TolX',1e-10,... % x に関する許容誤差 (正のスカラー)
    'TolCon',1e-8,... % 制約違反に関する許容誤差 (正のスカラー)
    'MaxFunEvals',1e6);


    % problem.options.method = 'trapezoid'; 
    problem.options.method = 'hermiteSimpson';  


    % Solve!
    soln = trajOpt(problem);


    % Summarize conditions & results
    save(savename+".mat");
    % writeCSV(problem,env,rbt,hmn,sns,soln,savename);

    % Display Solution
    n = length(soln.grid.time);
    t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
    z = soln.interp.state(t);
    u = soln.interp.control(t);

    % Plots
    %% add score to fig name
    graph_title=graph_title+" J="+soln.info.bestfeasible.fval;
    %% History
    figure(1); clf;
    pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
    savename_png = savename+"_3_hist.png";
    saveas(figure(1),savename_png);

    %% Animation
    % figure(2); clf;
    % savename_3_anim=savename+"_3_anim";
    % drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);

    figure(3); clf;
    drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
    savename_3_path = savename+"_3_path.png";
    saveas(figure(3),savename_3_path);