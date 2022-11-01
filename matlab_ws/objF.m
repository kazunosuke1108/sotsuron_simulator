function norm_HR=objF(z,h,t)

x_H=h.x0+h.v*t;
y_H=h.y0;
xy_H=[x_H,y_H];

xy_R=[z(1,:), z(2,:)];

norm_HR=norm(xy_H-xy_R);

end