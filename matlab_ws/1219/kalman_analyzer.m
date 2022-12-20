% lpfの使用にはSignal Processing Toolboxのインストールが必要．Ubuntu実行前にインストール作業を実施すること

clc;clear;

data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\kalman_stop_20.csv")

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

z=z-mean(z);

%% LPF
lowpass(z,0.1,fps)
saveas(figure(1),"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\power_20.png")
z=z+mean(z);

