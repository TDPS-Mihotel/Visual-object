clc;clear all;close all;
img=imread('C:\Users\文博\Desktop\gate\g6.jpg');

imblue=img(:,:,3);%图片蓝色分量
height=size(img,1);%图片长宽，避免后期重复计算
length=size(img,2);

for i=1:1:height
    for j=1:1:length
        if imblue(i,j)<100
            imblue(i,j)=1;
        else
            imblue(i,j)=0;
        end
    end
end %将图片按蓝色分量大小以某一阈值分类统一

[Gmag, Gdir] = imgradient(imblue,'prewitt');%求分类后图片的梯度
record=zeros([1 length]);%初始化用于记录每一列符合条件的点的个数

%（核心思路）当某一列具有N个（这里取20）或以上个点满足它正下方第50、150、200
%个点强度都大于某一阈值时，这一列的符合条件的点数被记录在record里，若不符合
%任意条件，这一列在record里直接记为零
for i=1:1:height
    for j=1:1:length
        if i<height-200 && Gmag(i+50,j)>=3 && Gmag(i+100,j)>=3 && Gmag(i+150,j)>=3
            Gmag(i,j)=1;
        else
            Gmag(i,j)=0;
        end
    record(:,j)=sum(Gmag(:,j));
    if record(j)<(20)
        record(j)=0;
    end
    end
end

%如果出现相邻的几个列都满足条件，那么只保留最后一列作为门一只腿这一条边的位置
for j=1:1:length-1
    if record(j)~=0 && record(j+1)~=0
        record(j)=0;
    elseif record(j)~=0 && record(j+1)==0
        record(j)=1;
    else
        record(j)=0;
    end
end

A=find(record==1);%找到所有边的位置
sizeA=size(A,2);%确定边的条数（不同视角下边数可能会不同，不一定全是2*4=8条）

%根据边的几何关系确定是否满足转向的条件
if sizeA>5
  if abs((A(5)+A(4))/2-mean(A))<10
    %这里的判定条件是当第4、5条边的中间点与所有边的中间点（均值）位置相差
    %小于10个像素时判过，第4、5条边限定了必须是2+2（每只脚左右两个边缘
    %4、5分别对应左2-2和右1-1）的图案，加上中间点接近的条件限定了对称性，
    %从而实现对“正确转向位置”的辨识。
    status=2;%status=2:能识别到桥且允许转向
  else
    status=1;%status=1:能识别到桥但不满足转向条件
  end
elseif sizeA<=5 && sizeA>1
  status=1;
elseif sizeA<=1
  status=0;%status=0：不能识别到桥
end

%作图演示
subplot(1,1,1);
imshow(img); hold on
for i=1:1:size(A,2)
    plot(A(i),[100:100:300],'x');
end

switch status
    case 2
        title({['Gate identified: Turning allowed']});
    case 1
        title({['Gate identified: Turning not allowed']});
    case 0
        title({['Gate not identified: Turning not allowed']});
end