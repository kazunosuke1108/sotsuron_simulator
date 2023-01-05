% PREP.m

% check if ROI and xR0 can be determined

clc; clear;
dirname="results\1110_ROI"
mkdir(dirname)

for candidate = 0:0.05:0.15
    % try
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
    %                     Overwrite variables                                 %
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        savename=string(dirname+"\"+datestr(now,'yymmdd_hhMMss'));
        graph_title="ROI definition test rbt.vx0="+candidate+" m/s"


        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                     Defenition of variables                             %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

        env=getEnvironmentParams();
        rbt=getRobotParams();
        hmn=getHumanParams();
        sns=getcSensorParams();

        P_nSegment=40;
        P_nGrid=2*P_nSegment+1;

        dt=(env.tmax-env.tmin)/P_nGrid;

        t=linspace(env.tmin,env.tmax,P_nGrid);

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                     Human truth path                                    %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        hmn_path=getHumanPath(t,hmn);

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                     Robot observes human's velocity                     %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        % 人の座標を複数回取得して，そこから速度を平均値で求める



        vel_list=[];
        rbt_vel=[rbt.vx0;rbt.vy0];

        observed_hmn_old=hmn_path(1:2,1);
        for i = 2:5
            observed_hmn=hmn_path(1:2,i);
            vel_list=[vel_list (observed_hmn-observed_hmn_old)/dt-rbt_vel]
            observed_hmn_old=observed_hmn;
        end

        vel_obs=mean(vel_list,2);
        hmn.vx_obs=vel_obs(1);
        hmn.vy_obs=vel_obs(2);

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        %                     Define ROI                                          %
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        lm=env.roi.xmax-env.roi.xmin;
        rbt.vx0=candidate;
        rbt.vy0=0;
        % 速度算出完了から計測開始までの時間t0
        t0=(hmn_path(1,6)-lm)/(abs(hmn.vx_obs)+abs(rbt.vx0))

        env.roi.xmin=rbt.vx0*t0;
        env.roi.xmax=env.roi.xmin+lm

        z=[rbt.x0+rbt.vx0*t;rbt.y0+rbt.vy0*t;0*t;0*t;0*t;0*t];
        u=[0*t;0*t;0*t;0*t;0*t;0*t;]

        figure(1); clf;
        savename_png=savename+".png";
        drawPath(t,z,u,env,rbt,hmn,sns,NaN,savename,graph_title)
        saveas(figure(1),savename_png);
        pause(1)

        clc;clf;
        clearvars -except candidate dirname;
    % catch
    %     continue
    % end
end