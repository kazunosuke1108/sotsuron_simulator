function map=objFPlot(x_R,y_R,th_R,X,Y,sns)

base=ones(100,100);
X_R=x_R*base;
Y_R=y_R*base;
norm_HR_mat=sqrt((X-X_R).^2+(Y-Y_R).^2);

mu_A_mat=(sns.r1+sns.r2)/2;
mu_B_mat=0;
sgm_A_mat=1/6*(sns.r2-sns.r1);
sgm_B_mat=1/6*2*sns.phi;
naiseki_mat=cos(th_R)*(X-X_R)+sin(th_R)*(Y-Y_R);
nasukaku_mat=acos(naiseki_mat./norm_HR_mat);
nasukaku_mat=rem(nasukaku_mat,2*pi);

A_mat=pdf('Normal',norm_HR_mat,mu_A_mat,sgm_A_mat);
B_mat=pdf('Normal',nasukaku_mat,mu_B_mat,sgm_B_mat);

map=A_mat.*B_mat;

end