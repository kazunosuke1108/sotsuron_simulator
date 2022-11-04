% MAIN.m

% official version



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Fundamental preparation                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

clc; clear;
addpath 'C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\tutorial\cartPole'
savename=string("results\"+datestr(now,'yymmdd_hhMMss'));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Defenition of variables                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

env=getEnvironmentParams();
rbt=getRobotParams();
hmn=getHumanParams();
sns=getcSensorParams();

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.func.dynamics=@(t,z,u)(dynamics(z,u,env,rbt,hmn,sns));
problem.func.pathObj=@(t,z,u)(objF(t,z,u,env,rbt,hmn,sns));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up problem bounds                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.bounds.initialTime.low = env.tmin;
problem.bounds.initialTime.upp = env.tmin;
problem.bounds.finalTime.low = env.tmax;
problem.bounds.finalTime.upp = env.tmax;

problem.bounds.initialState.low = [rbt.x0;env.ymin;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.initialState.upp = [rbt.x0;env.ymax;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.finalState.low = [rbt.xF;env.ymin;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];
problem.bounds.finalState.upp = [rbt.xF;env.ymax;rbt.th0;rbt.vx0;rbt.vy0;rbt.omg0];

problem.bounds.state.low = [rbt.x0;rbt.y0;-Inf;rbt.vxmin;rbt.vymin;rbt.omgmin];
problem.bounds.state.upp = [rbt.xF;rbt.yF;Inf;rbt.vxmax;rbt.vymax;rbt.omgmax];

problem.bounds.control.low = [rbt.axmin;rbt.aymin;rbt.aangmin];
problem.bounds.control.upp = [rbt.axmax;rbt.aymax;rbt.aangmax];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                    Initial guess at trajectory                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
problem.guess.time = [env.tmin,env.tmax];
problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
problem.guess.control = [0,0;0,0;0,0];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                         Solver options                                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
problem.options.nlpOpt = optimset(...
'Display','iter',...
'MaxFunEvals',1e6);

% problem.options.method = 'trapezoid'; 
problem.options.method = 'hermiteSimpson';  

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                            Solve!                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

soln = trajOpt(problem);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Summarize conditions & results                   %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

writePDF(problem,soln);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Display Solution                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%


n = length(soln.grid.time);
t = linspace(soln.grid.time(1), soln.grid.time(end), 15*(n-1)+1);
z = soln.interp.state(t);
u = soln.interp.control(t);

%%%% Plots:
figure(1); clf;
pltHistory(t,z,u);
savename_png = savename+".png";
saveas(figure(1),savename_png);

%%%% Animations:

figure(2); clf;
drawAnimation(t,z,u,env,rbt,hmn,sns,soln,savename);
