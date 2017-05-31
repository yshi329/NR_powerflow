%% EE570 Group Project 
% project 5
% Developed by Shi Yunfei, Luo Yifeng
% Date 2017 April 18

%% Part 1 
% A Matlab program to solve the scalar function f(x)=2x^2-5x+2 using NR method.


prompt = {'Enter parameters a:','b:','c:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'2','-5','2'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
input=str2num(char(answer));
a = input(1);
b = input(2);
c = input(3);

error = 0.0001;
syms x;
fx = a*x^2+b*x+c;% fx = 2*x^2-5*x+2;
dfx = diff(fx);
x = randi(10); %initialize
xguess = [x];
fxguess = [eval(fx)];
accu = [];
delta_x = 1;
nbit = 0;

t = [-2: 0.01:10];
ft = 2*t.^2-5*t+2;
plot(t,ft)
hold

while abs(delta_x) >=error
    delta_x =-(eval(fx)/eval(dfx));
    x =x + delta_x;
    accu = [accu abs(delta_x)];
    xguess = [xguess x];
    fxguess = [fxguess eval(fx)];
    nbit=nbit+1;
end

t = 1:length(accu);
plot(xguess, fxguess)
plot (x,0,'O','MarkerEdgeColor','r',...     
                'MarkerFaceColor','r',...   
                'MarkerSize',4)
figure (2)
plot(t,accu);

x
