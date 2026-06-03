function dato_filtrado = Filtro0_Mediana(dato, radio)
% Suaviza la función dada en "dato" utilizando un filtro de Mediana
% estadística, siendo "radio" un número impar que es la mitad del intervalo
% del filtro. Se agregan 0 en los extremos de "dato". 

dato_filtrado = [];

radio = floor(abs(radio));
interv = 2*radio+1;

Ndat = size(dato, 2);
if Ndat > interv
    %%% Filtro aplicado rellenando con 0 al inicio y al final
    ceros(1:radio) = 0;
    dato_rell = [ceros,dato,ceros];
    NdatT = Ndat + 2*radio;
    for n=(radio+1):(NdatT-radio)
        dat_aux = dato_rell((n-radio):(n+radio));
        for i=1:interv
            for j=i:interv
                if dat_aux(i)>dat_aux(j)
                    aux = dat_aux(i);
                    dat_aux(i) = dat_aux(j);
                    dat_aux(j) = aux;
                end
            end
        end
        dato_filtrado(n-radio) = dat_aux(radio+1);
    end
end
