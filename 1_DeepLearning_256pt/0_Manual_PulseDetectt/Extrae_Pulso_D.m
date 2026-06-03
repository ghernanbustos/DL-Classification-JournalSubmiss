function [nini,nfin] = Extrae_Pulso_D(Signal,tol,ndes)
% Extrae los elementos donde se inicia y termina un pulso dentro de
% 'Signal' utilizando 'tol' para definir la tolerancia porcentual a partir
% de la cual se considera que hay señal. Se descartan 'ndes' puntos al inicio
% y final de la señal.

maxdat = size(Signal,2);
nini = 1;
nfin = maxdat;
ninid = 1 + ndes;
nfind = maxdat - ndes;

tol = abs(tol);
if tol < 0 || tol > 1
    return
end

Signal = abs(Signal);
tolSignal = tol * max(Signal);

for n = ninid:maxdat
    if Signal(n) >= tolSignal
      nini = n;
      break
    end
end
for n = nfind:-1:1
    if Signal(n) >= tolSignal
      nfin = n;
      break
    end
end
if nini > nfin
    nini = 1;
    nfin = maxdat;
end


