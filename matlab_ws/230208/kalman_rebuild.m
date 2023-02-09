clc;clear;clf;

data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\track_results_1216_120.csv");

data=data([120:end],:);
t=data(:,1)-data(1,1);
z=data(:,4);

% for R=[1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e+0 1e+1 1e+2 1e+3 1e+4 1e+5 1e+6 1e+7 1e+8 1e+9 1e+10]
for R= [1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e+0 1e+1 1e+2 1e+3 1e+4 1e+5 1e+6 1e+7 1e+8 1e+9 1e+10]
    %% load data
    subplot(2,1,1)
    plot(t,z,'k','LineWidth',1)
    hold on
    
    %% LPF
    cutoff=10;
    fps=15;
    z_lpf=LPF(z,cutoff,fps);
    plot(t,z_lpf,'r','LineWidth',3)
    hold on
    po=z_lpf;

    %% Kalman Filter
    pv0=-0.6;
    Q=0.29827;
    % R=1e+9;
    N=0;
    estm_list=kalman_filter(po,pv0,Q,R,N);
    plot(t,estm_list(1,:))
    hold on
    xlabel("time [s]")
    ylabel("position [m]")

    %% Velocity
    % remove trend
    % estm_list(2,:)=detrend(estm_list(2,:)); % 真値は等速の仮定より，経時的な値の変動を補正する
    subplot(2,1,2)
    plot(t,estm_list(2,:))
    hold on
    xlabel("time [s]")
    ylabel("velocity [m/s]")

end
% saveas("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\1220.png")
% %% LPF
% cutoff=0.1;
% %%% 平均を0に持っていく
% ave=mean(z);
% z=z-ave;
% %%% LPFを実装
% [z_lpf,d]=lowpass(z,cutoff,fps);
% %%% 平均を元に戻す
% z_lpf=z_lpf+ave;
% plot(t,z_lpf)
% hold on

% %% Kalman Filter
% po=z_lpf;


function z_lpf=LPF(z,cutoff,fps)
    %%% 平均を0に持っていく
    ave=mean(z);
    z=z-ave;
    %%% LPF
    [z_lpf,d]=lowpass(z,cutoff,fps);
    %%% 平均を元に戻す
    z_lpf=z_lpf+ave;
end


function estm_list=kalman_filter(po,pv0,Q,R,N)
    %% variables
    po=po;
    
    %% system data
    fps=15;
    A=[1 1/fps;0 1];
    B=[1;1];
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

    pHat_k_km1=[po(1);pv0];
    i=1;
    for po_scaler=po.'
        pHat_k_k=pHat_k_km1+L*(po_scaler-C*pHat_k_km1);
        pHat_kp1_k=A*pHat_k_k;
        estm_list(:,i)=pHat_kp1_k;
        pHat_k_km1=pHat_k_k;
        pHat_k_k=pHat_kp1_k;
        i=i+1;
    end
end
