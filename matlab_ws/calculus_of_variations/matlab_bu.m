% definition
%% constants & variables

x_R0=0;
x_R=x_R0;

t=0; % 基本的にtを明示的に使うのは避け、関数fを介してx_Rで表現すること

e_x0=1;
e_y0=0;
% e=np.array([e_x0,e_y0]).reshape(-1,1)/np.linalg.norm(np.array([e_x0,e_y0]))

global x_H0;
x_H0=20;
global y_H0;
y_H0=1;

x_R0=0;
x_R1=20;

y_R0=1;
y_R1=1;

y_w0=0;
y_w1=2;

r_0=1.2;
r_1=6.0;


diff(u,x_R)

function out = x_H(t)
    global x_H0
    out = x_H0-t;
end

function out = y_H(t)
    global y_H0
    out = y_H0-t;
end

function out=e(x_R)
    out=simplify(diff(u(x_R)));
    
end

function out = u(x_R)
    out = x_R;
end
                                                                    