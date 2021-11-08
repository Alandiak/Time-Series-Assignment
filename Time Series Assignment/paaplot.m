% This function was given code from your lecture
function  paaplot(paa,data,c,i)
    %UNTITLED4 Summary of this function goes here
s=size(data);
    dt=s(2);

ln=c;
ln=ceil(ln);
paax=[];
paay=[];
z=1;
n=1;
paax(z)=0;
paay(z)=paa(i,n);
s=size(data);
z=z+1;
for n=2:ceil(dt/c)
    paax(z)=paax(z-1)+ln;
    paay(z)=paa(i,n-1);
    z=z+1;
    paax(z)=paax(z-1);
    paay(z)=paa(i,n);
    z=z+1;
end

plot(paax,paay);
hold on
t=linspace(0,s(2),s(2));
scatter(t,data(i,:),"filled")
end