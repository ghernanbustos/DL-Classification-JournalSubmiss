function cod = Calc_SSC(app,ts,signal,nf,posext)
% Calcula los parámetros SSC extendidos

cod = 1;
%%%%%% Parámetros SSC extendidos
Ndat = size(signal,2);

app.Ma1(nf) = sum(signal)/Ndat;
Sdif = signal - app.Ma1(nf);
Sdif2 = Sdif.*Sdif;
app.Da2(nf) = sum(Sdif2)/Ndat;
app.Da3(nf) = sum(Sdif2.*Sdif)/Ndat;

%%%% Método 1:
% abssignal = abs(signal);
% sumabs = sum(abssignal);
%%%%
%%%% Método 2:
sumabs = sum(abs(signal));
%%%%
if sumabs == 0
    sumabs = Ndat; 
end
%%%% Método 1:
% app.Mt1(nf) = sum(abssignal.*ts)/sumabs;
% tdif =  ts - app.Mt1(nf);
% tdif2 = tdif.*tdif;
% tdif3 = tdif.*tdif2;
% app.Dt2(nf) = sum(abssignal.*tdif2)/sumabs;
% app.Dt3(nf) = sum(abssignal.*tdif3)/sumabs;            
%%%%
%%%% Método 2:
app.Mt1(nf) = sum(signal.*ts)/sumabs;
tdif =  ts - app.Mt1(nf);
tdif2 = tdif.*tdif;
tdif3 = tdif.*tdif2;
app.Dt2(nf) = sum(signal.*tdif2)/sumabs;
app.Dt3(nf) = sum(signal.*tdif3)/sumabs;            
%%%%%%

Next = size(posext,2);
if Next < 2
    cod = 0;
    app.Mt(nf) = NaN;
    app.Ma(nf) = NaN;
    app.Dt(nf) = NaN;            
    app.Da(nf) = NaN;
    return
end
%%%%%% Parámetros SSC
Nseg = Next-1;
SegA = abs(signal(posext(2:Next))-signal(posext(1:(Next-1))));
SegT = ts(posext(2:Next)) - ts(posext(1:(Next-1)));
app.Mt(nf) = sum(SegT)/Nseg;
app.Ma(nf) = sum(SegA)/Nseg;
app.Dt(nf) = sum(abs(SegT - app.Mt(nf)))/Nseg;            
app.Da(nf) = sum(abs(SegA - app.Ma(nf)))/Nseg;
%%%%%%
end
