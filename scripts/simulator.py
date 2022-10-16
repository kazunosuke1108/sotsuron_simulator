import numpy as np
from scipy.misc import derivative # 微分器
from scipy.stats import norm # 正規分布
from scipy import integrate

# define constants & variables

class FDM():
    def __init__(self):
        # variables
        x_R0=0
        self.x_R=x_R0

        self.t=0 # 基本的にtを明示的に使うのは避け、関数fを介してx_Rで表現すること

        e_x0=1
        e_y0=0
        # self.e=np.array([e_x0,e_y0]).reshape(-1,1)/np.linalg.norm(np.array([e_x0,e_y0]))

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

        
        pass

    def x_H(self,t):
        return self.x_H0-t

    def y_H(self,t):
        return self.y_H0-t

    
    def u(self,x_R):
        y_R=x_R # 適当
        return y_R

    def e(self,x_R):
        du__per__dx_R=derivative(func=self.u,x0=x_R,dx=1e-5, n=1)
        e_x=1/np.sqrt(1+du__per__dx_R**2)
        e_y=1/np.sqrt(1+1/(du__per__dx_R**2))
        return np.array([e_x,e_y]).reshape(-1,1)

    def f(self,t): # 逆関数の更新も忘れずに
        x_R=t # 減速なし・X方向秒速1m/sの設計
        return x_R

    def f_inv(self,x_R): # 順方向の関数更新も忘れずに
        t=x_R
        return t

    def G(self,x_R):
        u_x_R=self.u(x_R=x_R)
        t=self.f_inv(x_R=x_R)
        df_inv__per__dx_R=derivative(func=self.f_inv,x0=x_R,dx=1e-5,n=1)
        return self.F(x_R=x_R,u_x_R=u_x_R,t=t)*df_inv__per__dx_R

    def F(self,x_R,u_x_R,t):
        return self.A_bar(x_R=x_R)*self.B_bar(x_R=x_R)

    def A_bar(self,x_R):
        t=self.f_inv(x_R=x_R)
        x_H=self.x_H(t=t)
        y_H=self.y_H(t=t)
        r_H=np.array([x_H,y_H]).reshape(-1,1)

        r_R=np.array([x_R,self.u(x_R=x_R)]).reshape(-1,1)

        x=np.linalg.norm(r_H-r_R)

        mu_A=(self.r_0+self.r_1)/2
        sigma_A=1/6*(self.r_1-self.r_0)
        
        return self.A(x=x,mu=mu_A,sigma=sigma_A)
        
    def B_bar(self,x_R):
        t=self.f_inv(x_R=x_R)
        x_H=self.x_H(t=t)
        y_H=self.y_H(t=t)
        r_H=np.array([x_H,y_H]).reshape(-1,1)

        r_R=np.array([x_R,self.u(x_R=x_R)]).reshape(-1,1)
        
        e=self.e(x_R=x_R)
        x=np.dot(e.T,r_H-r_R)
        
        mu_B=0
        sigma_B=1/6*2*np.linalg.norm(r_H-r_R)
        
        return self.B(x=x,mu=mu_B,sigma=sigma_B)

    def A(self,x,mu,sigma):
        return norm.pdf(x=x,loc=mu,scale=sigma)

    def B(self,x,mu,sigma):
        return norm.pdf(x=x,loc=mu,scale=sigma)

    def T(self):
        return integrate.quad(self.G,self.x_R0,self.x_R1)

fdm=FDM()

print(fdm.T())
