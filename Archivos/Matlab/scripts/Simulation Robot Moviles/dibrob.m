% DIBROB funci�n que dibuja un robot circular en 2D, dadas las coordenadas del centro y su orientaci�n.
% Ricardo Ram�rez. Fundamentos de Rob�tica M�vil
% Universidad Nacional de Colombia. 2015
% xc, yc coordenadas del centro
% theta orientaci�n del veh�culo
function []=dibrob(xc,yc,theta)
tc=0:pi/20:2*pi;
x=[xc xc+0.5*cos(tc+theta)];
y=[yc yc+0.5*sin(tc+theta)];
plot(x,y)