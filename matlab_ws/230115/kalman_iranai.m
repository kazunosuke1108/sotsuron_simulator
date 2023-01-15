clc;clear;
fig=figure(1);
data=readmatrix("C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\track_results_1216_060.csv");
for i = 1:length(data(:,1))
    if data(i,4)<10
        break
    end
end
disp(i)
data=data([i:end],:);
t=data(:,1)-data(1,1);
z=data(:,4);
p=polyfit(t,z,1);
disp(p)
plot(t,z)
hold on
plot(t,p(1)*t+p(2))
xlabel("time [s]")
ylabel("position [m]")
title("a: "+string(p(1))+" b: "+string(p(2)))
saveas(fig,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\scripts\kalman\kalman_nashi_060.png")