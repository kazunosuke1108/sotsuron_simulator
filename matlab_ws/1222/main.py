import os
import sys
import time
import numpy as np
from pprint import pprint
# matlabAPIのパスを追加
sys.path.append('/usr/local/MATLAB/R2022b/extern/engines/python/build/lib/') # local実行時
sys.path.append(os.environ['HOME']+'/catkin_ws/src/MATLAB/R2022b/extern/engines/python/build/lib') # docker実行時
sys.path.append("/home/hayashide/catkin_ws/src/MATLAB/R2022b/extern/bin/glnxa64")
import matlab.engine

sys.path.append(os.environ['HOME']+'/kazu_ws/sotsuron_simulator/matlab_ws/1126')

# matlabエンジンをスタート
eng = matlab.engine.start_matlab("-softwareopengl") # softwareopenglはサポートされていないらしい
# 自分のスクリプトに引数を渡して戻り値を変数に格納
res = eng.MAIN_func()
# 結果を出力
t=np.array(res['t'])
z=np.array(res['z'])

np.savetxt(t,os.environ['HOME']+'/catkin_ws/sotsuron_experiment/exp_data/dev/t.csv',delimiter=",")
np.savetxt(z,os.environ['HOME']+'/catkin_ws/sotsuron_experiment/exp_data/dev/z.csv',delimiter=",")
np.savetxt(t,os.environ['HOME']+f'/catkin_ws/sotsuron_experiment/exp_data/log/t_{time.time()}.csv',delimiter=",")
np.savetxt(z,os.environ['HOME']+f'/catkin_ws/sotsuron_experiment/exp_data/log/z_{time.time()}.csv',delimiter=",")
eng.quit()