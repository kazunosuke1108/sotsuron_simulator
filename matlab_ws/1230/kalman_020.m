%% https://www.jstage.jst.go.jp/article/iscie/25/7/25_172/_pdf offset補償

clc;clear;

data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\kalman_stop_20.csv");
fps=15;
t=data(:,1);
z=data(:,4);

%% LPF
cutoff=0.1; %静止より
average=mean(z);
z=z-average;
[z,d]=lowpass(z,cutoff,fps);
disp(var(z))

%% Kalman Filter
% data=data((1:150),:)
figure(1); clf;

t=data(:,1)-data(1,1);
po=z
dansage=[0;z([1:length(t)-1])];
size(dansage);
pv=(po-dansage)*fps;
vectors_p=[po];


A=[1 1/fps;0 1];
B=[0;1];
C=[1 0];
D=0;

Plant = ss(A,B,C,D,-1);
Plant.InputName = 'un';
Plant.OutputName = 'yt';

Sum = sumblk('un = u + w');
sys = connect(Plant,Sum,{'u','w'},'yt');

% for Q = 0.0005:0.0001:0.0015
%     for R = 0.0005:0.0001:0.0015

% 10m Q=0.0029 R=10000000000
% 15m Q= R=

Q=13.1298
for R=10000000000
    N = 0;
    [kalmf,L,P] = kalman(sys,Q,R,N);
    % disp(L)
    estm_list=zeros(2,length(t));
    pHat_k_km1=[vectors_p(1);0];
    i=1;
    for vector_p=vectors_p.'
        pHat_k_k=pHat_k_km1+L*(vector_p-C*pHat_k_km1);
        pHat_kp1_k=A*pHat_k_k;
        estm_list(:,i)=pHat_kp1_k;
        pHat_k_km1=pHat_k_k;
        pHat_k_k=pHat_kp1_k;
        i=i+1;
    end
    estm_list(1,:)=estm_list(1,:)+average;
    % plot(t,estm_list(1,:).')
    plot(t,estm_list(2,:).')
    hold on
    % disp(Q)
    % disp(R)
    p=polyfit(t,estm_list(1,:),1);
    disp(p(1))
    clearvars pHat_k_km1 pHat_k_k pHat_kp1_k vector_p
end
% end
po=po+average;
% plot(t,po,'r')
plot(t(1:end-1),pv(2:end),'r')
% hold on
% p=polyfit(t,estm_list(1,:),1);
% disp(p)
% % f = polyval(p,t);
% % plot(t,f,'-') 
% best
% Q=0.001
% R=0.1

% 0.60m/s 150f (15m) -0.85m/s
% 0.90m/s 80f (15m) -1.78m/s
% 1.20m/s 60f (15m) -1.82m/s
title("Q: "+string(Q)+"  R: "+string(R))
saveas(figure(1),"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\kalman_lpf_tv_20.png")

% disp(A)

% Ts=-1;
% sys=ss(A,[B B],C,D,Ts,'InputName',{'u' 'w'},'OutputName','y');

% Q=2.3;
% R=1;

% [kalmf,L,~,Mx,Z] = kalman(sys,Q,R);

% sys.InputName = {'u','w'};
% sys.OutputName = {'yt'};
% vIn = sumblk('y=yt+v');

% kalmf.InputName = {'u','y'};
% kalmf.OutputName = 'ye';

% SimModel = connect(sys,vIn,kalmf,{'u','w','v'},{'yt','ye'});

% t = data(:,1);
% % u = zeros(length(t),1)
% u = data(:,4);

% rng(10,'twister');
% w = sqrt(Q)*randn(length(t),1);
% v = sqrt(R)*randn(length(t),1);

% out = lsim(SimModel,[u,w,v])

% yt = out(:,1);   % true response
% ye = out(:,2);  % filtered response
% y = yt + v;     % measured response

% clf
% subplot(211), plot(t,yt,'b',t,ye,'r--'), 
% xlabel('Number of Samples'), ylabel('Output')
% title('Kalman Filter Response')
% legend('True','Filtered')
% subplot(212), plot(t,yt-y,'g',t,yt-ye,'r--'),
% xlabel('Number of Samples'), ylabel('Error')
% legend('True - measured','True - filtered')

