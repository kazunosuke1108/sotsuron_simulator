function [env sns rbt hmn]=sim_detection(rbt,hmn,sns,env)
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
    disp(observed_old)
    for j = i+1:i+num_obs
        observed=relative_path(:,i);
        disp(observed)
        vel=(observed-observed_old)/sensor_dt;
        vel_list=[vel_list vel];
        observed_old=observed;
    end
    disp(vel_list)
    relative_vel=mean(vel_list,2);
    disp(relative_vel)
    hmn_vel=relative_vel+[rbt.vx0;rbt.vy0];
    hmn.vx=-hmn_vel(1);
    hmn.vy=hmn_vel(2);
    disp(hmn.vx)


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
end