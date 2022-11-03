function map=objF_nd_Plot(x_R, y_R, th_R, X, Y, c)

% X=[100,100]
% Y=[100,100]
% t=[1,1]

base=ones(100,100);
X_R=x_R*base;
Y_R=y_R*base;
norm_HR_mat=sqrt((X-X_R).^2+(Y-Y_R).^2);

mu_A_mat=(c.r1+c.r2)/2;
mu_B_mat=0;
sgm_A_mat=1/6*(c.r2-c.r1);
sgm_B_mat=1/6*2*norm_HR_mat; % これだけ時変
naiseki_mat=cos(th_R)*(X-X_R)+sin(th_R)*(Y-Y_R);

A_mat=pdf('Normal',norm_HR_mat,mu_A_mat,sgm_A_mat);
B_mat=pdf('Normal',naiseki_mat,mu_B_mat,sgm_B_mat);

F=A_mat.*B_mat;

map=F;

end