% lpfの使用にはSignal Processing Toolboxのインストールが必要．Ubuntu実行前にインストール作業を実施すること

clc;clear;

data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\track_results_1216_060.csv");

%% load data
fps=15
t=data(:,1);
z=data(:,4);
cutoff=0.1; %静止より

%% histogram
% nbins=100;
% ave=mean(z);
% variance=var(z);
% hist=histogram(z,nbins);
% title("average: "+string(ave)+" variance: "+string(variance))
% saveas(hist,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\hist_10.png")

ave=mean(z)
z=z-ave;

%% LPF
% [z,d]=lowpass(z,0.1,fps)
lowpass(z,0.1,fps); % 下駄を戻していない図になっているので注意
saveas(figure(1),"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\power_1216_060.png")
z=z+ave;

