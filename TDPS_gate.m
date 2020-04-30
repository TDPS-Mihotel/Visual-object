clc;clear all;close all;
img=imread('C:\Users\ÎÄ²©\Desktop\gate\g6.jpg');

imblue=img(:,:,3);
height=size(img,1);
length=size(img,2);

for i=1:1:height
    for j=1:1:length
        if imblue(i,j)<100
            imblue(i,j)=1;
        else
            imblue(i,j)=0;
        end
    end
end

[Gmag, Gdir] = imgradient(imblue,'prewitt');
record=zeros([1 length]);

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

for j=1:1:length-1
    if record(j)~=0 && record(j+1)~=0
        record(j)=0;
    elseif record(j)~=0 && record(j+1)==0
        record(j)=1;
    else
        record(j)=0;
    end
end

A=find(record==1);
sizeA=size(A,2);

if sizeA>5
  if abs((A(5)+A(4))/2-mean(A))<10
    status=2;
  else
    status=1;
  end
elseif sizeA<=5 && sizeA>1
  status=1;
elseif sizeA<=1
  status=0;
end

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