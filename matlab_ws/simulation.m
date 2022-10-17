syms x_R u(x_R)

assume(x_R>=0 & x_R<=20)


r_H0=[20.0,1.0]
r_R0=[0,1.0]

r_2=6.0
r_1=1.2

f_inv=2*x_R % [s]. x_Rが1m進むのに2秒かかる。実質tのこと。

r_H=r_H0+f_inv*[-0.1,0]
r_R=[x_R,u(x_R)]
e=[1,diff(u)]/sqrt(1+diff(u))

norm_HR=norm(r_H-r_R)
e_dot_HR=e*(r_H-r_R).'

mu_A=(r_2-r_1)/2
mu_B=0

sigma_A=1/6*(r_2-r_1)
sigma_B=1/6*2*norm_HR


A_bar=1/(sqrt(2*pi)*sigma_A)*exp(-(norm_HR-mu_A)^2/(2*sigma_A^2))
B_bar=1/(sqrt(2*pi)*sigma_B)*exp(-(e_dot_HR-mu_B)^2/(2*sigma_B^2))

F=A_bar*B_bar
G=F*diff(f_inv)
% G=1/G

eqn=functionalDerivative(G,u)==0
% eqn = simplify(eqn)
% Du(x_R)=diff(u(x_R),x_R)

assumptions

sols = dsolve(eqn)%,'Implicit',true,'IgnoreAnalyticConstraints',false)



% syms g y(x)
% assume(g,'positive')
% f=sqrt((1+diff(y)^2)/(2*g*y));
% eqn=functionalDerivative(f,y)==0;
% eqn=simplify(eqn)

(8983381526791143*exp(-(((6*x_R)/5 - 20)/(diff(u(x_R), x_R) + 1)^(1/2) + ((u(x_R) - 1)*diff(u(x_R), x_R))/(diff(u(x_R), x_R) + 1)^(1/2))^2/((2*abs(u(x_R) - 1)^2)/9 + (2*abs((6*x_R)/5 - 20)^2)/9))*exp(-(25*((abs(u(x_R) - 1)^2 + abs((6*x_R)/5 - 20)^2)^(1/2) - 12/5)^2)/32))/(7525900109056348*(abs(u(x_R) - 1)^2 + abs((6*x_R)/5 - 20)^2)^(1/2))
 