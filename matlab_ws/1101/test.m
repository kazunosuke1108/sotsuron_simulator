ex_xR=2;
ex_yR=3;
ex_thR=pi/2;
base=ones(100,100);
ex_XR=ex_xR*base;
ex_YR=ex_yR*base;
ex_norm=sqrt((X-ex_XR).^2+(Y-ex_YR).^2);
size(ex_norm)
ex_e=[cos(ex_thR);sin(ex_thR)]
ex_naiseki=cos(ex_thR)*(X-ex_XR)+sin(ex_thR)*(Y-ex_YR)
size(ex_naiseki)

x_R=12;
y_R=1;
th_R=pi/2;

base=ones(100,100);
X_R=x_R*base;
Y_R=y_R*base;
norm_HR_mat=sqrt((X-X_R).^2+(Y-X_R).^2)

mu_A_mat=(c.r1+c.r2)/2;
mu_B_mat=0;
sgm_A_mat=1/6*(c.r2-c.r1);
sgm_B_mat=1/6*2*norm_HR_mat; % これだけ時変
naiseki_mat=cos(th_R)*(X-X_R)+sin(th_R)*(Y-Y_R);

A_mat=pdf('Normal',norm_HR_mat,mu_A_mat,sgm_A_mat);
B_mat=pdf('Normal',naiseki_mat,mu_B_mat,sgm_B_mat);
F_mat=A_mat.*B_mat
size(F_mat)
