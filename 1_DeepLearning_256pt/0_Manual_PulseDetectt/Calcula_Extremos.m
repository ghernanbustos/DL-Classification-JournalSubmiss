function PosExt = Calcula_Extremos(Signal,nprom_ext)
% Obtiene los puntos extremos de 'Signal' utilizando un arreglo de radio
% 'nprom_ext' para definir si un punto es extremo

next = 1;
maxdat = size(Signal,2);
PosExt = [];

%%% Sin extremos
%if maxdat < (2*nprom_ext+1)
%    return
%end
%%%

%%% Con extremos
for np = 1:maxdat
%%%
%%% Sin extremos (se quita un radio del arreglo de búsqueda por extremo)
%for np = (nprom_ext+1):(maxdat-nprom_ext)
%%%
    
    np_ini = np - nprom_ext;
    if np_ini < 1 
        np_ini = 1;
    end
    np_fin = np + nprom_ext;
    if np_fin >= maxdat
        np_fin = maxdat;
    end
   
    for npi = np_ini:np_fin
        if npi == np_ini
            np_max = np_ini;
            np_min = np_ini;
            amp_max = Signal(np_ini);
            amp_min = Signal(np_ini);
        else
            if Signal(npi) > amp_max
                np_max = npi;
                amp_max = Signal(npi);
            end
            if Signal(npi) < amp_min
                np_min = npi;
                amp_min = Signal(npi);
            end
        end
    end
    
    if np == np_max || np == np_min
        PosExt(next) = np;
        next = next + 1;
    end
end

if next == 1
    PosExt(next) = maxdat;
    next = next + 1;
end
