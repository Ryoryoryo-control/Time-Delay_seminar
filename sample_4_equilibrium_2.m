clc; clear; close all;

%% 遅れ時間
lags = [10 11];

%% DDE
dde = @(t,x,Z) -x + 0.5*Z(1) - 0.5*Z(2);

%% 初期履歴関数
history = @(t) 1;   % t<=0

%% 時間範囲
tspan = [0 50];

%% 数値解
sol = dde23(dde,lags,history,tspan);

%% プロット用グリッド
h = 10;
t = linspace(0,50,200);
theta = linspace(-h,0,150);

[T,TH] = meshgrid(t,theta);

%% x(t+theta)
X = zeros(size(T));

for i = 1:numel(T)
    tau = T(i) + TH(i);
    if tau < 0
        X(i) = history(tau);
    else
        X(i) = deval(sol,tau);
    end
end


%% 履歴面
figure
surf(T,TH,X, 'EdgeColor', 'none');    % 滑らかな面
hold on

% 追加する線の位置（要求どおり）
t_lines = 0:5:50;             % t = 0,5,...,50
theta_lines = 0:-2:-10;        % theta = 0,-5,-10

% t 固定の線（各 t に対して theta に沿う断面）
for tt = t_lines
    % t の列インデックス（既存の t ベクトルを使用）
    [~, idx_t] = min(abs(t - tt));
    % 各 theta に対する x(t=tt + theta) は列 idx_t の値（X(:, idx_t)）
    x_vals = X(:, idx_t);
    plot3(tt*ones(size(theta)), theta, x_vals, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.5);
end

% theta 固定の線（各 theta に対して t に沿う断面）
for th = theta_lines
    % theta の行インデックス
    [~, idx_th] = min(abs(theta - th));
    % 各 t に対する x(t + theta=th) は行 idx_th の値（X(idx_th, :)）
    x_vals = X(idx_th, :);
    plot3(t, th*ones(size(t)), x_vals, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.5);
end

xlabel('t')
ylabel('\theta')
zlabel('x(t+\theta)')

title('History surface of delay differential equation')

shading interp
colormap turbo
colorbar
view(135,30)