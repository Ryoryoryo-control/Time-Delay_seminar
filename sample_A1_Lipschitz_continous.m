clc; clear; close all;

% パラメータ設定
K = 1;              
x0 = 0;             
f0 = 0;             

% x範囲
x = linspace(-3,3,400);

% スカラー関数の例
f = 0.5*sin(2*x);  

% リプシッツ上限・下限
y_upper = f0 + K*(x - x0);
y_lower = f0 - K*(x - x0);

% プロット
figure; hold on;

% 帯を塗る
fill([x fliplr(x)], [y_lower fliplr(y_upper)], [0.8 0.8 0.8], 'FaceAlpha',0.5, 'EdgeColor','none');

% f(x) の曲線
plot(x, f, 'k', 'LineWidth',2);

% 中心点
plot(x0, f0, 'ko','MarkerFaceColor','k','MarkerSize',8);

% 軸設定
xlabel('x'); ylabel('f(x)');
xlim([-3 3]); ylim([-3 3]);
grid on; box on;