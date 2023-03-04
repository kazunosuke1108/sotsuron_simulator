clc;clear;

matpath="C:\Users\林出和之\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230208\results\230211_coding_maintainance\230211_152105_hmn_y0_vx\230211_152105_.mat";
load(matpath);

e_vx_list=linspace(-0.2,0.2,101);
e_y0_list=linspace(-1,1,101);

length_mtx=zeros(length(e_vx_list),length(e_y0_list));
avoid_mtx=zeros(length(e_vx_list),length(e_y0_list));

i=1;
j=1;
for e_y0=e_y0_list
    i=1;
    for e_vx=e_vx_list
        hmn.e_y0=e_y0;
        hmn.e_vx=e_vx;
        hmn.x0=env.xmax+hmn.e_vx*env.publish_time;
        length_mtx(i,j)=measure_length(t,z,u,env,rbt,hmn,sns,soln);
        avoid_mtx(i,j)=min(getNorm_HR(t,z,u,env,rbt,hmn,sns));
        i=i+1;
    end
    j=j+1;
end


len_ok_idx=find(length_mtx>=5);
len_ng_idx=find(length_mtx<5);
avoid_ok_idx=find(avoid_mtx>=hmn.personal_r);
avoid_ng_idx=find(avoid_mtx<hmn.personal_r);

[X,Y]=meshgrid(e_vx_list,e_y0_list);
subplot(1,2,1)
% surf(X,Y,length_mtx)
plot3(X(len_ok_idx),Y(len_ok_idx),length_mtx(len_ok_idx),'ob')
hold on
plot3(X(len_ng_idx),Y(len_ng_idx),length_mtx(len_ng_idx),'or')
xlabel("error in vx [m/s]")
ylabel("error in y0 [m]")
zlabel("measured length [m]")
title("measured length: vx:"+string(hmn.vx)+"[m/s] y0:"+string(hmn.y0)+" [m]")
grid on

subplot(1,2,2)
plot3(X(avoid_ok_idx),Y(avoid_ok_idx),avoid_mtx(avoid_ok_idx),'ob')
hold on
plot3(X(avoid_ng_idx),Y(avoid_ng_idx),avoid_mtx(avoid_ng_idx),'or')
xlabel("error in vx [m/s]")
ylabel("error in y0 [m]")
zlabel("minimum distance between hmn & rbt [m]")
title("minimum distance hmn <--> rbt: vx:"+string(hmn.vx)+"[m/s] y0:"+string(hmn.y0)+" [m]")
grid on
saveas("")
