clc;clear;
fig=figure(1);clf;

motherdir="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0207\csv\090";
dirlist=dir(motherdir);
for n=3:length(dirlist);
    fullpath = fullfile(dirlist(n).folder, dirlist(n).name);
    % csvpath = dir(fullpath+"\*.csv");
    data=readmatrix(fullpath);
    % data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0207\csv\20230207_y050_v000_8_pause_075_Hayashide.csv");
    % for i = 1:length(data(:,1))
    %     if data(i,4)<7
    %         break
    %     end
    % end
    % data=data([i:end],:);

    estm_history=[];

    data=data(160:end,:)
    t=data(:,1);
    z=data(:,4);
    subplot(2,1,1)
    plot(t,z,"LineWidth",2)
    hold on

    po=z;
    pv0=-0.9;
    Q=0.005;
    for R=[0.1]
        % R=1;
        N=0;
        estm_list=kalman_filter_ohmori(po,pv0,Q,R,N);

        disp(estm_list)
        size(t)
        size(estm_list(:,1))

        if R ~= 1e-3
            hold on
        end
        plot(t,estm_list(1,:))
        hold on
        subplot(2,1,2)
        plot(t,estm_list(2,:))
        hold on
        
        % ylim([-6 6])
        % legend(["raw z" "kalman z" "kalman vz"])
    end
end
% % disp(length(data(:,1)))
% for i = 50:length(data(:,1))
%     partial_data=data([1:i],:);

%     t=partial_data(:,1)-partial_data(1,1);
%     z=partial_data(:,4);

%     %% LPF
%     cutoff=0.001;
%     fps=15;
%     z_lpf=LPF(z,cutoff,fps);
%     cutframe=1;
%     z_lpf=z_lpf(cutframe:end-cutframe);
%     t_lpf=t(cutframe:end-cutframe);

%     % for Q=[0.001 0.002 0.003 0.004]
%     for Q=[0.001 0.002 0.003 0.004]
%         for R= 1e-20
%                 %% load data
%                 subplot(3,1,1)
%                 plot(t,z,'k','LineWidth',1)
%                 hold on
                
%                 plot(t_lpf,z_lpf,'r','LineWidth',3)
%                 hold on
%                 po=z_lpf;

%                 %% Kalman Filter
%                 pv0=0;
%                 % Q=0.0041133;
%                 % R=1e+9;
%                 N=0;
%                 % estm_list=kalman_filter(po,pv0,Q,R,N);
%                 estm_list=kalman_filter_ohmori(po,pv0,Q,R,N);
%                 % estm_list=kalman_filter_zihen(po,pv0,Q,R,N,t);
%                 plot(t_lpf,estm_list(1,:))
%                 hold on
%                 xlabel("time [s]")
%                 ylabel("position [m]")

%                 %% Velocity
%                 % remove trend
%                 % estm_list(2,:)=detrend(estm_list(2,:)); % 真値は等速の仮定より，経時的な値の変動を補正する
%                 subplot(3,1,2)
%                 plot(t_lpf,estm_list(2,:))
%                 hold on
%                 xlabel("time [s]")
%                 ylabel("velocity [m/s]")

%         end
%     end
%     % plot(t,-1.2*ones(1,length(t)))
%     plot(t,-0.9*ones(1,length(t)))
%     localmin=islocalmin(estm_list(2,:));
%     localmin_idx=find(localmin>0.5);
%     estm_vel=median(estm_list(2,[localmin_idx(1):localmin_idx(end)]))
%     estm_history=[estm_history estm_vel];

% end

% subplot(3,1,3)
% plot(1:length(estm_history),estm_history)
% estm_list(1,end)

% 最後の速度をreturnするのが妥当．なるべく長時間推定したい感はある
% 1.5m切ったら終了

function z_lpf=LPF(z,cutoff,fps)
    %%% 平均を0に持っていく
    ave=mean(z);
    z=z-ave;
    %%% LPF
    [z_lpf,d]=lowpass(z,cutoff,fps);
    %%% 平均を元に戻す
    z_lpf=z_lpf+ave;
end

% function estm_list=kalman_filter_zihen(po,pv0,Q,R,N,t)
%     %% variables
%     po=po;
%     estm_list=zeros(2,length(po));
    
%     pHat_k_km1=[po(1);pv0];
%     i=1;
%     for po_scaler=po.'
%         try
%             fps=1/(t(i+1)-t(i));
%             % disp(fps)
%         catch
%             fps=15;
%         end
%         % system data
%         % fps=15;
%         A=[1 1/fps;0 1];
%         B=[0;1];
%         C=[1 0.1];
%         D=0;
    
%         Plant = ss(A,B,C,D,-1);
%         Plant.InputName = 'un';
%         Plant.OutputName = 'yt';
%         Sum = sumblk('un = u + w');
%         sys = connect(Plant,Sum,{'u','w'},'yt');
%         %% Filtering
%         sensors=[1];
%         % [kalmf,L,P] = kalman(sys,Q,R,N);
%         [kalmf,L,P] = kalman(sys,Q,R,N,sensors);
%         pHat_k_k=pHat_k_km1+L*(po_scaler-C*pHat_k_km1);
%         pHat_kp1_k=A*pHat_k_k;
%         estm_list(:,i)=pHat_kp1_k;
%         pHat_k_km1=pHat_k_k;
%         pHat_k_k=pHat_kp1_k;
%         i=i+1;
%     end
% end

function estm_list=kalman_filter(po,pv0,Q,R,N)
    %% variables
    po=po;
    
    %% system data
    fps=15;
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
    disp(P)
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

function estm_list=kalman_filter_ohmori(po,pv0,Q,R,N)
    %% system data
    fps=15;
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
