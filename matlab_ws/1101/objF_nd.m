function F=objF_nd(z,h,t,c)

x_H=h.x0+h.v*t;
y_H=h.y0+0*t;
xy_H=[x_H;y_H];

xy_R=[z(1,:); z(2,:)];

vec=xy_H-xy_R;

% size(z)
% size(xy_R)
% size(xy_H)

norm_HR=vecnorm(vec,length(t),1);

mu_A=(c.r1+c.r2)/2;
mu_B=0;
sgm_A=1/6*(c.r2-c.r1);
sgm_B=1/6*2*norm_HR; % これだけ時変

e=[cos(z(3,:));sin(z(3,:))];

% A=1/(sqrt(2*pi)*sgm_A)*exp((norm_HR-mu_A).^2/(2*sgm_A.^2))
A=pdf('Normal',norm_HR,mu_A,sgm_A);
B=pdf('Normal',dot(e,vec,1),mu_B,sgm_B);

F=A.*B;
end