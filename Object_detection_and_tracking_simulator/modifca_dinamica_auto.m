clear all
close all
clc


%%                                                                CARICO IL FILE .MAT

%Carico la dinamica dell'auto all'intenro della workspace
load('esp_on.mat');

%%                                                          ANALIZZO LA DINAMICA DELL'AUTO

%Numero di righe che compongono il file esp_on.mat
lunghezza_dinamica_auto = 800;

%Raddoppio, triplico,  quadruplico la dinamica attraverso la variabile
%numero
numero= 8;

nuova_dinamica_righe = numero * 800;
nuova_dinamica_colonne = 79;

esp_on_modificato = zeros(nuova_dinamica_righe, nuova_dinamica_colonne);

j=1;
for i = 1: lunghezza_dinamica_auto
    
    k=j;
    while( j < (k + numero))
    
        esp_on_modificato ( j , :) = esp_on( i , :);
        j= j + 1;
    end
    
end

%Questo for mi serve per cambiare il passo temporale, non più 0.04 ma ora
%pari a 0.04/numero

tempo_auto = 0.0010;
incremento_tempo_auto = tempo_auto;
incremento = 0.04;

for i = 1 : nuova_dinamica_righe
    
    esp_on_modificato(i,1) = incremento_tempo_auto;  
    incremento_tempo_auto = incremento_tempo_auto + incremento/numero;
    
end

%Salvo la nuova dinamica su file
save('esp_on_modificato.mat', 'esp_on_modificato');