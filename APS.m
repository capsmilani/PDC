%**************************************************************************
%* Universidade Tecnol�gica Federal do Paran�                             *
%* Atividade pr�tica supervisionada de princ�pios de comunica��o          *
%* Nome: Matheus Milani de Assun��o                                       *
%* RA: 1342878                                                            *
%* Engenharia Eletr�nica                                                  *
%**************************************************************************
clear all; close all; clc;
%--------------------------------------------------------------------------
% Vari�veis
% fs - frequencia de amostragem
% fc - frequencia do sinal utilizado para modula��o
% data - sinal de interesse
% g - filtro
% Data - transformada de Fourier do sinal data
% dataf - sinal data convoluido por um filtro
% Dataf - transformada de Fourier do sinal data filtrado
% carry - sinal utilizado para modula��o
% Carry - transformada de Fourier do sinal utilizado para modula��o
% datamod - sinal modulado
% Datamod - transformada de Fourier do sinal modulado
% datamodf - sinal modulado e filtrado
% Datamodf - transformada de Fourier do sinal modulado e filtrado
% datademod - sinal demodulado
% Datademod - transformada de Fourier do sinal demodulado
% datademodf - sinal demodulado e filtrado
% Datademodf - transformada de Fourier do sinal demodulado e filtrado
%--------------------------------------------------------------------------
%Formata��o padr�o da figura
%fig_pos = [4, 2, 9, 4.5];                   % Figura com tamanho 4.5x9cm
fig_pos=[5 5 16 10];

fig_config = {'Color', [1,1,1], 'Units', 'Centimeters','PaperType', 'A4',...
                'PaperOrientation','portrait','Position', fig_pos,...
                'PaperPositionMode', 'auto',};
font_config = {'FontName', 'Times New Roman', 'FontSize', 12,...
                'FontWeight','normal','Units','Centimeters'};
font_config_axes = {'FontName', 'Arial', 'FontSize', 10,...
                    'FontWeight','normal','Units','Normalized'};
%--------------------------------------------------------------------------
% Aqui audioread retorna duas variaveis, data onde est� a mensagem e possui 
% tamanho variavel de acordo com o audio utilizado em um vetor 
% unidimensional e fs que � a frequencia de amostragem do arquivo de som
[data, fs] = audioread('Port_m4_8k.wav');
%%
% Depois define-se um vetor tambem unidimensinal com tamanho igual ao
% data para plotar o grafico do som e tambem j� o normaliza para a
% frequencia de amostragem obtida anteriormente
t = [0:1:length(data)-1];
t = t/fs;
%%
% Constroi o grafico de t vs data para verificar o sinal obtido 
fig1=figure(); set(fig1,fig_config{:});
plot(t,data,'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Tempo',font_config{:});
ylabel('Amplitude',font_config{:});
set(gca,font_config_axes{:});
%%
%Projeto de filtro fir utilizando a fun��o firls sendo o primeiro parametro
%a ordem do filtro desejado, o segundo termo um vetor com as porcentagens
%em que as frequ�ncias come�am a ser modificadas e o terceiro parametro � os
%valores que as respectivas frequ�ncias ser�o modificadas
i = [0 100 300 3400 3600 fs/2]/fs*2;
g = firls(127, i, [0 0 1 1 0 0]);
%%
% A fun��o freqz retorna a transformada de
% fourier de G, as entradas s�o g(a fun��o que deseja-se fazer a
% transformada), 1 que � o denominador da transformada que deseja-se
% calcular, f que � um vetor de tamanho fs+1
f = -fs/2:1:fs/2;
[G,~] = freqz(g,1,f,fs);
%%
% construindo o grafico de modulo de G vs f, para verificar que o filtro
% est� conforme o desejado na escala decibel
fig2=figure(); set(fig2,fig_config{:});
plot(f,20*log10(abs(G)),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);
%%
% construindo o grafico de fase de G vs f, para verificar que o filtro
% est� conforme o desejado na escala decibel
fig3=figure(); set(fig3,fig_config{:});
plot(f,unwrap(angle(G)),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Fase(graus)',font_config{:});
set(gca,font_config_axes{:});
%%
% segmentLength � o tamanho da janela que � utilizada para fazer a 
% transformada de data e noverlap � quanto do sinal passado � utilizado
% para realizar a proxima transformada. A fun��o pwelch retorna um vetor de
% tamanho fs, para contruir o grafico � necessario utilizar a escala dB,
% porem a fun��o pwelch retorna a energia que � o quadrado da transformada
% PS: fun��o pwelch utilizada para MATLAB vers�o 2015b 
segmentLength = 240;
noverlap = 120;
Data = pwelch(data, segmentLength, noverlap, f, fs);

%% Construindo o gr�fico de Data vs frequ�ncia
fig4 = figure(); set(fig4,fig_config{:});
plot(f,10*log10(Data),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});

