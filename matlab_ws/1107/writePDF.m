function data = writePDF(problem,env,rbt,hmn,sns,soln)

addpath results\
now=datetime('now');
filename_csv = string("results\"+datestr(now,'yymmdd_hhMMss')+".csv");
% save(fullfile("C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\1101\results",filename_csv),'-regexp','x');
% save(fullfile("C:\Users\hyper\OneDrive\デスクトップ\VSCode\sotsuron_simulator\matlab_ws\1101\results",filename_png),'-regexp','x');
disp("計算が完了しました．実験条件を表示します．")
disp("初期条件：")
disp("時刻:"+problem.bounds.initialTime.low+" ~ "+problem.bounds.initialTime.upp)
disp("座標:"+problem.bounds.initialState.low+" ~ "+problem.bounds.initialState.upp)
disp("終端条件：")
disp("時刻:"+problem.bounds.finalTime.low+" ~ "+problem.bounds.finalTime.upp)
disp("座標:"+problem.bounds.finalState.low+" ~ "+problem.bounds.finalState.upp)
disp("境界条件：")
disp("状態境界条件:"+problem.bounds.state.low+" ~ "+problem.bounds.state.upp)
disp("制御境界条件:"+problem.bounds.control.low+" ~ "+problem.bounds.control.upp)
disp("非零のための下駄："+env.objF_nonzero)
disp("計算状況")
disp("soln.info.iterations:"+soln.info.iterations)
disp("soln.info.funcCount:"+soln.info.funcCount)
disp("soln.info.constrviolation:"+soln.info.constrviolation)
disp("soln.info.stepsize:"+soln.info.stepsize)
disp("soln.info.algorithm:"+soln.info.algorithm)
disp("soln.info.firstorderopt:"+soln.info.firstorderopt)
disp("soln.info.cgiterations:"+soln.info.cgiterations)
disp("soln.info.bestfeasible.fval:"+soln.info.bestfeasible.fval)
disp("soln.info.nlpTime:"+soln.info.nlpTime)
disp("soln.info.exitFlag:"+soln.info.exitFlag)


index=["初期時刻";"初期座標 x";"初期座標 y";"初期座標 theta";"初期座標 vx";"初期座標 vy";"初期座標 omega";"終端時刻";"終端座標 x";"終端座標 y";"終端座標 theta";"終端座標 vx";"終端座標 vy";"終端座標 omega";"状態境界 x";"状態境界 y";"状態境界 theta";"状態境界 vx";"状態境界 vy";"状態境界 omega";"制御境界 accx";"制御境界 accy";"制御境界 ang_acc";"非零のための下駄";"soln.info.iterations";"soln.info.funcCount";"soln.info.constrviolation";"soln.info.stepsize";"soln.info.algorithm";"soln.info.firstorderopt";"soln.info.cgiterations";"soln.info.bestfeasible.fval";"soln.info.nlpTime";"soln.info.exitFlag"];
value=[problem.bounds.initialTime.low+" ~ "+problem.bounds.initialTime.upp;problem.bounds.initialState.low+" ~ "+problem.bounds.initialState.upp;problem.bounds.finalTime.low+" ~ "+problem.bounds.finalTime.upp;problem.bounds.finalState.low+" ~ "+problem.bounds.finalState.upp;problem.bounds.state.low+" ~ "+problem.bounds.state.upp;problem.bounds.control.low+" ~ "+problem.bounds.control.upp;env.objF_nonzero;soln.info.iterations;soln.info.funcCount;soln.info.constrviolation;soln.info.stepsize;soln.info.algorithm;soln.info.firstorderopt;soln.info.cgiterations;soln.info.bestfeasible.fval;soln.info.nlpTime;soln.info.exitFlag];


T=table(index,value);

writetable(T,filename_csv,'Encoding','UTF-8');

end