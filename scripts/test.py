import numpy as np
from scipy.stats import norm
from scipy import integrate

class Test():
    def __init__(self):
        print(integrate.quad(self.func,0,1))
        pass
    def func(self,x):
        return self.func2(x)
    
    def func2(self,x):
        return x**2

print(Test())