[num,txt,raw] = xlsread('results.csv');
p0=num(18:end,3:8);t0=num(18:end,10:11);
p1=num(1:17,3:8);t1=num(1:17,10:11);
p=p0';t=t0';pl=p1';tl=t1';
[pn,inputStr] = mapminmax(p);
[tn,outputStr] = mapminmax(t);
net = newff(pn,tn,[4], {'tansig', 'purelin'},'traingdm');%隐含层数量从4到12取值
net.trainParam.show = 10;%每间隔10步显示一次训练结果
net.trainParam.epochs = 10000;%允许最大训练步数5000步
net.trainParam.lr = 0.01;%学习速率对于traingdm等函数建立的BP网络，学习速率一般取0.01-0.1之间。一般没有特定的什么规律，根据你的具体模型，反复改变参数，看效果 
net.trainParam.goal = 0.08;%训练目标要达到的误差值，一般设1e-3net.divideFcn = '';
net.divideFcn = '';%网络误差如果连续6次迭代都没变化，则matlab会默认终止训练。为了让程序继续运行，用命令取消这条设置
[net,tr] = train(net, pn, tn);%[net,tr]=train(net,P,T)net=init(net);初始化神经网络
A = sim(net,pn);
a = mapminmax('reverse', A, outputStr);
figure(1);
subplot(2, 1, 1); plot(1:length(t),a(1,:),':og',1:length(t), t(1,:), '-*');
legend('网络拟合输出的结果', '实际的结果');
xlabel('输入样本'); ylabel('第二天涨跌幅');
title('神经网络拟合与及实际对比图');
grid on;
subplot(2, 1, 2);plot(1:length(t),a(2,:),':og',1:length(t), t(2,:), '-*');
legend('网络拟合输出的结果', '实际的结果');
xlabel('输入样本'); ylabel('第二天收盘价');
title('神经网络拟合与及实际对比图');

plotperf(tr);%调出每次训练次数的误差收敛图

newinput = p1';
newinput = mapminmax('apply', newinput, inputStr);
newoutput = sim(net, newinput);
newoutput = mapminmax('reverse',newoutput, outputStr);
figure(2);
subplot(2, 1, 1);
plot(1:length(t1),newoutput(1,:),'g+',1:length(t1),tl(1,:),'b*');
legend('网络预测输出的结果', '实际的结果');
xlabel('测试样本'); ylabel('第二天涨跌幅');
title('神经网络预测与及实际对比图');
grid on;
subplot(2, 1, 2);plot(1:length(t1),newoutput(2,:),'-g+',1:length(t1), tl(2,:), '-b*');
legend('网络预测输出的结果', '实际的结果');xlabel('测试样本'); ylabel('第二天收盘价');title('神经网络预测与及实际对比图');

E=tl-newoutput;
E1=tl(1,:)-newoutput(1,:);
E2=tl(2,:)-newoutput(2,:);
MSE1=mse(E1)%计算均方误差作为调试的参考指标
MSE2=mse(E2)
MSE=mse(E)
