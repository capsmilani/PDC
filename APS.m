%**************************************************************************
%* Universidade Tecnológica Federal do Paraná                             *
%* Atividade prática supervisionada de princípios de comunicação          *
%* Nome: Matheus Milani de Assunção                                       *
%* RA: 1342878                                                            *
%* Engenharia Eletrônica                                                  *
%**************************************************************************
clear all; close all; clc;
%--------------------------------------------------------------------------
% Variáveis
% fs - frequencia de amostragem
% fc - frequencia do sinal utilizado para modulação
% data - sinal de interesse
% g - filtro
% Data - transformada de Fourier do sinal data
% dataf - sinal data convoluido por um filtro
% Dataf - transformada de Fourier do sinal data filtrado
% carry - sinal utilizado para modulação
% Carry - transformada de Fourier do sinal utilizado para modulação
% datamod - sinal modulado
% Datamod - transformada de Fourier do sinal modulado
% datamodf - sinal modulado e filtrado
% Datamodf - transformada de Fourier do sinal modulado e filtrado
% datademod - sinal demodulado
% Datademod - transformada de Fourier do sinal demodulado
% datademodf - sinal demodulado e filtrado
% Datademodf - transformada de Fourier do sinal demodulado e filtrado
%--------------------------------------------------------------------------
%Formatação padrão da figura
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
% Aqui audioread retorna duas variaveis, data onde está a mensagem e possui 
% tamanho variavel de acordo com o audio utilizado em um vetor 
% unidimensional e fs que é a frequencia de amostragem do arquivo de som
[data, fs] = audioread('Port_m4_8k.wav');
%%
% Depois define-se um vetor tambem unidimensinal com tamanho igual ao
% data para plotar o grafico do som e tambem já o normaliza para a
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
%Projeto de filtro fir utilizando a função firls sendo o primeiro parametro
%a ordem do filtro desejado, o segundo termo um vetor com as porcentagens
%em que as frequências começam a ser modificadas e o terceiro parametro é os
%valores que as respectivas frequências serão modificadas
i = [0 100 300 3400 3600 fs/2]/fs*2;
g = firls(127, i, [0 0 1 1 0 0]);
%%
% A função freqz retorna a transformada de
% fourier de G, as entradas são g(a função que deseja-se fazer a
% transformada), 1 que é o denominador da transformada que deseja-se
% calcular, f que é um vetor de tamanho fs+1
f = -fs/2:1:fs/2;
[G,~] = freqz(g,1,f,fs);
%%
% construindo o grafico de modulo de G vs f, para verificar que o filtro
% está conforme o desejado na escala decibel
fig2=figure(); set(fig2,fig_config{:});
plot(f,20*log10(abs(G)),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);
%%
% construindo o grafico de fase de G vs f, para verificar que o filtro
% está conforme o desejado na escala decibel
fig3=figure(); set(fig3,fig_config{:});
plot(f,unwrap(angle(G)),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Fase(graus)',font_config{:});
set(gca,font_config_axes{:});
%%
% segmentLength é o tamanho da janela que é utilizada para fazer a 
% transformada de data e noverlap é quanto do sinal passado é utilizado
% para realizar a proxima transformada. A função pwelch retorna um vetor de
% tamanho fs, para contruir o grafico é necessario utilizar a escala dB,
% porem a função pwelch retorna a energia que é o quadrado da transformada
% PS: função pwelch utilizada para MATLAB versão 2015b 
segmentLength = 240;
noverlap = 120;
Data = pwelch(data, segmentLength, noverlap, f, fs);

%% Construindo o gráfico de Data vs frequência
fig4 = figure(); set(fig4,fig_config{:});
plot(f,10*log10(Data),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});

