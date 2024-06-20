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
FR = InDepth ./ Intime; % 下渗率
disp("============霍顿拟合1============")
% 霍顿拟合
XData = CumIntime; 
YData = FR; 
JInitial_Guess = [max(FR), min(FR), 0.003];
Horton_eqn = @(params, t) params(1) + (params(2) - params(1)) * exp(-params(3) * t);
Objective = @(params) sum((Horton_eqn(params, XData) - YData).^2);
Params_Fit = lsqcurvefit(Horton_eqn, JInitial_Guess, XData, YData);
Fc_Fit = Params_Fit(1);
F0_fit = Params_Fit(2);
K_fit = Params_Fit(3);

FA_Fit = Horton_eqn(Params_Fit, CumIntime);

T_Fit = linspace(0, max(XData), 100); 
F_Fit = Horton_eqn(Params_Fit, T_Fit);
XT = T_Fit(:,8:100);
YT = F_Fit(:,8:100);
% 绘图
figure(1)
plot(XT,YT,'Color',[0,0,0],'LineWidth',1)
hold on
plot(CumIntime,FR,'o','Color',[0,0,1],'MarkerFaceColor',[0,0,1])
title('下渗曲线/霍顿拟合')
xlabel('时间(s)'); 
ylabel('下渗速率(mm/s)'); 
legend('拟合曲线','下渗速率')
STRDA = 'R²=0.806';
STRDB = 'y = 0.042129+(0.11232-0.042129)*exp(0.0014638*t)';
DIMDA = [.523 .5 .28 .28];
DIMDB = [.3 .5 .2 .2];
annotation('textbox',DIMDA,'String',STRDA,'FitBoxToText','on');
annotation('textbox',DIMDB,'String',STRDB,'FitBoxToText','on');
grid on
disp("--------------------")
disp("下渗速率图输出成功")

% 累积入渗曲线/拟合
X_DataC = CumIntime; 
Y_DataC = CumInDepth; 
model = fittype('a * x .^ b');
fitResust = fit(X_DataC,Y_DataC,model);
AE = fitResust.a;
BE = fitResust.b;

XE = linspace(0, max(X_DataC), 100); 
YE = AE .* XE .^ BE;

% 绘图
figure(2)
plot(XE,YE,'Color',[0,0,0],'LineWidth',1)
hold on
plot(X_DataC,Y_DataC,'o','Color',[0,0,1],'MarkerFaceColor',[0,0,1])
title('累积入渗曲线')
xlabel('时间(s)'); 
ylabel('入渗深度(mm)'); 
legend('拟合曲线','累积入渗','Location','northwest')
STRDAC = 'R²=0.99191';
DIMDAC = [.16 .5 .3 .3];
annotation('textbox',DIMDAC,'String',STRDAC,'FitBoxToText','on');
disp("--------------------")
disp("累积入渗曲线输出成功")

%% 四联渗压仪
Data2 = readmatrix("四联渗压仪.xlsx");
BHeight = Data2(:,2);
EHegiht = Data2(:,3);
WaterUse = Data2(:,4);
BHeightC = Data2(:,5);
EHegihtC = Data2(:,6);
Time = Data2(:,7);
CumTime = Data2(:,8);

% 渗透系数
a = 0.785;
A = 30;
L = 4;

aL = a * L;
At = A .* Time;
aA = aL ./ At;
H = zeros(length(5:1));
for i = 1:5
    H(i) = BHeight(i,:) ./ EHegiht(i,:); 
end
LG = log10(H);
LG = LG';
KV = 2.3 .* aA .* LG;

% Kv值变化
figure(3)
plot(CumTime,KV,'o-','Color',[0,0,1],'LineWidth',1,'MarkerFaceColor',[0,0,1])
title('Kv变化曲线')
xlabel('时间（s）'); 
ylabel('Kv值'); 
legend('Kv')
disp("--------------------")
disp("渗透曲线图输出成功")

% Jing
Data3 = readmatrix("四联渗压仪(jjh).xlsx");

TimeJ = Data3(:,2);
CumTimeJ = Data3(:,3);
H1J = Data3(:,4);
H2J = Data3(:,5);
aLJ = aL;
AtJ = A .* TimeJ;
aAJ = aLJ ./ AtJ;
HJ = zeros(length(8:1));
for j = 1:6
    HJ(j) = H1J(j,:) ./ H2J(j,:);
end
LGJ = log10(HJ);
LGJ = LGJ';
KVJ = 2.3 .* aAJ .* LGJ; 

disp("============霍顿拟合2============")
% J拟合
JXData = CumTimeJ; 
JYData = KVJ; 
JInitial_Guess = [max(KVJ), min(KVJ), 0.033932];
JParams_Fit = lsqcurvefit(Horton_eqn, JInitial_Guess, JXData, JYData);
JFc_Fit = JParams_Fit(1);
JF0_fit = JParams_Fit(2);
JK_fit = JParams_Fit(3);

