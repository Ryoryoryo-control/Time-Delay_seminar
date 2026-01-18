%% RDEの特性根（極）の数値計算：虚部10付近の点を特定
% 特性方程式の定義
f = @(s) s.^2 + (0.7).*s.*exp(-5.*s) + (0.2).*exp(-5.*s) + (0.14).*exp(-10.*s);

% 探索範囲の設定(解が無限にあるため)
real_min = -1;  real_max = 0.5;
imag_min = -20; imag_max = 20;

% 初期値のグリッド
x_nodes = 20;   y_nodes = 100;
[X, Y] = meshgrid(linspace(real_min, real_max, x_nodes), linspace(imag_min, imag_max, y_nodes));
initial_guesses = X(:) + 1i*Y(:);

options = optimoptions('fsolve', 'Display', 'off', 'TolFun', 1e-12, 'TolX', 1e-12);
found_poles = zeros(size(initial_guesses));

for k = 1:length(initial_guesses)
    objective = @(z) [real(f(z(1) + 1i*z(2))); imag(f(z(1) + 1i*z(2)))];
    [sol, ~, exitflag] = fsolve(objective, [real(initial_guesses(k)), imag(initial_guesses(k))], options);
    if exitflag > 0, found_poles(k) = sol(1) + 1i*sol(2); else, found_poles(k) = NaN; end
end

% 範囲内の重複なき解を抽出
found_poles = found_poles(~isnan(found_poles));
valid_indices = real(found_poles) >= real_min & real(found_poles) <= real_max & ...
                imag(found_poles) >= imag_min & imag(found_poles) <= imag_max;
unique_poles = unique(round(found_poles(valid_indices), 6));

% プロット
figure;
plot(real(unique_poles), imag(unique_poles), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
hold on;
xline(0, 'k-');yline(0, 'k-');
grid on;
xlabel('Real Part'); ylabel('Imaginary Part');