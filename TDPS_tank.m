clc;clear all;close all;
img=imread('C:\Users\文博\Desktop\tank\t9.jpg');
status=0;%=1通过；=0不通过

%当该图像任意一行的蓝色分量全部小于某一阈值时，判定通过
for i=1:1:size(img,1)
    if img(i,:,3)<100
        status=1;
    end
end

imshow(img);
if status==1
    title('turning approved');
else
    title('turning not approved');
end