%%
% passando data pelo filtro g, para isso utiliza-se a função filter que tem
% como parametros(g é o filtro utilizado, 1 o denominador do filtro, e data
% é a função que deseja-se filtrar), para testar a qualidade do som apos
% utilizar o filtro utilizamos a função sound que tem como parametros(
% data filtrado que é a função que deseja-se testar e fs é a frequencia de 
% amostragem do som  
dataf = filter(g, 1, data);
%datafiltrado = conv(data, g, 'same'); 
% pode-se utilizar a função conv para realizar a convolução dos sinais
sound(dataf, fs);
Dataf = pwelch(dataf, segmentLength, noverlap, f, fs);

%% Construindo o gráfico de Dataf vs frequência
fig5=figure(); set(fig5,fig_config{:});
plot(f,10*log10(Dataf),'-','Color',[0    0.4470    0.7410],'LineWidth',1);

xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);
%%
% Sinal de carry que será multiplicado com data para aumentar a frequencia
% de data
if fs == 16000
    fc = 4000;
else
    fc = 3950;                              % frequencia do carry
end
carry = 2*cos(2*pi*fc*t);                   % sinal criado para ser o carry 
%%
% utiliza-se a função fft para realizar a transformada de fourier de um
% sinal, no caso o sinal carry, porem ao realiza-lo o sinal retornado é
% invertido ao desejado, logo utiliza-se a função fftshift
Carry = fft(carry,4096)/4096;             % transformada do carry
Carry = fftshift(Carry);                  
%%
% para construir o grafico da transformada do carry o vetor das abscissas
% deve ser condizente, para ajustar utiliza-se a função linspace que cria
% um vetor sendo os dois primeiros parametros da função o maximo e minimo
% do vetor e o terceiro parametro é o numero de termos que o vetor deve
% ter, novamente para plotar o grafico é necessario ser na escala dB
f2 = fs/2*linspace(-1,1,4096);
fig6=figure(); set(fig6,fig_config{:});
plot(f2,20*log10(Carry),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-5000 5000]);

%%
% Multiplica-se o vetor data com o vetor transposto de carry, utilizando
% pwelch para obter a transformada de fourier do sinal modulado
datamod = data.*carry';
Datamod = pwelch(datamod, segmentLength, noverlap, f, fs);
%% Construindo o gráfico de Datamod vs frequência
fig7=figure(); set(fig7,fig_config{:});
semilogy(f,10*log10(Datamod),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});

%%
% Depois de modular o sinal é necessario passar um filtro passa-baixa,
% porem neste caso pode-se utilizar o filtro g feito anteriormente, depois
% de convoluir o sinal modulado com o filtro g, realizamos a tranformada de
% fourier desse sinal
datamodf = filter(g, 1, datamod);
%datamodf = conv(datamod, g,'same');
Datamodf = pwelch(datamodf, segmentLength, noverlap, f, fs);
%% Construindo o gráfico de Datamodf vs frequência
fig8=figure(); set(fig8,fig_config{:});
plot(f,10*log10(Datamodf),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);

%%
% Verificando o sinal filtrado e modulado utilizando a função sound, e
% verifica-se que este sinal nada mais é que o sinal original com as
% frequencias invertidas
sound(datamodf, fs)
%audiowrite('audio2.flac', datamodf, fs);
%%
% Para demodular o sinal já modulado multiplica-se novamente por um sinal
% carry gerado anteriormente
datademod = datamodf.*carry';
Datademod = pwelch(datademod, segmentLength, noverlap, f, fs);
%% Construindo o gráfico de Datademod vs frequência
fig9=figure(); set(fig9,fig_config{:});
semilogy(f,10*log10(Datademod),'-','Color',[0    0.4470    0.7410],'LineWidth',1);
xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-8000 8000]);

%%
% Depois de multiplicar pelo carry utiliza-se o filtro g para a filtragem
% do sinal já demodulado
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

xlabel('Frequência',font_config{:});
ylabel('Densidade espectral de potência(dB)',font_config{:});
set(gca,font_config_axes{:});
xlim([-4000 4000]);

%%
% Verifica-se que o sinal foi demodulado corretamente pois o sinal é
% audivel, porem com distorções
sound(datademodf, fs);

%%
%Para salvar áudio em MATLAB versão 2015:
%audiowrite('audio1.flac', dataf, fs);
%audiowrite('audio2.flac', datamodf, fs);
%audiowrite('audio3.flac', datademodf, fs);
%print(fig5,'figura3','-dmeta');
%print(fig8,'figura4','-dmeta');
%print(fig10,'figura5','-dmeta');