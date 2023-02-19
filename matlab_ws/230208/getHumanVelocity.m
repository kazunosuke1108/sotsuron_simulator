function [position_x,position_y,velocity]=getHumanVelocity(env)
    
    while 1
        %% load data
        try
            % data=readmatrix("path");
            % data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\track_results_1216_090.csv");
            data=readmatrix("/home/hayashide/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/zed.csv");
            
        catch
            disp("getHumanVelocity: csv not found")
            pause(0.1)
            continue
        end

        try
            t=data(:,1)-data(1,1);
            z=data(:,4);
        catch
            continue
        end

        %% estimation start criterias
        %% 位置が10m以内であるか
        isbelow10m=z(end)<=10;
        %% データ数が50個以上あるか
        num_data=50;
        hasenoughdata=length(z)>num_data;

        if isbelow10m && hasenoughdata
            y=data([end-num_data:end],2);
            z=data([end-num_data:end],4);
            %% LPF
            % cutoff=0.001;
            fps=15;
            % z_lpf=LPF(z,cutoff,fps);

            % %% LPFの副作用を削除
            % cutframe=5;
            % z_lpf=z_lpf(cutframe:end-cutframe);
            % t_lpf=t(cutframe:end-cutframe);

            %% Kalman Filter
            Q=0.004;
            R=0.1;
            N=0;
            pv0=-0.9;

            po=z; % position_observed
            estm_list=kalman_filter_ohmori(po,pv0,Q,R,N,fps);

            localmin=islocalmin(estm_list(2,:));
            localmin_idx=find(localmin>0.5);
            try
                estm_vel=median(estm_list(2,[localmin_idx(1):localmin_idx(end)]));
            catch
                continue
            end
            if z(end)<=1.8
                position_x=z(end);
                position_y=abs(median(y))+env.dist_zed_wall;
                velocity=estm_vel;
                break
            else
                % if mod(hasenoughdata,10)==0
                    disp("latest position: "+string(z(end)))
                % end
            end
        end
    end

    function z_lpf=LPF(z,cutoff,fps)
        %%% 平均を0に持っていく
        ave=mean(z);
        z=z-ave;
        %%% LPF
        [z_lpf,d]=lowpass(z,cutoff,fps);
        %%% 平均を元に戻す
        z_lpf=z_lpf+ave;
    end

    function estm_list=kalman_filter_ohmori(po,pv0,Q,R,N,fps)
        %% system data
        A=[1 1/fps;0 1];
        B=[0;1];
        C=[1 0];
        D=0;
    
        Plant = ss(A,B,C,D,-1);
        Plant.InputName = 'un';
        Plant.OutputName = 'yt';
        Sum = sumblk('un = u + w');
        sys = connect(Plant,Sum,{'u','w'},'yt');
    
        %% Filtering
        sensors=[1];
        [kalmf,L,P] = kalman(sys,Q,R,N,sensors);
        estm_list=zeros(2,length(po));
    
        pHat_k=[po(1);pv0];
        i=1;
        for po_scaler = po.'
            pHat_kp1=(A-L*C)*pHat_k+po_scaler*L;
            estm_list(:,i)=pHat_kp1;
            pHat_k=pHat_kp1;
            i=i+1;
        end
    end
    
end