clc;clear;
figure(1); clf;

data=csvread("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\sources\track_results_1216_090.csv");
fps=15;

t=data(:,1);
po=data(:,4);
dansage=[0;data([1:length(t)-1],4)]
size(dansage)
pv=(po-dansage)*fps
vectors_p=[po];



for Q = 0.001:0.001:0.001
    for R = 0.1:0.1:0.1
        N = 0;
        % disp(Q)
        % disp(R)
        % disp(L)
        estm_list=zeros(2,length(t));
        pHat_k_km1=[vectors_p(1);-0.60];
        i=1;
        for vector_p=vectors_p.'
            try
                fps=1/(data(i,1)-data(i-1,1));
            catch
                fps=15;
            end
            A=[1 1/fps;0 1];
            B=[0;1];
            C=[1 0];
            D=0;
            
            Plant = ss(A,B,C,D,-1);
            Plant.InputName = 'un';
            Plant.OutputName = 'yt';
            
            Sum = sumblk('un = u + w');
            sys = connect(Plant,Sum,{'u','w'},'yt');
            
            [kalmf,L,P] = kalman(sys,Q,R,N);
            
            pHat_k_k=pHat_k_km1+L*(vector_p-C*pHat_k_km1);
            pHat_kp1_k=A*pHat_k_k;
            estm_list(:,i)=pHat_kp1_k;
            pHat_k_km1=pHat_k_k;
            pHat_k_k=pHat_kp1_k;

            i=i+1;
            
        end
        plot(t,estm_list(1,:).')
        % plot(t,estm_list(2,:).')
        hold on
        clearvars pHat_k_km1 pHat_k_k pHat_kp1_k vector_p
    end
end
plot(t,po,'r')
% plot(t(1:end-1),pv(2:end),'r')

saveas(figure(1),"kalman_observable_v_Q0001_R01.png")

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