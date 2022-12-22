function [position,velocity]=getHumanVelocity()
    
    while 1
        %% load data
        try
            % data=readmatrix("path");
            data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\track_results_1216_090.csv");
        catch
            disp("getHumanVelocity: csv not found")
            pause(0.1)
            continue
        end
        t=data(:,1)-data(1,1);
        z=data(:,4);

        %% estimation start criterias
        %% 位置が10m以内であるか
        isbelow10m=z(end)<=10;
        %% データ数が100個以上あるか
        has100data=length(z)>=100;

        if isbelow10m && has100data
            %% LPF
            cutoff=0.001;
            fps=15;
            z_lpf=LPF(z,cutoff,fps);

            %% LPFの副作用を削除
            cutframe=5;
            z_lpf=z_lpf(cutframe:end-cutframe);
            t_lpf=t(cutframe:end-cutframe);

            %% Kalman Filter
            Q=0.004;
            R=1e-20;
            N=0;
            pv0=0;

            po=z_lpf; % position_observed
            estm_list=kalman_filter_ohmori(po,pv0,Q,R,N,fps);

            localmin=islocalmin(estm_list(2,:));
            localmin_idx=find(localmin>0.5);
            estm_vel=median(estm_list(2,[localmin_idx(1):localmin_idx(end)]))

            if z(end)<=1.5
                position=z(end);
                velocity=estm_vel;
                break
            else
                disp("latest position after LPF: "+string(z_lpf(end)))
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