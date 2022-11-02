function F=objF(z,h,t)

x_H=h.x0+h.v*t;
y_H=h.y0+0*t;
xy_H=[x_H;y_H];

xy_R=[z(1,:); z(2,:)];

vec=xy_H-xy_R;

% size(z)
% size(xy_R)
% size(xy_H)

norm_HR=vecnorm(vec,length(t),1);

% F=norm_HR.^(-1);
F=norm_HR;

end