%%
% passando data pelo filtro g, para isso utiliza-se a fun��o filter que tem
% como parametros(g � o filtro utilizado, 1 o denominador do filtro, e data
% � a fun��o que deseja-se filtrar), para testar a qualidade do som apos
% utilizar o filtro utilizamos a fun��o sound que tem como parametros(
% data filtrado que � a fun��o que deseja-se testar e fs � a frequencia de 
% amostragem do som  
dataf = filter(g, 1, data);
%datafiltrado = conv(data, g, 'same'); 
% pode-se utilizar a fun��o conv para realizar a convolu��o dos sinais
sound(dataf, fs);
Dataf = pwelch(dataf, segmentLength, noverlap, f, fs);

%% Construindo o gr�fico de Dataf vs frequ�ncia
fig5=figure(); set(fig5,fig_config{:});
plot(f,10*log10(Dataf),'-','Color',[0    0.4470    0.7410],'LineWidth',1);

xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);
%%
% Sinal de carry que ser� multiplicado com data para aumentar a frequencia
% de data
if fs == 16000
    fc = 4000;
else
    fc = 3950;                              % frequencia do carry
end
carry = 2*cos(2*pi*fc*t);                   % sinal criado para ser o carry 
%%
% utiliza-se a fun��o fft para realizar a transformada de fourier de um
% sinal, no caso o sinal carry, porem ao realiza-lo o sinal retornado �
% invertido ao desejado, logo utiliza-se a fun��o fftshift
Carry = fft(carry,4096)/4096;             % transformada do carry
Carry = fftshift(Carry);                  
%%
% para construir o grafico da transformada do carry o vetor das abscissas
% deve ser condizente, para ajustar utiliza-se a fun��o linspace que cria
% um vetor sendo os dois primeiros parametros da fun��o o maximo e minimo
% do vetor e o terceiro parametro � o numero de termos que o vetor deve
% ter, novamente para plotar o grafico � necessario ser na escala dB
f2 = fs/2*linspace(-1,1,4096);
fig6=figure(); set(fig6,fig_config{:});
plot(f2,20*log10(Carry),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-5000 5000]);

%%
% Multiplica-se o vetor data com o vetor transposto de carry, utilizando
% pwelch para obter a transformada de fourier do sinal modulado
datamod = data.*carry';
Datamod = pwelch(datamod, segmentLength, noverlap, f, fs);
%% Construindo o gr�fico de Datamod vs frequ�ncia
fig7=figure(); set(fig7,fig_config{:});
semilogy(f,10*log10(Datamod),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});

%%
% Depois de modular o sinal � necessario passar um filtro passa-baixa,
% porem neste caso pode-se utilizar o filtro g feito anteriormente, depois
% de convoluir o sinal modulado com o filtro g, realizamos a tranformada de
% fourier desse sinal
datamodf = filter(g, 1, datamod);
%datamodf = conv(datamod, g,'same');
Datamodf = pwelch(datamodf, segmentLength, noverlap, f, fs);
%% Construindo o gr�fico de Datamodf vs frequ�ncia
fig8=figure(); set(fig8,fig_config{:});
plot(f,10*log10(Datamodf),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);

%%
% Verificando o sinal filtrado e modulado utilizando a fun��o sound, e
% verifica-se que este sinal nada mais � que o sinal original com as
% frequencias invertidas
sound(datamodf, fs)
%audiowrite('audio2.flac', datamodf, fs);
%%
% Para demodular o sinal j� modulado multiplica-se novamente por um sinal
% carry gerado anteriormente
datademod = datamodf.*carry';
Datademod = pwelch(datademod, segmentLength, noverlap, f, fs);
%% Construindo o gr�fico de Datademod vs frequ�ncia
fig9=figure(); set(fig9,fig_config{:});
semilogy(f,10*log10(Datademod),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-8000 8000]);

%%
% Depois de multiplicar pelo carry utiliza-se o filtro g para a filtragem
% do sinal j� demodulado
datademodf = filter(g, 1, datademod);
%datademodf = conv(datademod, g,'same');
Datademodf = pwelch(datademodf, segmentLength, noverlap, f, fs);
%%
% Constroi o grafico de Datademof vs f para verificar o sinal obtido e
% tambem constroi o grafico de Dataf vs f para comparar os do
fig10=figure(); set(fig10,fig_config{:});
plot(f,10*log10(abs(Dataf)),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
hold on;
plot(f,10*log10(abs(Datademodf)),'-','Color',[0.6350    0.0780    0.1840],'LineWidth',1);

xlabel('Frequ�ncia',font_config{:});
ylabel('Densidade espectral de pot�ncia(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);

%%
% Verifica-se que o sinal foi demodulado corretamente pois o sinal �
% audivel, porem com distor��es
sound(datademodf, fs);

%%
%Para salvar �udio em MATLAB vers�o 2015:
%audiowrite('audio1.flac', dataf, fs);
%audiowrite('audio2.flac', datamodf, fs);
%audiowrite('audio3.flac', datademodf, fs);
%print(fig5,'figura3','-dmeta');
%print(fig8,'figura4','-dmeta');
%print(fig10,'figura5','-dmeta');