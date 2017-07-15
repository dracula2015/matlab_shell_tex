function output = fal( s, a, d )
%FAL 此处显示有关此函数的摘要
%   此处显示详细说明
if abs(s(1))<=d
    f1=s(1)/(d^(1-a));
else
    f1=abs(s(1))^a*sign(s(1));
end

if abs(s(2))<=d
    f2=s(2)/(d^(1-a));
else
    f2=abs(s(2))^a*sign(s(2));
end

if abs(s(3))<=d
    f3=s(3)/(d^(1-a));
else
    f3=abs(s(3))^a*sign(s(3));
end

output = [f1; f2; f3];
end

