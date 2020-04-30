clc;clear all;close all;
img=imread('C:\Users\ÎÄ²©\Desktop\tank\t9.jpg');
status=0;

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
