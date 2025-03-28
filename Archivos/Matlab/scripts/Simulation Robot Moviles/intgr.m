%metodo de integraci�n para el ejemplo "ejem2"
function y=intgr(y,h,x,fp,met)
switch met
    case 1 %m�todo Euler de orden cero
        fder=fp(x);
        y=y+fder*h;
    case 2 % m�todo del trapecio
        fder=(fp(x)+fp(x+h))/2;
        y=y+fder*h;
    case 3 % m�todo Runge-Kutta
        disp('Rung-Kutta no programado');
    otherwise
        disp('M�todo desconocido');
end
    