% シンボリック変数を定義
syms x_R u(x_R)

% 各種変数・定数の定義
r_H0=[20.0,1.0] % 人間の初期位置座標
r_R0=[0,1.0] % ロボットの初期位置座標

r_2=6.0 % 歩容計測可能な距離の最大値（扇の外側半径）
r_1=1.2 % 歩容計測可能な距離の最小値（扇の内側半径）

f_inv=2*x_R % x_R=f(t)の逆関数．変数tを消すために用いられ，ある時点でのロボットのx座標から，その時刻を求める．今はロボットが0.5m/sで進むと仮定

r_H=r_H0+f_inv*[-0.1,0] % 時刻f_inv(x_R)での（廊下方向）にのみ0.1m/sで進むと仮定
r_R=[x_R,u(x_R)] % 時刻f_inv(x_R)でのボットの座標
e=[1,diff(u)]/sqrt(1+diff(u)) % ロボットの方向ベクトル

norm_HR=norm(r_H-r_R) % 人とロボットの相対距離
e_dot_HR=e*(r_H-r_R).' % 人とロボットの相対ベクトルと，ロボットの方向ベクトルの内積．「人とロボットの相対距離 x cos(2つのベクトルの内積)」に等しい．

% 扇内に入っていることを評価する，汎関数の定義

mu_A=(r_2-r_1)/2 % 扇の半径方向の正規分布の平均値
mu_B=0 % 扇の角度方向の正規分布の平均値

sigma_A=1/6*(r_2-r_1) % 扇の半径方向の正規分布の標準偏差
sigma_B=1/6*2*norm_HR % 扇の角度方向の正規分布の標準偏差


A_bar=1/(sqrt(2*pi)*sigma_A)*exp(-(norm_HR-mu_A)^2/(2*sigma_A^2)) % 扇の半径方向の正規分布の確率密度関数
B_bar=1/(sqrt(2*pi)*sigma_B)*exp(-(e_dot_HR-mu_B)^2/(2*sigma_B^2)) % 扇の角度方向の正規分布の確率密度関数

% F=A_bar*B_bar % 扇に人が入っていることを評価する汎関数（使用停止中）
F=norm_HR % デバッグのために定義した仮の汎関数．x_Rとu(x_R)で表される．（使用停止中）
F=e_dot_HR % デバッグのために定義した仮の汎関数．x_Rとu(x_R)とu'(x_R)で表される．
G=F*diff(f_inv) % t -> x_R　の変数変換


% Galerkin法実装のためのu(x_R)の定義．uは最適化変数となる係数のalphaと基底関数のsin,cosからなる
n=1
alpha=sym('alpha',[1 2*n+1]) % 基底関数の係数．これを最適化変数として動かし，近似的にuを求めたい．

theta=2*pi*(x_R-r_R0(1))/(r_H0(1)-r_R0(1)) % 変数x_Rをsin,cosの引数に入れるにあたり，周期を整えてこれをthetaとする．
phi=[1;
    cos(theta);
    sin(theta);
    % cos(2*theta); % デバッグのため，高次元はコメントアウトしている．
    % sin(2*theta);
    % cos(3*theta);
    % sin(3*theta);
    % cos(4*theta);
    % sin(4*theta);
    % cos(5*theta);
    % sin(5*theta);
    % cos(6*theta);
    % sin(6*theta);
    % cos(7*theta);
    % sin(7*theta);
    % cos(8*theta);
    % sin(8*theta);
    % cos(9*theta);
    % sin(9*theta);
    % cos(10*theta);
    % sin(10*theta);
    ]

u_kari=alpha*phi % 近似解の定義

l=functionalDerivative(G,u)^2 % 汎関数G，汎関数の引数uを与え，これらからなるオイラー方程式を作成する．（Symbolic必須）

in_int=subs(l,u,u_kari)*sum(phi,2) % オイラー方程式に近似解を代入する．

L=int(in_int,x_R,r_R0(1),r_H0(1)) % 全行程での誤差の累計を求める．
% この計算の際，alphaがSymbolic変数のため，積分計算ができません．しかし，alphaは最適化変数なので，数値で置き換えることは避けたいです．



% in_int_mf=matlabFunction(in_int)
% in_int_mf2=@(x_R)in_int_mf(x_R,alpha1,alpha2,alpha3)

% % start integral
% L=integral(in_int_mf2,r_R0(1),r_H0(1),"ArrayValued",true)






% l=subs(l,u,u_kari)*sum(phi,2)
% l=subs(l,u,u_kari)




% alpha1=1
% alpha2=1
% alpha3=1
% in_int_mf2=@(x_R)in_int_mf(x_R,alpha1,alpha2,alpha3)

% fminsearch(@(alpha1,alpha2,alpha3)integral(@(x_R)in_int_mf(x_R,alpha1,alpha2,alpha3),r_R0(1),r_H0(1)),[1,1,1])



% L=int(l,r_R0(1),r_H0(1),'IgnoreAnalyticConstraints',true,'IgnoreSpecialCases',true)
