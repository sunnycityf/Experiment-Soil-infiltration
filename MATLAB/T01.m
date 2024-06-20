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
InRate = InDepth ./ Intime;

% 下渗速率拟合（对数）
XD = InRate;
SHD = log(XD);
PD = polyfit(XD,SHD,1);
SHD2 = polyval(PD,XD);
YD = exp(SHD2);

% 拟合曲线平滑(下渗速率）
XInTime=linspace(min(Intime),max(Intime));
YDE = interp1(Intime,YD,XInTime,'cubic');
BD = PD(1);
AD = exp(PD(2));

% 霍顿拟合
HDT = Intime;



% % 拟合信息获取(霍顿拟合)
% InformationFitD = fitlm(XInTime,HDY);
% HDR2D = num2str(InformationFitD.Rsquared.Ordinary);
% disp("============拟合信息参数============")
% disp(['R²: ',num2str(HDR2D)])

% % 下渗速率绘图
% figure(1)
% plot(Intime,InRate,'o','Color',[0,0,1],'MarkerFaceColor',[0,0,1])
% hold on
% plot(XInTime,HDY,'Color',[0,1,0],'LineWidth',1.5)
% title('下渗曲线')
% xlabel('时间（s）'); 
% ylabel('下渗速率（mm/s）'); 
% legend('下渗速率','拟合曲线')
% STRDA = 'R²=0.9084';
% STRDB = 'y = fc+(0.0227-fc)*exp(15.56*t)';
% DIMDA = [.5 .5 .1 .1];
% DIMDB = [.5 .5 .17 .17];
% annotation('textbox',DIMDA,'String',STRDA,'FitBoxToText','on');
% annotation('textbox',DIMDB,'String',STRDB,'FitBoxToText','on');
% grid on
% disp("--------------------")
% disp("下渗速率图输出成功")

% 累积入渗曲线拟合
XSD = CumInDepth;
SHSD = log(XSD);
SPD = polyfit(XSD,SHSD,1);
SHSD2 = polyval(SPD,XSD);
YSD = exp(SHSD2);

% 拟合曲线平滑(累积入渗）
XInTime=linspace(min(CumIntime),max(CumIntime));
YDES = interp1(CumIntime,YSD,XInTime,'cubic');
BSD = SPD(1);
ASD = exp(SPD(2));

figure(2)
plot(CumIntime,CumInDepth,'o','Color',[0,0,1],'MarkerFaceColor',[0,0,1])
hold on
plot(XInTime,YDES,'Color',[0,1,0],'LineWidth',1.5)
title('累积入渗曲线')
xlabel('时间（s）'); 
ylabel('入渗深度mm'); 
legend('累积入渗','拟合曲线')

%% 运行结果通知
Date_End = datetime("now");
disp("---------------------------------")
disp('程序运行时间:')
disp(Date_End)
disp("程序运行成功！")
