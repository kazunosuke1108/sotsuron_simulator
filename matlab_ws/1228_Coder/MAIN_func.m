function result = MAIN_func()
    % MAIN.m
    %% initialization
    %% experiment or simulation
    exp_mode=0
    
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
    
    env.dist_hsr_zed=13.5;

    hmn.x0=env.xmax;

    hmn.vx=-0.8;

    t_slack=0.05;

    % env.hz=6;
    env.hz=abs(hmn.vx)*40/3;
    % env.hz=abs(hmn.vx)*60/3;
    % rbt.vxmin=-rbt.vxmax;
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           seq.1  検知                                   %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    % 実機
    %% jsonから人の位置・速度を取得

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
    problem=struct;
    problem.options=struct;
    problem.options.hermiteSimpson = struct;
    problem.options.hermiteSimpson.nSegment=0;
    
    problem.func=struct;
    problem.func.dynamics=struct;
    problem.func.pathObj=struct;
    problem.func.pathCst=struct;
    
    problem.bounds=struct;
    problem.bounds.initialTime=struct;
    problem.bounds.initialTime.low=0;
    problem.bounds.initialTime.upp=0;
    problem.bounds.finalTime=struct;
    problem.bounds.finalTime.low =0;
    problem.bounds.finalTime.upp =0;
    problem.bounds.initialState.low =zeros(6,1);
    problem.bounds.initialState.upp =zeros(6,1);
    problem.bounds.finalState.low =zeros(6,1);
    problem.bounds.finalState.upp =zeros(6,1);
    problem.bounds.state.low=zeros(6,1);
    problem.bounds.state.upp =zeros(6,1);
    problem.bounds.control.low=zeros(3,1);
    problem.bounds.control.upp =zeros(3,1);
    problem.guess.time=[0,0];
    problem.guess.state=[0,0;0,0;0,0;0,0;0,0;0,0];
    problem.guess.control = [0,0;0,0;0,0];
    problem.options.method ='hermiteSimpson';
    problem.options.nlpOpt = struct("Display",'iter',"MaxIter",0,"MaxFunEvals",0,"TolX",0,"TolFun",0,"FunValCheck",'on',"OutputFcn",'',"PlotFcns",'');
    problem.options.hermiteSimpson.nSegment=fix((env.estim_final_t*env.hz-1)/30);


    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                           seq.2  計測                                   %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    % Set up function handles
    coder.extrinsic('dynamics');
    coder.extrinsic('objF_pdf');
    coder.extrinsic('constraint');    
    z=0;
    u=0;
    t=0;
    problem.func.dynamics=dynamics(z,u,env,rbt,hmn,sns);
    % problem.func.pathObj=@(t,z,u)(objF_line(t,z,u,env,rbt,hmn,sns));
    % problem.func.pathObj=@(t,z,u)(objF_line_pdf(t,z,u,env,rbt,hmn,sns));
    problem.func.pathObj=objF_pdf(t,z,u,env,rbt,hmn,sns);
    % problem.func.pathObj=@(t,z,u)(objF_LRF(t,z,u,env,rbt,hmn,sns));
    problem.func.pathCst=constraint(t,z,u,env,rbt,hmn,sns);
    
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
    problem.guess.time=[0,0];
    problem.guess.state=[0,0;0,0;0,0;0,0;0,0;0,0];
    problem.guess.control = [0,0;0,0;0,0];
    problem.guess.time = [(problem.bounds.initialTime.low+problem.bounds.initialTime.upp)/2,(problem.bounds.finalTime.low+problem.bounds.finalTime.upp)/2];
    problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
    problem.guess.control = [0,0;0,0;0,0];
    
    
    % Solver options
    problem.options.nlpOpt = optimset(...
    'Display','iter',...
    'MaxIter',1e3,... % 可能な反復の最大数 (正の整数)
    'TolFun',1e-12,... % 1 次の最適性に関する終了許容誤差 (正のスカラー)
    'TolX',1e-10,... % x に関する許容誤差 (正のスカラー)
    'FunValCheck','on',...
    'OutputFcn','',...
    'PlotFcns','',...
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
    %% History
    if exp_mode
        disp("exp_mode:1")
    else
        figure(1); clf;
        pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
        savename_png = savename+"_3_hist.png";
        
        %% Animation
        figure(2); clf;
        savename_3_anim=savename+"_3_anim";
        % drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
        drawAnimation_z8(t,z,z8,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
        
        figure(3); clf;
        drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
        savename_3_path = savename+"_3_path.png";
        disp("exp_mode:0")
    end
    result.z=z;
    result.z8=z8;
    result.t=t;
    
    % Summarize conditions & results
    save(savename+".mat");

    % writeCSV(problem,env,rbt,hmn,sns,soln,savename);

    function dz=dynamics(z,u,env,rbt,hmn,sns)

        dx=z(4,:);
        dy=z(5,:);
        dth=z(6,:);
        dvx=u(1,:);
        dvy=u(2,:);
        domg=u(3,:);
        
        dz=[dx;dy;dth;dvx;dvy;domg];
        
        end
    function J=objF_pdf(t,z,u,env,rbt,hmn,sns)

        % env.objF_if_edge_a_r は小さいほど傾斜がきつくなる
    
        %% 情報取得
        hmn_path=getHumanPath(t,hmn);
        rbt_path=z;
    
        footprint=getFootprint(t,z,u,env,rbt,hmn,sns); % 各時刻で足跡を取得出来たら1,ダメだったら0が返される
        if nnz(footprint)>0
            success_list=find(footprint>0,nnz(footprint));
            first_success_idx=success_list(1);
            last_success_idx=success_list(end);
            continuous_check=all(footprint(first_success_idx:last_success_idx)>0);
            measured_length=abs(hmn_path(1,first_success_idx)-hmn_path(1,last_success_idx));
        else
            measured_length=0;
        end    
        vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
        e=[cos(z(3,:));sin(z(3,:))];
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    
        naiseki=dot(e,vec_HR,1);
    
        e_vec_th=naiseki./norm_HR;
        deg_HR=atan(vec_HR(2,:)./vec_HR(1,:));
        deg_compensate=vec_HR(1,:)<0;
        deg_HR=deg_HR+pi*deg_compensate;
        deg_diff=deg_HR-z(3,:);
    
        % %% r positive
        % % 上り
        % r_11=norm_HR>=sns.r1;
        % % r_12=norm_HR<sns.r1+2*hmn.sizer;
        % r_12=norm_HR<(sns.r1+sns.r2)/2;
        % r_1=r_11.*r_12;
        % % score_r1=1/(2*hmn.sizer)*(norm_HR-sns.r1).*r_1;
        % score_r1=1/((sns.r1+sns.r2)/2-sns.r1)*(norm_HR-sns.r1).*r_1;
    
        % % 頂上
        % r_21=norm_HR>=sns.r1+2*hmn.sizer;
        % r_22=norm_HR<sns.r2-2*hmn.sizer;
        % r_2=r_21.*r_22;
        % % score_r2=1.*r_2;
        % score_r2=0;
    
        % % 下り
        % % r_31=norm_HR>=sns.r2-2*hmn.sizer;
        % r_31=norm_HR>=(sns.r1+sns.r2)/2;
        % r_32=norm_HR<sns.r2;
        % r_3=r_31.*r_32;
        % % score_r3=-1/(2*hmn.sizer)*(norm_HR-sns.r2).*r_3;
        % score_r3=-1/(sns.r2-(sns.r1+sns.r2)/2)*(norm_HR-sns.r2).*r_3;
    
        % % まとめ
        % score_r=score_r1+score_r2+score_r3;
    
        mu_r=(sns.r1+sns.r2)/2;
        sgm_r=1/6*2*(sns.r2-sns.r1);
        score_r=pdf('Normal',norm_HR,mu_r,sgm_r);
    
        % %% phi positive
        % % 上り
        % p_11=deg_diff>=-sns.phi;
        % % p_12=deg_diff<-sns.phi+hmn.sizep;
        % p_12=deg_diff<0;
        % p_1=p_11.*p_12;
    
        % % score_p1=1/hmn.sizep*(deg_diff+sns.phi).*p_1;
        % score_p1=1/sns.phi*(deg_diff+sns.phi).*p_1;
    
        % % 頂上
        % p_21=deg_diff>=-sns.phi+hmn.sizep;
        % p_22=deg_diff<sns.phi-hmn.sizep;
        % p_2=p_21.*p_22;
    
        % % score_p2=1.*p_2;
        % score_p2=0;
    
        % % 下り
        % % p_31=deg_diff>=sns.phi-hmn.sizep;
        % p_31=deg_diff>=0;
        % p_32=deg_diff<sns.phi;
        % p_3=p_31.*p_32;
    
        % % score_p3=-1/hmn.sizep*(deg_diff-sns.phi).*p_3;
        % score_p3=-1/sns.phi*(deg_diff-sns.phi).*p_3;
    
        % % まとめ
        % score_p=score_p1+score_p2+score_p3;
    
        %% phi normal_distribution
        mu_phi=0;
        sgm_phi=1/6*2*sns.phi;
        score_p=pdf('Normal',deg_diff,mu_phi,sgm_phi);
    
        % %% penalty
        % % 底辺
        % pe_11=norm_HR>=0;
        % pe_12=norm_HR<sns.r1;
        % pe_1=pe_11.*pe_12;
    
        % score_pe1=-1.*pe_1;
    
        % % 上り
        % pe_21=norm_HR>=sns.r1;
        % pe_22=norm_HR<sns.r1+2*hmn.sizer;
        % pe_2=pe_21.*pe_22;
    
        % score_pe2=1/(2*hmn.sizer)*(norm_HR-(sns.r1+2*hmn.sizer)).*pe_2;
    
        % % まとめ
        % score_pe=score_pe1+score_pe2+score_r;
    
        %% 5m以上計測成功に対する報酬measured_score
        additional_start=env.l;
        additional_end=env.l+4*hmn.sizer;
        if measured_length>additional_end
            % 屋根
            ms=1;
        elseif measured_length>additional_start
            %　上り
            ms=1/(additional_end-additional_start)*(measured_length-additional_start);
        else
            % 底辺
            ms=0;
        end
        
        score_m=ms*ones(1,length(norm_HR));
        
        % %% 計測領域外のスコアをゼロとする．（ペナルティを0にすることはしない）
        % area_11=hmn_path(1,:)>=env.roi.xmin;
        % area_12=hmn_path(1,:)<=env.roi.xmax;
        % score_area=area_11.*area_12;
        
        %% J
        % J_kari=score_area.*score_r.*score_p+score_pe;
        % J_kari=score_r.*score_p+score_pe;
        % J_kari=score_r.*score_p;
        % J_kari=score_r.*score_p+score_pe+score_m.*(score_pe+1);
        J_kari=score_r.*score_p+score_m;
        
        J=-J_kari;
    
    
    end
    function [c, ceq, cGrad, ceqGrad]=constraint(t,z,u,env,rbt,hmn,sns)
        hmn_path=getHumanPath(t,hmn);
        rbt_path=z;
    
        vec_HR=[hmn_path(1,:);hmn_path(2,:)]-[rbt_path(1,:);rbt_path(2,:)];
        e=[cos(z(3,:));sin(z(3,:))];
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
        vec_HR=(norm_HR-hmn.sizer)./norm_HR.*vec_HR;
        norm_HR=sqrt(vec_HR(1,:).^2+vec_HR(2,:).^2);
    
        % 衝突回避制約1m
        c1=-(norm_HR-sns.r1).';
        % c1=-(norm_HR-1).';
        % 速度制約
        norm_vel=sqrt(rbt_path(4,:).^2+rbt_path(5,:).^2).'-rbt.vmax;
    
    
        c=[c1;
        norm_vel];
        ceq=[];
    
        cGrad=0;
        ceqGrad=[];
    end
    end