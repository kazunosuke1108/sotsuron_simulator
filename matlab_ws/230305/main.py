import os
import sys
import datetime
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
z8=np.array(res['z8'])
u4=np.array(res['u4'])

np.savetxt(os.environ['HOME']+'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/t.csv',t,delimiter=",")
np.savetxt(os.environ['HOME']+'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/z.csv',z,delimiter=",")
np.savetxt(os.environ['HOME']+'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/z8.csv',z8,delimiter=",")
np.savetxt(os.environ['HOME']+'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/u4.csv',u4,delimiter=",")
now=datetime.datetime.now().strftime("%y%m%d_%H%M%S")
np.savetxt(os.environ['HOME']+f'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/t_{now}.csv',t,delimiter=",")
np.savetxt(os.environ['HOME']+f'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/z_{now}.csv',z,delimiter=",")
np.savetxt(os.environ['HOME']+f'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/z8_{now}.csv',z8,delimiter=",")
np.savetxt(os.environ['HOME']+f'/catkin_ws/src/ytlab_hsr/ytlab_hsr_modules/exp_data/u4_{now}.csv',u4,delimiter=",")
eng.quit()