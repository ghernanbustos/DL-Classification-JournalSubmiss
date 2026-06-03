% Author: Héctor Hugo Segnorile
% Modify: by Guillermo Bustos
% Method added:
%   PulseExtraction(app), detects and gets pulse from RAW DATA array (Real Pulse).

% Example 1: Use to extract ESSC params
%
% clear OSig
% OSig = Metodo_ESSC_ANN(); % Construct Object Variable
% 
% % Sinc data signal
% OSig.Carga_Signal(y, x);
% esscMat = OSig.Obtiene_ESSC();
% % Calc ESSC params
% esscMat_Aux = reshape(esscMat,30,1); % Format input data for ANN model.

% Example 2: Only Extract Detected pulse.
% clear OSig
% OSig = Metodo_ESSC_ANN(); % Construct Object Variable
%  
% % Generate time vector
%     nColumns = size(TrainMat_Sinc_25dB(1,:),2);
%     timeArray = linspace(0, 1, nColumns);
% 
% figure
%     plot(timeArray,TrainMat_Sinc_25dB(500,:));
% 
% % Sinc data signal
% OSig.Carga_Signal(TrainMat_Sinc_25dB(500,:), timeArray);
% detectedPulse = OSig.PulseExtraction();
% 
% figure
%     plot(detectedPulse); % Check array size


