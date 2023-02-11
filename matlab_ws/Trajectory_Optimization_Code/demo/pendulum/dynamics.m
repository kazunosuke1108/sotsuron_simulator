function [dx, dxGrad] = dynamics(x,u,p)
% [dx, dxGrad] = dynamics(x,u,p)
%
% Computes the dynamics (and gradients) for the simple pendulum
%

q = x(1,:);
dq = x(2,:);

    k = p.k;    c = p.c;
    ddq = -c*dq - k*sin(q) + u;
    dx = [dq;ddq];

    %ここ以下何してる？
if nargout == 2   % Analytic gradients　%nargout 現在実行中の関数(dynamicsのこと)の呼び出し時に指定された関数出力引数の数を返す
    nTime = length(u);
    
    dqGrad = zeros(1,4,nTime); %4 = [time + angle + rate + torque];
    dqGrad(1,3,:) = 1; %gradient dq wrt dq  
    
    ddqGrad = zeros(1,4,nTime);  %4 = [time + angle + rate + torque]; %trapezoidしてたら導関数連続じゃないからgrad求められへんのちゃう？
    ddqGrad(1,2,:) = -k*cos(q);   %gradient ddq wrt q
    ddqGrad(1,3,:) = -c;  %gradient ddq wrt dq
    ddqGrad(1,4,:) = 1;  %gradient ddq wrt u
    
    dxGrad = cat(1, dqGrad, ddqGrad);
    
end

end