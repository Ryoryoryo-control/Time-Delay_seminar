%% サンプルコード1
% シャワーの温度制御
% y' = k*(Td - y(t - delay)

% --- パラメータの設定 ---
Td    = 40;     % 目標温度
k     = 1;    % 調整感度
delay = 1;      % 輸送遅延(お湯が届くまでの時間)

ddehist = @(t) 15+0*t;   % 初期温度(履歴切片)
opts    = ddeset('AbsTol', 1.0e-8) ;
tspan   = [0 10];

% --- ソルバーの実行 ---
sol     = dde23(@(t,T,Z) ddefun(t,T,Z,Td,k), delay, ddehist, tspan, opts );

% --- 可変ステップソルバーの固定ステップ補完 ---
ts = 0:0.1:tspan(end);
[ys,yp] = deval(sol, ts);



plot(ts, ys)
hold on
plot(ts, [ddehist(ts(ts<delay)),ys(ts<=(tspan(end)-delay))],'--')
plot(ts, yp, '-.')
xlabel('Time','interpreter','latex')
ylabel('$T(t),T(t-h)$ and $\dot{T}(t)$','interpreter', 'latex')
legend("$T(t)$","$T(t-h)$","$\dot{T}(t)$",'interpreter', 'latex')

% 遅延微分方程式の定義
function dTdt = ddefun(t,T,Z,Td,k)
    T_past = Z(:, 1); % 1番目の遅延データ
    dTdt = k * (Td - T_past);
end