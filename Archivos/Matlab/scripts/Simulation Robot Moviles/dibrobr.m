% DIBROBR funci�n que dibuja un robot circular en 2D, con radio r , dadas las coordenadas del centro y su orientaci�n.
% Ricardo Ram�rez. Fundamentos de Rob�tica M�vil
%Universidad Nacional de Colombia
% xc, yc coordenadas del centro
%theta orientaci�n del veh�culo
%r radio del veh�culo
function []=dibrob(xc,yc,theta,r)
tc=0:pi/20:2*pi;
x=[xc xc+r*cos(tc+theta)];
y=[yc yc+r*sin(tc+theta)];
plot(x,y)
