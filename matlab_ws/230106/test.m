clc;clear;
fig=figure(1);clf;
csv_path="C:\Users\林出和之\Downloads\results.csv";
data=readmatrix(csv_path);
y0=data(:,61);
vx=data(:,60);
vmax=data(:,39);
len=data(:,56);
dist=data(:,55);

% ok_idx=find(vmax<=0.22);
% ng_idx=find(vmax>0.22);
% ok_idx=find(len>=5);
% ng_idx=find(len<5);
ok_idx=find(dist>=0.8);
ng_idx=find(dist<0.8);

% plot3(y0(ng_idx),vx(ng_idx),vmax(ng_idx),'ob')
% hold on
% plot3(y0(ok_idx),vx(ok_idx),vmax(ok_idx),'or')

% plot3(y0(ok_idx),vx(ok_idx),len(ok_idx),'or')
% hold on
% plot3(y0(ng_idx),vx(ng_idx),len(ng_idx),'ob')

plot3(y0(ok_idx),vx(ok_idx),dist(ok_idx),'or')
hold on
plot3(y0(ng_idx),vx(ng_idx),dist(ng_idx),'ob')

xlabel("hmn.y0 [m]");
ylabel("hmn.vx [m/s]");
% zlabel("measured length [m]");
zlabel("min distance [m]");
grid on

% plot3(y0,vx,len,'o')
% xlabel("hmn.y0 [m]");
% ylabel("hmn.vx [m/s]");
% zlabel("measured length [m]");
% grid on
saveas(fig,"C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230106\results\20230109_graph\min_dist.png")