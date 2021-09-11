%pz=csvread('C:\Users\T\Desktop\Apple_data_2_1.csv',2,1);%csvreadֻ�ܶ�ȡ������
clear;
pz=load('F:\dev\AndroidStudioProjects\AppleData\Matlab\111.txt');
%pz(:,4)=pz(:,4)-9;
mu=mean(pz);sig=std(pz); %���ֵ�ͱ�׼��
rr=corrcoef(pz); %�����ϵ������
data=zscore(pz); %���ݱ�׼��,�������� X*�� Y*
n=3;m=1; %n ���Ա����ĸ���,m ��������ĸ���
x0=pz(:,1:n);y0=pz(:,end); %ԭʼ���Ա��������������
e0=data(:,1:n);f0=data(:,end); %��׼������Ա��������������

num=size(e0,1);%��������ĸ���
chg=eye(n); %w �� w*�任����ĳ�ʼ��
for i=1:n
%���¼��� w��w*�� t �ĵ÷�������
matrix=e0'*f0*f0'*e0;
[vec,val]=eig(matrix); %������ֵ����������
val=diag(val); %����Խ���Ԫ�أ����������ֵ
[val,ind]=sort(val,'descend');
w(:,i)=vec(:,ind(1)); %����������ֵ��Ӧ����������
w_star(:,i)=chg*w(:,i); %���� w*��ȡֵ
t(:,i)=e0*w(:,i); %����ɷ� ti �ĵ÷�
alpha=e0'*t(:,i)/(t(:,i)'*t(:,i)); %���� alpha_i
chg=chg*(eye(n)-w(:,i)*alpha'); %���� w �� w*�ı任����
e=e0-t(:,i)*alpha'; %����в����
e0=e;
%���¼��� ss(i)��ֵ
beta=t\f0; %��ع鷽�̵�ϵ�������ݱ�׼����û�г�����
cancha=f0-t*beta; %��в����
ss(i)=sum(sum(cancha.^2)); %�����ƽ����
%���¼��� press(i)
for j=1:num
t1=t(:,1:i);f1=f0;
she_t=t1(j,:);she_f=f1(j,:); %����ȥ�ĵ� j �������㱣������
t1(j,:)=[];f1(j,:)=[]; %ɾ���� j ���۲�ֵ
beta1=[t1,ones(num-1,1)]\f1; %��ع������ϵ��,������г�����
cancha=she_f-she_t*beta1(1:end-1,:)-beta1(end,:); %��в�����
press_i(j)=sum(cancha.^2); %�����ƽ����
end
press(i)=sum(press_i);
Q_h2(1)=1;
if i>1, Q_h2(i)=1-press(i)/ss(i-1); end
if Q_h2(i)<0.0975
fprintf('����ĳɷָ��� r=%d',i); break
end
end
beta_z=t\f0; %�� Y*���� t �Ļع�ϵ��
xishu=w_star*beta_z; %�� Y*���� X*�Ļع�ϵ����ÿһ����һ���ع鷽��
mu_x=mu(1:n);mu_y=mu(end); %����Ա�����������ľ�ֵ
sig_x=sig(1:n);sig_y=sig(end); %����Ա�����������ı�׼��
ch0=mu_y-(mu_x./sig_x*xishu).*sig_y; %����ԭʼ���ݻع鷽�̵ĳ�����
for i=1:m
xish(:,i)=xishu(:,i)./sig_x'*sig_y(i); %����ԭʼ���ݻع鷽�̵�ϵ��
end
sol=[ch0;xish] %��ʾ�ع鷽�̵�ϵ����ÿһ����һ�����̣�ÿһ�еĵ�һ�����ǳ�����
% save mydata x0 y0 num xishu ch0 xish


[rows,~]=size(pz);
pz_b=ones(rows,1);
pz_1=[pz_b,pz(:,1:n)];
predict=pz_1*sol;
R2=1-sum((pz(:,end)-predict).^2)/sum(pz(:,end).^2);
%R2=1-sum((pz(:,4)-12).^2)/sum(pz(:,4).^2);
plot(pz(:,end));
hold on;
plot(predict);
hold on;
plot(pz(:,end)-predict);
fprintf('R2=%.3f\n',R2);
fprintf('max_difference=%.3f\n',max(abs(pz(:,end)-predict)));
fprintf('min_difference=%.3f\n',min(abs(pz(:,end)-predict)));
