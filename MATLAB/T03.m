clear
clc
warning('off', 'all');
warning('off', 'MATLAB:specificWarningID');warning('off', 'all');
warning('off', 'MATLAB:specificWarningID');
disp("程序开始运行......")
disp("---------------------------------")
%% 双环入渗仪
Data1 = readmatrix("双环下渗.xlsx");
InDepth = Data1(:,2);
CumInDepth = Data1(:,3);
Intime = Data1(:,4);
CumIntime = Data1(:,5);

% 霍顿拟合
T_DataC = CumIntime; 
F_DataC = CumInDepth; 
Initial_GuessC = [max(CumInDepth), min(CumInDepth), 0.007];
Params_FitC = lsqcurvefit(Horton_eqn, Initial_GuessC, T_DataC, F_DataC);
Cumc_Fit = Params_FitC(1);
Cum0_Fit = Params_FitC(2);
KC_Fit = Params_FitC(3);

Cum_Fit = linspace(0, max(T_DataC), 100); 
CumF_Fit = Horton_eqn(Params_FitC, Cum_Fit); 


% 绘图
figure(2)
plot(CumIntime,CumInDepth,'o','Color',[0,0,1],'MarkerFaceColor',[0,0,1])
hold on
plot(Cum_Fit,CumF_Fit,'Color',[0,1,0],'LineWidth',1)
title('下渗曲线/霍顿拟合')
xlabel('时间（s）'); 
ylabel('下渗速率（mm/s）'); 
legend('下渗速率','拟合曲线')
% STRDA = 'R²=0.95663';
% STRDB = 'y = 0.0309+(0.2785-0.0309)*exp(0.0064*t)';
% DIMDA = [.523 .5 .32 .32];
% DIMDB = [.2 .5 .4 .4];
% annotation('textbox',DIMDA,'String',STRDA,'FitBoxToText','on');
% annotation('textbox',DIMDB,'String',STRDB,'FitBoxToText','on');
grid on
disp("--------------------")
disp("下渗速率图输出成功")