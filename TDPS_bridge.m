clc;clear all;close all;
img=imread('C:\Users\文博\Desktop\bridge\10.jpg');
A=rgb2gray(img);

%对图像进行模糊化处理
n=16;
height=size(A,1)-mod(size(A,1),n);
length=size(A,2)-mod(size(A,2),n);
B=A(1:height,1:length);

for i=1:n:height
    for j=1:n:length
        k=mean(B(i:i+n-1,j:j+n-1),'all');
        map=repmat(k,[n n]);   
        C(i:i+n-1,j:j+n-1)=map; 
    end
end

%求模糊化处理后的全图梯度
[Gmag, Gdir] = imgradient(C,'prewitt');

%将梯度幅度中的零全部以上面的n*n的矩阵为单位求均值补齐
for i=1:n:height
    for j=1:n:length
        m=mean(Gmag(i:i+n-1,j:j+n-1),'all');
        map=repmat(m,[n n]); 
        Gmagnew(i:i+n-1,j:j+n-1)=map;
    end
end

%提取处理后图像中梯度极小（原图像素分布均匀）的部分并归类
for i=1:1:height
    for j=1:1:length
        if Gmagnew(i,j)<0.2
            Gmagnew1(i,j)=100;
        else
            Gmagnew1(i,j)=0;
        end
    end
end

counter=0;

%统计图像中符合上一步标准的像素点个数
for i=1:1:height
    for j=1:1:length
        if Gmagnew1(i,j)==100
            counter=counter+1;
        end      
    end
end

%判定+作图演示
if counter>10000%如果符合要求的像素点个数足够多->判定有桥
    [ly,lx]=find(Gmagnew1==100);
    cx=floor(mean(lx));
    cy=floor(mean(ly));%确定桥的几何中心
    
    crossy=[1:32:size(img,1)];
    crossx=repmat(cx,[1 size(crossy,2)]);
    
    mid=size(img,2)/2;%确定小车的中心
    diff=mid-cx;%小车中心与桥中心的位置差->用于判定是否对齐
    
    subplot(2,1,1);
    imshow(img); hold on
    plot(crossx(:),crossy(:),'x');
    if abs(diff)>30
     title({['bridge identified'];['distance=',num2str(diff)];['DO NOT TURN!']});
    else 
     title({['bridge identified'];['distance=',num2str(diff)];['TURN NOW!']});
    end
    subplot(2,1,2);
    imshow(Gmagnew1);
else
    subplot(2,1,1);
    imshow(img);
    title({['no bridge'];['DO NOT TURN!']});
    subplot(2,1,2);
    imshow(Gmagnew1);
end