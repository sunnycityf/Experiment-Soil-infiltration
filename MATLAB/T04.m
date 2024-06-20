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
model = fittype('fc + (f0 -fc) .* exp((-k) .* x)');

Data3 = readmatrix("四联渗压仪(jjh).xlsx");
a = 0.785;
A = 30;
L = 40;

aL = a * L;
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

fitResust = fit(CumTimeJ,KVJ,model);