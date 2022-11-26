# パス追加用にsysをインポート
import sys
# matlabAPIのパスを追加
sys.path.append('/usr/local/MATLAB/R2022b/extern/engines/python/build/lib/')
sys.path.append('/home/ytpc2022h/kazu_ws/sotsuron_simulator/matlab_ws/1126')
# モジュールをインポート
import matlab.engine

# matlabエンジンをスタート
eng = matlab.engine.start_matlab()
# 自分のスクリプトに引数を渡して戻り値を変数に格納
res = eng.MAIN_func()
# 結果を出力
print(res)
eng.quit()