classdef Metodo_ESSC_ANN_V2 < matlab.System
    properties (Access = private)
        %%%%% Señal de entrada:
        FNIn % Nro. de puntos de la señal completa (Full)
        FdtIn % Paso de tiempo para la señal completa
        FtIn % Valores de tiempo de la señal completa
        NIn % Nro. de puntos de la señal o pulso
        dtIn % Paso de tiempo del pulso
        tIn % Valores de tiempo del pulso

        FSignalIn % Señal completa  
        FFSignalIn % Señal completa Filtrada
        SignalIn % Señal (pulso extraído)
        DerSignalIn % Derivada
        IntSignalIn % Integral
        FAux % Función auxiliar
        
        SWAplicarFMediana = 0;
        rnMa1 % Radio 1 del Filtro de Mediana (Señal)
        SwFMa = 0;
        rnMa2 % Radio 2 del Filtro de Mediana (Derivada)
        SWAplicarFMedia = 0;
        rnMe % Radio del Filtro de Media
        SWCorrOffSAmp = 0;
        nOffS % Nro. de puntos al inicio/final de la señal para determinar el OffSet
        nDes % Nro. de puntos que se descartan al inicio/final de la señal para determinar el OffSet y la detección del pulso
        ValOffS % Valor del offset de la señal
        
        %%%%% Parámetros:
        tolDefPulIn % Tolerancia para definir el inicio y fin del pulso
        niniPIn % Posición inicial del pulso
        nfinPIn % Posición final del pulso
        rnext % Cantidad de elementos por punto para buscar los extremos
        % Extremos de la Señal o Pulso:
        posextIn % Posición en la Señal o Pulso
        posextDerIn % Posición en la Derivada
        posextIntIn % Posición en la Integral
        DatosSSC % Tabla de valores de los parámetros SSC
        GrillaSSC % Arreglo con los valores SSC
    end
    
    properties (Access = public)      
        Mt,Dt,Ma,Da % Parámetros SSC
        Ma1,Da2,Da3,Mt1,Dt2,Dt3 % Parámetros SSC extendidos
    end
    
    methods (Access = public)
        function app = Metodo_ESSC_ANN_V2() % Constructor, Called when creating the object:
            app.SWAplicarFMediana = 1;
            app.rnMa1 = 20;  % Filtro Mediana Señal
            app.SwFMa = 1;
            app.rnMa2 = 10; % Filtro Mediana Derivada
            app.SWAplicarFMedia = 1;
            app.rnMe = 50;
            app.SWCorrOffSAmp = 1;
            app.nOffS = 10;
            app.nDes = 6;  % Faltaba este param
            app.tolDefPulIn = 7; % Lower get hole signal / higher lose part of signal.
            app.rnext = 5; % Detect ESSC
        end
        
        function Carga_Signal(app, OFSignalIn, OFtIn)
            app.FSignalIn = OFSignalIn;
            app.FtIn = OFtIn;
            app.FNIn = size(OFtIn,2);
            app.NIn = app.FNIn;
            app.tIn = app.FtIn;
            app.SignalIn = [];
            app.DerSignalIn = [];
            app.IntSignalIn = [];
            app.FFSignalIn = [];
         end

        function normDetectedPulseAmp = PulseExtraction(app)
            DefinePulso(app);
            % normDetectedPulseAmp = app.SignalIn;
            normDetectedPulseAmp = app.FSignalIn(app.niniPIn:app.nfinPIn);
         end

        function GrillaSSC_out = Obtiene_ESSC(app)        
            DefinePulso(app);
            GeneraDerivada(app);
            GeneraIntegral(app);
            GeneraSSC(app);
            GrillaSSC_out = app.GrillaSSC;
         end
    end

    methods (Access = private)

        function DefinePulso(app)
            AplicaFiltrosCorrOffSAmp(app);
            DetectaPulso(app); % Detection over filtered signal

            app.NIn = app.nfinPIn - app.niniPIn + 1;
            app.SignalIn = [];
            app.SignalIn = app.FFSignalIn(app.niniPIn:app.nfinPIn);
            %%%%%% Normaliza amplitud
            app.SignalIn = app.SignalIn/max(abs(app.SignalIn));
            %%%%%%
            app.tIn = [];
            %%%%%% Normaliza tiempo 
            app.dtIn = 1/(app.NIn-1);
            app.tIn = (0:(app.NIn-1))*app.dtIn;           
            %%%%%%                 
        end

        function AplicaFiltrosCorrOffSAmp(app)
            app.FFSignalIn = app.FSignalIn;

            if app.SWAplicarFMediana
                app.FFSignalIn = Filtro0_Mediana(app.FFSignalIn, app.rnMa1);
            end
            if app.SWAplicarFMedia
                app.FFSignalIn = Filtro0_Media(app.FFSignalIn, app.rnMe);
            end
            if app.SWCorrOffSAmp
                if app.FNIn > (2*app.nOffS)
                    despT = app.nDes + app.nOffS;
                    app.ValOffS = sum(app.FFSignalIn((app.nDes+1):despT));
                    app.ValOffS = app.ValOffS + sum(app.FFSignalIn((app.FNIn-app.nDes):-1:(app.FNIn-despT)));
                    app.ValOffS = app.ValOffS /(2*app.nOffS);
                    % disp(app.ValOffS)
                    app.FFSignalIn = app.FFSignalIn - app.ValOffS;
                end
                app.FFSignalIn = app.FFSignalIn / max(abs(app.FFSignalIn));
            end
        end

        function DetectaPulso(app) % Detection over filtered signal
            [app.niniPIn, app.nfinPIn] = Extrae_Pulso_D(app.FFSignalIn,app.tolDefPulIn/100,app.nDes);
            % disp(app.niniPIn);
            % disp(app.nfinPIn);
        end

        function DetectaExtremos(app)
            if ~isempty(app.SignalIn)
                app.posextIn = [];
                app.posextIn = Calcula_Extremos(app.SignalIn,app.rnext);
            end
            if ~isempty(app.DerSignalIn)
                app.posextDerIn = [];
                app.posextDerIn = Calcula_Extremos(app.DerSignalIn,app.rnext);
            end
            if ~isempty(app.SignalIn)
                app.posextIntIn = [];
                app.posextIntIn = Calcula_Extremos(app.IntSignalIn,app.rnext);
            end
        end

        function GeneraDerivada(app)
            app.DerSignalIn = [];
            CalcDerivada(app);                      
            if app.SwFMa
                app.DerSignalIn = Filtro0_Mediana(app.DerSignalIn,app.rnMa2);
            end
            app.DerSignalIn = app.DerSignalIn/max(abs(app.DerSignalIn));
        end

        function GeneraIntegral(app)
            app.IntSignalIn = [];
            CalcIntegral(app);
            app.IntSignalIn = app.IntSignalIn/max(abs(app.IntSignalIn));           
        end

        function CalcDerivada(app)
            %%%%%% Método 1:
            app.FAux = [];
            app.FAux = app.SignalIn(2:app.NIn);
            app.FAux(app.NIn) = 0;
            app.DerSignalIn = app.FAux-app.SignalIn;
            %%%%%%
            %%%%%% Método 2
            % for n = 1:(app.NIn-1)
            %     app.DerSignalIn(n) = (app.SignalIn(n+1)-app.SignalIn(n));
            % end
            % app.DerSignalIn(app.NIn) = -app.SignalIn(app.NIn);
            %%%%%%
        end

        function CalcIntegral(app)
            %%%%%% Método 1:
            app.IntSignalIn = cumsum(app.SignalIn);    
            %%%%%%
            %%%%%% Método 2:
            % ValInt = 0;
            % for n = 1:app.NIn
            %     ValInt = ValInt + app.SignalIn(n);
            %     app.IntSignalIn(n) = ValInt;
            % end           
            %%%%%%
        end

        function GeneraSSC(app)
            DetectaExtremos(app);
            if ~isempty(app.posextIn)
                nfun = 2;
                Calc_SSC(app,app.tIn,app.SignalIn,nfun,app.posextIn);
                app.DatosSSC.ValS = [app.Mt(nfun);app.Dt(nfun);app.Ma(nfun);app.Da(nfun);...
                    app.Ma1(nfun);app.Da2(nfun);app.Da3(nfun);app.Mt1(nfun);app.Dt2(nfun);app.Dt3(nfun)];
            end
            if ~isempty(app.posextDerIn)
                nfun = 3;
                Calc_SSC(app,app.tIn,app.DerSignalIn,nfun,app.posextDerIn);
                app.DatosSSC.ValD = [app.Mt(nfun);app.Dt(nfun);app.Ma(nfun);app.Da(nfun);...
                    app.Ma1(nfun);app.Da2(nfun);app.Da3(nfun);app.Mt1(nfun);app.Dt2(nfun);app.Dt3(nfun)];
            end
            if ~isempty(app.posextIntIn)
                nfun = 1;
                Calc_SSC(app,app.tIn,app.IntSignalIn,nfun,app.posextIntIn);
                app.DatosSSC.ValI = [app.Mt(nfun);app.Dt(nfun);app.Ma(nfun);app.Da(nfun);...
                    app.Ma1(nfun);app.Da2(nfun);app.Da3(nfun);app.Mt1(nfun);app.Dt2(nfun);app.Dt3(nfun)];                    
            end
            app.GrillaSSC = [app.DatosSSC.ValI,app.DatosSSC.ValS,app.DatosSSC.ValD];
        end        

    end

end