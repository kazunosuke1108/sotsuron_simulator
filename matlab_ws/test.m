syms x

norm_HR=abs(x)
r_1=1.2
r_2=6.0
y = piecewise(norm_HR < r_1,0,r_2<norm_HR,0,1)