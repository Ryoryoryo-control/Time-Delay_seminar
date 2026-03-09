
clc; clear; close all;

%% パラメータ
a = 1;
b = 0.5;
h = 10;

tspan = [0 30];

%% 初期履歴関数
history = @(t) 1;   % t<=0 のとき

%% DDEの定義
%dde = @(t,x,Z) -a*x - b*Z;
dde = @(t,x,Z) -a*x - b*Z + 0.5;

%% 数値解
sol = dde23(dde,h,history,tspan);

%% 時間軸
t = linspace(0,30,200);

%% theta
theta = linspace(-h,0,150);

[T,TH] = meshgrid(t,theta);

%% x(t+theta) を補間（履歴と数値解を適切に使い分け）
tp = T + TH;            % 評価時刻行列
X = zeros(size(tp));

% 履歴領域（<= sol.x(1)）と数値解領域(> sol.x(1))を分ける
mask_history = tp <= sol.x(1);   % 通常 sol.x(1) == 0
mask_solution = ~mask_history;

% 履歴を代入（history は配列入力に対応している想定）
if any(mask_history(:))
    X(mask_history) = history(tp(mask_history));
end

% dde23 の補間で評価
if any(mask_solution(:))
    % deval はベクトル化して評価できる（出力は 1 x N）
    vals = deval(sol, tp(mask_solution));
    X(mask_solution) = vals;
end


%% 履歴面のプロット（z=0 平面と θ=0 の実線・点線を追加）
figure
 hold on

% 履歴面（主面）
hs = surf(T, TH, X);
set(hs, 'EdgeColor', 'none', 'FaceAlpha', 0.95);

% theta=0 の行インデックス（厳密一致が無ければ最も近いものを使う）
[~, idx_theta0] = min(abs(theta - 0));

% theta の最大値とその行インデックス
theta_max = -h;
[~, idx_thetamax] = min(abs(theta - theta_max));

% x(t)（それぞれの theta のデータ）
x_t0 = X(idx_theta0, :);
x_tmax = X(idx_thetamax, :);

% θ=0 の実線（黒、太め）
plot3(t, zeros(size(t)), x_t0, 'k-', 'LineWidth', 2);

% θ=max(theta) の実線（グレー）
% ただし idx が同じなら二重描画しない
if idx_thetamax ~= idx_theta0
    plot3(t, theta_max*ones(size(t)), x_tmax, '-', 'Color', [0 0 0], 'LineWidth', 1.8);
end


% t=30 の断面を追加
[~, idx_t30_col] = min(abs(t - 30));    % 既に変数 t があるので再利用
x_t30 = X(:, idx_t30_col);              % 各 theta に対する x(t=20+theta)

% plot3: x座標 = 30、y座標 = theta、z座標 = x_t30
plot3(30*ones(size(theta)), theta, x_t30, 'r-', 'LineWidth', 1.8);

% θ=0 上の z=0（x=0）を点線で追加（元の要望）
plot3(t, zeros(size(t)), zeros(size(t)), 'k--', 'LineWidth', 1.5);
%hold off

xlabel('t')
ylabel('\theta')
zlabel('x(t+\theta)')
title('Convergence to equilibrium of a delay differential equation')

shading interp
colormap turbo
colorbar
view(135,30)

% z=0 平面（透過）
hp = surf(T, TH, zeros(size(T)));
%set(hp, 'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.35, 'EdgeColor', 'none');
set(hp, 'FaceColor', [0.5 0.5 0.5], ...   % 明るめのグレー
        'FaceAlpha', 0.4, ...
        'EdgeColor', 'none', ...
        'FaceLighting', 'none', ...       % ライティングオフ
        'SpecularStrength', 0);

grid on