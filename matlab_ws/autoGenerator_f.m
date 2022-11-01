syms x y th v omg

dx = v*cos(th);
dy = v*sin(th);
dth= omg;

f=[dx;dy;dth];

matlabFunction(f,'File','autoGen_f.m')