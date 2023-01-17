addpath 'C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\tutorial\cartPole';
% addpath '/home/hayashide/kazu_ws/sotsuron_simulator/matlab_ws/tutorial/cartPole'

matpath="C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230117\results\230117_check\230117_081432_vx011_y025\230117_081432_.mat";
% matpath="/home/hayashide/kazu_ws/sotsuron_simulator/matlab_ws/1210/results/1210_parastd4Hz/221210_140704_xmax10_ymin-2/221210_140704_test.mat"
load(matpath)


date="230117";
abst="visualizer";
detail="230117_081432_";
mkdir('results');
savedir="results\"+date+"_"+abst;
% savedir="results/"+date+"_"+abst;
mkdir(savedir);
savedir=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
% savedir=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+detail);
mkdir(savedir);

graph_title="return";
savename=string(savedir+"\"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);
% savename=string(savedir+"/"+datestr(now,'yymmdd_hhMMss')+"_"+graph_title);

% n = length(soln.grid.time);
% t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
% z = soln.interp.state(t);
% u = soln.interp.control(t);

% Plots
%% add score to fig name
try
    graph_title=graph_title+" J="+soln.info.bestfeasible.fval;
catch
    graph_title="error";
end
%% History
figure(1); clf;
pltHistory(t,z,u,env,rbt,hmn,sns,soln,graph_title);
savename_png = savename+"_3_hist.png";
saveas(figure(1),savename_png);

%% Animation
figure(2); clf;
savename_3_anim=savename+"_3_anim";
% drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);
drawAnimation_z8(t,z,z8,u,env,rbt,hmn,sns,soln,savename_3_anim,graph_title);

figure(3); clf;
drawPath(t,z,u,env,rbt,hmn,sns,soln,savename,graph_title);
savename_3_path = savename+"_3_path.png";
saveas(figure(3),savename_3_path);
