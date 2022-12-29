function result=MAIN_func_iter1228()
    % MAIN.m
    %% initialization
    clc; clear;
    addpath 'C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole';
    addpath '/home/ytpc2022h/kazu_ws/sotsuron_simulator/matlab_ws/tutorial/cartPole';
    addpath '/home/ytpc2022h/catkin_ws/src/sotsuron_simulator/matlab_ws/tutorial/cartPole';
    addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole';
    addpath '/home/hayashide/kazu_ws/sotsuron_simulator/matlab_ws/tutorial/cartPole';
    addpath '/home/hayashide/catkin_ws/src/sotsuron_simulator/matlab_ws/tutorial/cartPole';
    addpath '/home/hayashide/kazu_ws/sotsuron_experiment/sotsuron_experiment/scripts/monitor';
    addpath '/home/hayashide/catkin_ws/src/sotsuron_experiment/sotsuron_experiment/scripts/monitor';
    addpath 'C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole'
    % addpath 'C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole';
    for candidate2=[0.75 0.5 0.25 0.1 0.075 0.05 0.025]
        for candidate=[-0.6 -0.7 -0.8 -0.9 -1.0 -1.1 -1.2]
            try
                %% experiment or simulation
                exp_mode=0
                
                date="1229";
                abst="2403_TolCon";
                detail="vx_"+string(abs(candidate))+"TolCon_"+string(candidate2);
                mkdir('results');
                % savedir="results\"+date+"_"+abst;
                savedir="results/"+date+"_"+abst;
                mkdir(savedir);
                % savedir=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
                savedir=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
                mkdir(savedir);

                % for ...

                graph_title="";
                % savename=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);
                savename=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);

                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                %                           seq.0  環境                                   %
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

                %% load default variables

                sns_name="" % d455,d435,zed,xtion

                env=getEnvironmentParams();
                sns=getSensorParams();
                rbt=getRobotParams(env);
                hmn=getHumanParams(env,sns);
                %% overwrite variables

                % 反転
                % rbt.y0=-3.5;
                % rbt.yF=rbt.y0;
                % hmn.y0=rbt.y0;

                % LRF ##### objF 切り替え #####
                % sns.phi=270;
                % sns.pitch=57;
                % sns.r0=8.0;
                % sns.r2=8.0;
                % sns.phi=deg2rad(sns.phi)/2;
                % sns.pitch=deg2rad(sns.pitch)/2;
                % sns.r1=1;

                % ZED 
                % sns.phi=110;
                % sns.pitch=70;
                % sns.r0=8.0;
                % sns.r2=8.0;
                % sns.phi=deg2rad(sns.phi)/2;
                % sns.pitch=deg2rad(sns.pitch)/2;
                % sns.r1=sns.h/tan(sns.pitch);
                
                env.dist_hsr_zed=13.5;

                env.xmax=10;


                hmn.vx=candidate;

                t_slack=0.35;

                % env.hz=6;
                env.hz=abs(hmn.vx)*40/3;
                % env.hz=abs(hmn.vx)*80/3;
                % rbt.vxmin=-rbt.vxmax;
                
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                %                           seq.1  検知                                   %
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                % 実機
                %% jsonから人の位置・速度を取得
                if exp_mode
                    [env.dist_zed_hmn,hmn.vx]=getHumanVelocity();
                    tic;
                    env.publish_time=(env.dist_hsr_zed+env.dist_zed_hmn-env.L)/abs(hmn.vx);
                    env.hz=5;
                    % env.hz=abs(hmn.vx)*40/3;
                end
                %% hmn_path
                % json=jsondecode(fileread('/home/hayashide/catkin_ws/src/sotsuron_experiment/scripts/monitor/velocity.json'));
                % % json=jsondecode(fileread('/home/hayashide/kazu_ws/sotsuron_experiment/sotsuron_experiment/scripts/monitor/velocity.json'))
                % hmn.x0=json.z_linear_z;
                % hmn.vx=json.z_linear_a;
                % env.roi.xmin=rbt.x0;
                % env.roi.xmax=env.roi.xmin+env.L;
                % rbt.xF=env.roi.xmax;
                
                % シミュレーション
                % [env sns rbt hmn]=sim_detection(rbt,hmn,sns,env);
                
                % 計測所要時間の推定
                %% ロボットの走行所要時間
                t_rbt=abs(env.L/rbt.vxmax);
                t_measure=abs(env.l/hmn.vx); % env.l=ロボットが立ち止まって人を計測したい歩行距離
                % t_slack=0.05;
                env.estim_final_t=t_rbt+t_measure;
                env.final_tmin=env.estim_final_t*(1-t_slack);
                env.final_tmax=env.estim_final_t*(1+t_slack);
                
                % 標準制御周波数の決定
                problem.options.hermiteSimpson.nSegment=fix((env.estim_final_t*env.hz-1)/30);


                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                %                           seq.2  計測                                   %
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                % Set up function handles
                problem.func.dynamics=@(t,z,u)(dynamics(z,u,env,rbt,hmn,sns));
                % problem.func.pathObj=@(t,z,u)(objF_line(t,z,u,env,rbt,hmn,sns));
                % problem.func.pathObj=@(t,z,u)(objF_line_pdf(t,z,u,env,rbt,hmn,sns));
                problem.func.pathObj=@(t,z,u)(objF_pdf(t,z,u,env,rbt,hmn,sns));
                % problem.func.pathObj=@(t,z,u)(objF_LRF(t,z,u,env,rbt,hmn,sns));
                problem.func.pathCst=@(t,z,u)(constraint(t,z,u,env,rbt,hmn,sns));
                
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
                'TolCon',candidate2,... % 制約違反に関する許容誤差 (正のスカラー)
                'MaxFunEvals',1e6);
                
                % problem.options.method = 'trapezoid'; 
                problem.options.method = 'hermiteSimpson';  
                % problem.options.hermiteSimpson.nSegment=10;
                
                
                % Solve!
                soln = trajOpt(problem);
                
                
                % Display Solution
                n = length(soln.grid.time);
                t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
                z = soln.interp.state(t);
                u = soln.interp.control(t);

                z8= getz8(z);
                
                % Plots
                %% add score to fig name
                graph_title=graph_title+" J="+soln.info.bestfeasible.fval;
                %% History
                if exp_mode
                    disp("exp_mode:1")
                else
                    figure(1); clf;
                    pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
                    savename_png = savename+"_3_hist.png";
                    saveas(figure(1),savename_png);
                    
                    %% Animation
                    figure(2); clf;
                    savename_3_anim=savename+"_3_anim";
                    % drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
                    drawAnimation_z8(t,z,z8,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
                    
                    figure(3); clf;
                    drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
                    savename_3_path = savename+"_3_path.png";
                    saveas(figure(3),savename_3_path);
                    disp("exp_mode:0")
                end
                result.z=z;
                result.z8=z8;
                result.t=t;
                
                % Summarize conditions & results
                save(savename+".mat");
                if exp_mode
                    start_waiting=toc;
                    while 1
                        if toc>=env.publish_time
                            disp("Publish. current time:"+string(toc)+" publish time:"+string(env.publish_time)+" calc time:"+string(soln.info.nlpTime)+" start waiting since:"+string(start_waiting))
                            break
                        else
                            if mod(toc,0.01)==0
                                disp("Waiting for publish. current time:"+string(toc)+" publish time:"+string(env.publish_time))
                            end
                        end
                    end
                end
            catch
                save(savename+".mat");
                continue
            end
        end
        % writeCSV(problem,env,rbt,hmn,sns,soln,savename);
    end