clc;clear all;close all;
img=imread('C:\Users\ÎÄ²©\Desktop\bridge\10.jpg');
A=rgb2gray(img);

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

[Gmag, Gdir] = imgradient(C,'prewitt');

for i=1:n:height
    for j=1:n:length
        m=mean(Gmag(i:i+n-1,j:j+n-1),'all');
        map=repmat(m,[n n]); 
        Gmagnew(i:i+n-1,j:j+n-1)=map;
    end
end

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

for i=1:1:height
    for j=1:1:length
        if Gmagnew1(i,j)==100
            counter=counter+1;
        end      
    end
end

imshowpair(img,Gmagnew,'montage');
