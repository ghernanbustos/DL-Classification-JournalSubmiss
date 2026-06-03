function dato_filtrado = Filtro0_Media(dato, radio)
% Suaviza la función dada en "dato" utilizando un filtro de Media
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
    
    prom = sum(dato_rell(1:interv))/interv;
    dato_filtrado(1) = prom;
    for n = (radio+2):(NdatT-radio)
        prom = prom + (dato_rell(n+radio)-dato_rell(n-radio-1))/interv;
        dato_filtrado(n-radio) = prom;
    end
end
