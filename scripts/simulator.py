import numpy as np

# define constants & variables

class FDM():
    def __init__(self):
        # variables
        x_R0=0
        self.x_R=x_R0

        self.t=0 # 基本的にtを明示的に使うのは避け、関数fを介してx_Rで表現すること

        e_x0=1
        e_y0=0
        self.e=np.array([e_x0,e_y0])/np.linalg.norm(np.array([e_x0,e_y0]))

        self.x_H0=20
        self.y_H0=1

        # constants
        self.x_R0=0
        self.x_R1=20

        self.y_R0=1
        self.y_R1=1

        self.y_w0=0
        self.y_w1=2

        self.r_0=1.2
        self.r_1=6.0

        self.mu_A=(self.r_0+self.r_1)/2
        self.mu_B=0

        self.sigma_A=1/6*(self.r_1-self.r_0)
        self.sigma_B=1/6*2*np.linalg.norm()



        
        pass

    def f(self,t):
        x_R=t # 減速なし・X方向秒速1m/sの設計
        return x_R
    
    def u(self,x_R):
        y_R=x_R # 適当
        return y_R

    def x_H(self,t):
        return self.x_H0-t

    def y_H(self,t):
        return self.y_H0-t
