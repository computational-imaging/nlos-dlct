aclose all;
clear all;

N = 128;
M = 128;

x = linspace(-1,1,N);
y = linspace(-1,1,N);
z = linspace(-1,1,M);

[X_,Y_,Z_] = ndgrid(-1:0.2:1,-1:0.2:1,0:0.1:1);
% scatter3(X_(:),Y_(:),Z_(:),8,[1,0,0],'filled');
% hold on;
[X,Y,Z] = sphere(N);

for x =-cos((0:0.02:1)*2*pi)
    lctdraw3(0,0,4);
end

for y = cos((0:0.02:1)*2*pi)
    lctdraw2(0,y,4);
end

for u = 4 - 4*sin((0:0.02:1)*pi)
    lctdraw2(0,0,4);
end

