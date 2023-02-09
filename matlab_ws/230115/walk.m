clc;clear;
csv_path="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0108\results\csv\analysis.csv"

data=readmatrix(csv_path);
type="exp"

if type=="all"
    ok_idx=1:length(data(:,1))
    x=data(:,1)
    mean_data=data(ok_idx,[7 3 5])
    std_data=data(ok_idx,[13 9 11])
    skew_data=data(ok_idx,[19 15 17])
    kurtosis_data=data(ok_idx,[25 21 23])
elseif type=="exp"
    ok_idx=[1 2 3 4 5 6 7 10 11 12 13 14 15 16]
    x=[1 2 3 4 5 6 7 8 10 11 12 13 14 15 16]
    mean_data=[[0,0,0];data(ok_idx,[7 3 5])]
    std_data=[[0,0,0];data(ok_idx,[13 9 11])]
    skew_data=[[0,0,0];data(ok_idx,[19 15 17])]
    kurtosis_data=[[0,0,0];data(ok_idx,[25 21 23])]
end
fig1=figure(1);clf;
b=bar(x,mean_data)
b(1).FaceColor=[1,0,0];
b(2).FaceColor=[0,0,1];
b(3).FaceColor=[0,1,0];
legend("VICON: truth","HSR: raw","HSR: odometry compensated",'Location','northwest','FontSize',5);
xlabel("experiment number")
ylabel("mean of position y [m]")
title("mean of position y")
exportgraphics(fig1,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0108\results\analysis\mean_"+string(type)+".png",'Resolution',500);

fig1=figure(1);clf;
b=bar(x,std_data)
b(1).FaceColor=[1,0,0];
b(2).FaceColor=[0,0,1];
b(3).FaceColor=[0,1,0];
legend("VICON: truth","HSR: raw","HSR: odometry compensated",'Location','northwest','FontSize',5);
xlabel("experiment number")
ylabel("std of position y [m]")
title("standard deviation of position y")
exportgraphics(fig1,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0108\results\analysis\std_"+string(type)+".png",'Resolution',500);

fig1=figure(1);clf;
b=bar(x,skew_data)
b(1).FaceColor=[1,0,0];
b(2).FaceColor=[0,0,1];
b(3).FaceColor=[0,1,0];
legend("VICON: truth","HSR: raw","HSR: odometry compensated",'Location','northwest','FontSize',5);
xlabel("experiment number")
ylabel("skewness of position y")
title("skewness of position y")
exportgraphics(fig1,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0108\results\analysis\skew_"+string(type)+".png",'Resolution',500);


fig1=figure(1);clf;
b=bar(x,kurtosis_data)
b(1).FaceColor=[1,0,0];
b(2).FaceColor=[0,0,1];
b(3).FaceColor=[0,1,0];
legend("VICON: truth","HSR: raw","HSR: odometry compensated",'Location','northwest','FontSize',5);
xlabel("experiment number")
ylabel("kurtosis of position y")
title("kurtosis of position y")
exportgraphics(fig1,"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_experiment\sotsuron_experiment\results\0108\results\analysis\kurtosis_"+string(type)+".png",'Resolution',500);