JT_Fit = linspace(0, max(JXData), 100); 
JF_Fit = Horton_eqn(JParams_Fit, JT_Fit); 
JYE = JF_Fit(:,12:100);
JXE = JT_Fit(:,12:100);

% Kv(J)值变化
figure(4)
plot(JXE,JYE,'Color',[0,0,0],'LineWidth',1)
hold on
plot(CumTimeJ,KVJ,'o','Color',[0,0,1],'LineWidth',1,'MarkerFaceColor',[0,0,1])
title('Kv变化曲线')
xlabel('时间（s）'); 
ylabel('Kv值'); 
legend('拟合曲线','Kv')
STRDACK = 'R²=0.70395';
DIMDACK = [.71 .5 .3 .3];
annotation('textbox',DIMDACK,'String',STRDACK,'FitBoxToText','on');
disp("--------------------")
disp("渗透曲线图（J）输出成功")

% 校准
N25 = 0.919;
N20 = 1.010;
N = N25 / N20;
K20 = KVJ .* N;

% 拟合
disp("============霍顿拟合3============")
JXDataK = CumTimeJ; 
JYDataK = K20; 
JInitial_GuessK = [max(K20), min(K20), 0.0331];
JParams_FitK = lsqcurvefit(Horton_eqn, JInitial_GuessK, JXDataK, JYDataK);
JFc_FitK = JParams_FitK(1);
JF0_fitK = JParams_FitK(2);
JK_fitK = JParams_FitK(3);

JT_FitK = linspace(0, max(JXDataK), 100); 
JF_FitK = Horton_eqn(JParams_FitK, JT_FitK); 
JYEK = JF_FitK(:,12:100);
JXEK = JT_FitK(:,12:100);

% 画图
figure(5)
plot(JXEK,JYEK,'Color',[0,0,0],'LineWidth',1)
hold on
plot(CumTimeJ,K20,'o','Color',[0,0,1],'LineWidth',1,'MarkerFaceColor',[0,0,1])
title('K20变化曲线')
xlabel('时间（s）'); 
ylabel('K20值'); 
legend('拟合曲线','K20')
STRDACK20 = 'R²=0.72876';
DIMDACK20 = [.71 .5 .3 .3];
annotation('textbox',DIMDACK20,'String',STRDACK20,'FitBoxToText','on');
disp("--------------------")
disp("K20曲线图（J）输出成功")




%% 拟合信息获取
% 入渗率：霍顿拟合
InformationFitD = fitlm(XT,YT);
R2 = num2str(InformationFitD.Rsquared.Ordinary);
AR2 = num2str(InformationFitD.Rsquared.Adjusted);
RMSE = num2str(InformationFitD.RMSE);
PV1 = InformationFitD.ModelFitVsNullModel.Pvalue;
PV1 = round(PV1,3);
disp("============拟合参数信息1============")
disp(['R²: ',num2str(R2)])
disp(['调整后的R²: ',num2str(AR2)])
disp(['标准误差(RMSE): ',num2str(RMSE)])
disp(['相关性(p): ',num2str(PV1)])
disp(['稳定状态入渗率 (fc): ', num2str(Fc_Fit)]);
disp(['初始入渗率 (f0): ', num2str(F0_fit)]);
disp(['递减参数 (k): ', num2str(K_fit)]);
% 累积入渗：乘幂拟合
InformationFitDC = fitlm(XE,YE);
R2C = num2str(InformationFitDC.Rsquared.Ordinary);
AR2C = num2str(InformationFitDC.Rsquared.Adjusted);
PV2 = InformationFitDC.ModelFitVsNullModel.Pvalue;
PV2 = round(PV2,3);
disp("============拟合参数信息2============")
disp(['R²: ',num2str(R2C)])
disp(['调整后的R²: ',num2str(AR2C)])
disp(['相关性(p): ',num2str(PV2)])
% Kv：霍顿拟合
IFitKv = fitlm(JXE,JYE);
R2K = num2str(IFitKv.Rsquared.Ordinary);
AR2K = num2str(IFitKv.Rsquared.Adjusted);
PV3 = IFitKv.ModelFitVsNullModel.Pvalue;
PV3 = round(PV3,3);
disp("============拟合参数信息3============")
disp(['R²: ',num2str(R2K)])
disp(['调整后的R²: ',num2str(AR2K)])
disp(['相关性(p): ',num2str(PV3)])
% K20：霍顿拟合
IFitKv20 = fitlm(JXEK,JYEK);
R2K20 = num2str(IFitKv20.Rsquared.Ordinary);
AR2K20 = num2str(IFitKv20.Rsquared.Adjusted);
PV4 = IFitKv20.ModelFitVsNullModel.Pvalue;
PV4 = round(PV4,3);
disp("============拟合参数信息4============")
disp(['R²: ',num2str(R2K20)])
disp(['调整后的R²: ',num2str(AR2K20)])
disp(['相关性(p): ',num2str(PV4)])

%% 结果通知
Date_End = datetime("now");
disp("---------------------------------")
disp('程序运行时间:')
disp(Date_End)
disp("程序运行成功！")