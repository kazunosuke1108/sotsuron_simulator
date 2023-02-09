import numpy as np
import matplotlib.pyplot as plt

csv_path=r"C:\Users\hayashide\Desktop\kazu_ws\sotsuron_simulator\matlab_ws\230106\results\230107_1340_parameter_study_d455\results.csv"
data=np.loadtxt(csv_path,delimiter=",")
plt.hist(data[:,38])
plt.show()