clear;clc;
num = 30;
x = linspace(0,1,num);
error = rand(1,num);
 
A0 = 1;
B0 = 2;
a = A0*exp(B0*x)+0.5*error;
%% 
sh = log(a); % 先对要拟合的数据取对数
 
p = polyfit(x,sh,1); % 然后对这个中间量sh进行线性拟合
% B = p(1)
% lnA = p(2)
 
% -----------------方法一：可以求出指数拟合的解析式------------------------
    B = p(1);
    A = exp(p(2));
 
    y1 = A*exp(B*x);
    
% -----------------方法二：这种方法绕过求解解析式，直接得到拟合曲线---------
    sh2 = polyval(p,x);
    y2 = exp(sh2);
    
 
% 可见，两种方式求解得到的结果相同
subplot(1,2,1)
plot(x,a,'o',x,y1,'-')
subplot(1,2,2)
plot(x,a,'o',x,y2,'-')

