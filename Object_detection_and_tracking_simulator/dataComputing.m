GRAFICI VARI - ERRORE ASCISSA

%Dopo aver simulato il sistema di rilevamento ed inseguimento, realizzo un
%grafico che mi consente di valutare il valore dell'errore lungo l'ascissa nel
%tempo
h_1 = figure;
vettore_tempi = 1 : 1 : length(errore_x_pixel_vett);
vettore_tempi_2 = 1 : .1 : length(errore_x_pixel_vett);
figure_ascissa = plot(vettore_tempi, errore_x_pixel_vett, 'b');
title('Errore ascissa vettore distanza centroidi');
if(abs(max(errore_x_pixel_vett)) > abs(min(errore_x_pixel_vett)))
    value_axis_ascissa = abs(max(errore_x_pixel_vett));
else
    value_axis_ascissa = abs(min(errore_x_pixel_vett));
end
ylabel('Errore [pixel]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%Grafico le stesse informazioni utilizzando la funzione stem
h_2 = figure;
figure_ascissa_stem = stem(vettore_tempi, errore_x_pixel_vett);
title('Errore ascissa vettore distanza centroidi');
if(abs(max(errore_x_pixel_vett)) > abs(min(errore_x_pixel_vett)))
    value_axis_ascissa = abs(max(errore_x_pixel_vett));
else
    value_axis_ascissa = abs(min(errore_x_pixel_vett));
end
ylabel('Errore [pixel]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%%                                                            GRAFICI VARI - ERRORE ORDINATA

%Allo stesso modo grafico anche l'errore che si commette sull'ordinata
h_3 = figure;
figure_ordinata = plot(vettore_tempi,errore_y_pixel_vett, 'b');
title('Errore ordinata vettore distanza centroidi');
if(abs(max(errore_y_pixel_vett)) > abs(min(errore_y_pixel_vett)))
    value_axis_ordinata = abs(max(errore_y_pixel_vett));
else
    value_axis_ordinata = abs(min(errore_y_pixel_vett));
end
ylabel('Errore [pixel]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ordinata value_axis_ordinata])

%Grafico la stessa cosa utilizzando la funzione stem
h_4 = figure;
figure_ordinata_stem = stem(vettore_tempi, errore_y_pixel_vett);
title('Errore ordinata vettore distanza centroidi');
if(abs(max(errore_y_pixel_vett)) > abs(min(errore_y_pixel_vett)))
    value_axis_ordinata = abs(max(errore_y_pixel_vett));
else
    value_axis_ordinata = abs(min(errore_y_pixel_vett));
end
ylabel('Errore [pixel]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ordinata value_axis_ordinata])

%%                                                            GRAFICI VARI - DISTANZA APPARENTE

%Grafico l'errore che si commette sull'area della bounding box
h_5 = figure;
distanza_apparente = errore_area_vett/area_di_riferimento;  
figure_distance = plot(vettore_tempi, distanza_apparente, 'b');
title('Errore sulla distanza apparente');
if(abs(max(distanza_apparente)) > abs(min(distanza_apparente)))
    value_axis_distance = abs(max(distanza_apparente));
else
    value_axis_distance = abs(min(distanza_apparente));
end
ylabel('Superfice [pixel^2]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_distance value_axis_distance])

%%                                                GRAFICI VARI - POSIZIONE DRONE E AUTO NELLO SPAZIO

%Grafico all'interno di un plot 3D la posizione dell'auto e del drone
%all'interno dello spazio
h_6 = figure;
figure_sistema = plot3(posizione_auto(:,3), posizione_auto(:,1), posizione_auto(:,2), 'b');
hold on
plot3(posizione_drone(:,3), posizione_drone(:,1), posizione_drone(:,2),'b--');
hold off
legend('Posizione Auto', 'Posizione Drone');
str_1 ='\leftarrow Drone_i_n_t';
str_2 ='\leftarrow Auto_i_n_t';
str_3 ='\rightarrow Drone_e_n_d';
str_4 ='\rightarrow Auto_e_n_d';
text(posizione_drone(1,3), posizione_drone(1,1), posizione_drone(1,2), str_1);
text(posizione_auto(1,3), posizione_auto(1,1), posizione_auto(1,2), str_2);
text(posizione_drone(end,3), posizione_drone(end,1), posizione_drone(end,2), str_3);
text(posizione_auto(end,3), posizione_auto(end,1), posizione_auto(end,2), str_4);
xlabel('z [m]');
zlabel('y [m]');
ylabel('x [m]');
title('Posizione drone e auto durante nello scenario');
grid

%%                                                    GRAFICI VARI - MODULO DISTANZA TRA DRONE E AUTO

%Plotto il modulo del vettore degli errori, ne vedo l'andamento convergere
%a zero. La distanza ad un certo punto aumenta per poi diminuire, per poi
%portarsi ad un valore di regime è dovuto al fatto che all'improvviso la
%macchina fa una curva, come si può vedere dalle immaigni e dal grafico 3D
h_7 = figure;
modulo_vett_errore = zeros(1, numeroFrame);
for i=1:numeroFrame
    modulo_vett_errore(1,i) = sqrt((posizione_drone(i,1) - posizione_auto(i,1))^2 + (posizione_drone(i,2) - posizione_auto(i,2))^2 + ... 
                              + (posizione_drone(i,3) - posizione_auto(i,3))^2);
end
figure_vett_errore = plot(vettore_tempi, modulo_vett_errore, 'b--');
hold on
plot(vettore_tempi, raggio, 'b*', 'LineWidth', 0.5);
hold off
xlabel('Numero Frame');
ylabel('Distanza [m]');
title('Distanza tra drone e auto');
legend('Valore misurato', 'Riferimento', 'Location', 'Best');
axis([0 numeroFrame min(modulo_vett_errore) max(modulo_vett_errore)]);

%%                                                      INDICE PRESTAZIONE ALGORITMO DI CONTROLLO

%Calcolo l'indice di prestazione del mio algoritmo di controllo
offset_x = posizione_drone(1,3) - posizione_auto(1,3);
offset_y = posizione_drone(1,2) - posizione_auto(1,2);
offset_z = posizione_drone(1,1) - posizione_auto(1,1);

%Sottraggo ad ogni passo l'offset calcolato alla posizione del drone, poi
%calcolo il modulo dell'errore tra la posizione del drone e quella
%dell'auto
modulo_errore = zeros(1, numeroFrame); %Memorizzo il modulo dell'errore
for j=2:numeroFrame
    posizione_attuale_x = posizione_drone(j,3) - offset_x;
    posizione_attuale_y = posizione_drone(j,2) - offset_y;
    posizione_attuale_z = posizione_drone(j,1) - offset_z;
    
    modulo_errore(1,j) = sqrt((posizione_attuale_z - posizione_auto(j,1))^2 + (posizione_attuale_y - posizione_auto(j,2))^2 + ... 
                              + (posizione_attuale_x - posizione_auto(j,3))^2);
end

%Grafico l'errore appena ottenuto - funzione stem
h_8 = figure;
vettore_tempi_errore = 1 : 1: numeroFrame;
figure_errore_indice_stem = stem(vettore_tempi_errore, modulo_errore);
title('Errore di traiettoria');
ylabel('Errore [m]');
xlabel('Numero Frame');
axis([1 vettore_tempi_errore(1, end) -1 max(modulo_errore)]);

%Grafico l'errore appena ottenuto - funzione plot
h_9 = figure;
figure_errore_indice_plot = plot(vettore_tempi_errore, modulo_errore);
title('Errore di traiettoria');
ylabel('Errore [m]');
xlabel('Numero Frame');
axis([1 vettore_tempi_errore(1, end) -1 max(modulo_errore)]);

%Indice di prestazione algoritmo: valore quadratico medio dell'errore tra
%la traiettoria dell'auto e quella del drone
indice_prestazione = rms(modulo_errore);            %Questo indice è mentri
disp('Indice Prestazione Algoritmo: ');
disp(indice_prestazione);

%Salvo i risultati ottenuti all'interno di un file .mat
save('indice_prestazione.mat', 'indice_prestazione');

%%                                                  GRAFICI VARI - ERRORE SULL'ANGOLO DI YAW

%Dopo aver simulato il sistema di rilevamento ed inseguimento, realizzo un
%grafico che mi consente di valutare il valore dell'errore lungo l'ascissa nel
%tempo
h_10 = figure;
figure_errore_yaw = plot(vettore_tempi, errore_angolo_yaw_vett, 'b');
title('Errore Yaw');
if(abs(max(errore_angolo_yaw_vett)) > abs(min(errore_angolo_yaw_vett)))
    value_axis_ascissa = abs(max(errore_angolo_yaw_vett));
else
    value_axis_ascissa = abs(min(errore_angolo_yaw_vett));
end
ylabel('Errore [rad]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%Grafico le stesse informazioni utilizzando la funzione stem
h_11 = figure;
figure_errore_yaw_stem = stem(vettore_tempi, errore_angolo_yaw_vett, 'b');
title('Errore Yaw');
if(abs(max(errore_angolo_yaw_vett)) > abs(min(errore_angolo_yaw_vett)))
    value_axis_ascissa = abs(max(errore_angolo_yaw_vett));
else
    value_axis_ascissa = abs(min(errore_angolo_yaw_vett));
end
ylabel('Errpre [rad]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%%                                                  GRAFICI VARI - ERRORE SULL'ANGOLO DI PITCH

%Dopo aver simulato il sistema di rilevamento ed inseguimento, realizzo un
%grafico che mi consente di valutare il valore dell'errore lungo l'ascissa nel
%tempo
h_12 = figure;
figure_errore_pitch = plot(vettore_tempi, errore_angolo_pitch_vett, 'b');
title('Errore Pitch');
if(abs(max(errore_angolo_pitch_vett)) > abs(min(errore_angolo_pitch_vett)))
    value_axis_ascissa = abs(max(errore_angolo_pitch_vett));
else
    value_axis_ascissa = abs(min(errore_angolo_pitch_vett));
end
ylabel('Errore [rad]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%Grafico le stesse informazioni utilizzando la funzione stem
h_13 = figure;
figure_errore_pitch_stem = stem(vettore_tempi, errore_angolo_pitch_vett, 'b');
title('Errore Pitch');
if(abs(max(errore_angolo_yaw)) > abs(min(errore_angolo_pitch_vett)))
    value_axis_ascissa = abs(max(errore_angolo_pitch_vett));
else
    value_axis_ascissa = abs(min(errore_angolo_pitch_vett));
end
ylabel('Errpre [rad]');
xlabel('Numero Frame');
axis([1 vettore_tempi(1, end) -value_axis_ascissa value_axis_ascissa])

%%                                              GRAFICI VARI - POSIZIONE AUTO E POSIZIONE DRONE

h_14 = figure;
figure_posizione_x_drone_auto = plot(vettore_tempi, posizione_auto(:,3), 'b');
hold on
plot(vettore_tempi, posizione_drone(:,3), 'b-.');
hold off
xlabel('Numero Frame');
ylabel('Posizione [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Posizione Auto e Drone - Movimenti Trasversali (X)');

h_15 = figure;
figure_posizione_y_drone_auto = plot(vettore_tempi, posizione_auto(:,2), 'b');
hold on
plot(vettore_tempi, posizione_drone(:,2), 'b-.');
hold off
xlabel('Numero Frame');
ylabel('Posizione [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Posizione Auto e Drone - Quota (Y)');

h_16 = figure;
figure_posizione_z_drone_auto = plot(vettore_tempi, posizione_auto(:,1), 'b');
hold on
plot(vettore_tempi, posizione_drone(:,1), 'b-.');
hold off
xlabel('Numero Frame');
ylabel('Posizione [m]');
legend('Auto', 'Drone', 'Location', 'Best');
title('Posizione Auto e Drone - Movimenti Longitudinali (Z)');

%Parametro per capire quando mi discosto dal mio riferimento
errore_x_drone_auto = median(posizione_drone(:,3) - posizione_auto(:,3));
errore_y_drone_auto = median(posizione_drone(:,2) - posizione_auto(:,2));
errore_z_drone_auto = median(posizione_drone(:,1) - posizione_auto(:,1));

%Mostro a schermo gli indici calcolati
disp('Errore Movimeti Trasversali: ');
disp(errore_x_drone_auto);
disp('Errore Quota: ');
disp(errore_y_drone_auto);
disp('Errore Movimenti Longitudinali: ');
disp(errore_z_drone_auto);


%Salvo gli errori all'intenro di un file mat, questo mi consente di
%visualizzarli senza simulare l'ambiente
save('indice_errore_drone_auto.mat', 'errore_x_drone_auto', 'errore_y_drone_auto', 'errore_z_drone_auto');

%Salvo i plot su file, potrebbe servire per confronti
saveas(figure_ordinata, 'figure_ordinata.tif', 'tif');
saveas(figure_ascissa, 'figure_ascissa.tif', 'tif');
saveas(figure_distance, 'figure_distance.tif', 'tif');
saveas(figure_sistema, 'figure_drone_insegue_auto.tif', 'tif');
saveas(figure_vett_errore, 'figure_vett_errore.tif', 'tif');
saveas(figure_ordinata_stem, 'figure_ordinata_stem.tif', 'tif');
saveas(figure_ascissa_stem, 'figure_ascissa_stem.tif', 'tif');
saveas(figure_errore_indice_stem, 'figure_errore_indice_stem.tif','tif');
saveas(figure_errore_indice_plot, 'figure_errore_indice_plot.tif', 'tif');
saveas(figure_errore_pitch, 'figure_errore_angolo_pitch.tif', 'tif');
saveas(figure_errore_pitch_stem,'figure_errore_angolo_pitch_stem.tif', 'tif');
saveas(figure_errore_yaw, 'figure_errore_angolo_yaw.tif', 'tif');
saveas(figure_errore_yaw_stem,'figure_errore_angolo_yaw_stem.tif', 'tif');
saveas(figure_posizione_x_drone_auto,'figure_posizione_x_drone_auto.tif', 'tif');
saveas(figure_posizione_y_drone_auto,'figure_posizione_y_drone_auto.tif', 'tif');
saveas(figure_posizione_z_drone_auto,'figure_posizione_z_drone_auto.tif', 'tif');
movefile('figure_ordinata.tif', 'Acquisizioni');
movefile('figure_ascissa.tif', 'Acquisizioni');
movefile('figure_distance.tif', 'Acquisizioni');
movefile('figure_drone_insegue_auto.tif', 'Acquisizioni');
movefile('figure_vett_errore.tif', 'Acquisizioni');
movefile('figure_ordinata_stem.tif', 'Acquisizioni');
movefile('figure_ascissa_stem.tif', 'Acquisizioni');
movefile('figure_errore_indice_stem.tif', 'Acquisizioni');
movefile('figure_errore_indice_plot.tif', 'Acquisizioni');
movefile('figure_errore_angolo_pitch.tif', 'Acquisizioni');
movefile('figure_errore_angolo_pitch_stem.tif', 'Acquisizioni');
movefile('figure_errore_angolo_yaw.tif', 'Acquisizioni');
movefile('figure_errore_angolo_yaw_stem.tif', 'Acquisizioni');
movefile('figure_posizione_x_drone_auto.tif', 'Acquisizioni');
movefile('figure_posizione_y_drone_auto.tif', 'Acquisizioni');
movefile('figure_posizione_z_drone_auto.tif', 'Acquisizioni');

%Salvo i file figura
savefig(h_1, 'figure_ascissa.fig');
savefig(h_2, 'figure_ascissa_stem.fig');
savefig(h_3, 'figure_ordinata.fig');
savefig(h_4, 'figure_ordinata_stem.fig');
savefig(h_5, 'figure_distance.fig');
savefig(h_6, 'figure_sistema.fig');
savefig(h_7, 'figure_vett_errore.fig');
savefig(h_8, 'figure_errore_indice_stem.fig');
savefig(h_9, 'figure_errore_indice_plot.fig');
savefig(h_10, 'figure_errore_angolo_yaw.fig');
savefig(h_11, 'figure_errore_angolo_yaw_stem.fig');
savefig(h_12, 'figure_errore_angolo_pitch.fig');
savefig(h_13, 'figure_errore_angolo_pitch_stem.fig');
savefig(h_14, 'figure_posizione_x_drone_auto.fig');
savefig(h_15, 'figure_posizione_y_drone_auto.fig');
savefig(h_16, 'figure_posizione_z_drone_auto.fig');
movefile('figure_ordinata.fig', 'Acquisizioni');
movefile('figure_ascissa.fig', 'Acquisizioni');
movefile('figure_distance.fig', 'Acquisizioni');
movefile('figure_sistema.fig', 'Acquisizioni');
movefile('figure_vett_errore.fig', 'Acquisizioni');
movefile('figure_ordinata_stem.fig', 'Acquisizioni');
movefile('figure_ascissa_stem.fig', 'Acquisizioni');
movefile('figure_errore_indice_stem.fig', 'Acquisizioni');
movefile('figure_errore_indice_plot.fig', 'Acquisizioni');
movefile('figure_errore_angolo_yaw.fig', 'Acquisizioni');
movefile('figure_errore_angolo_yaw_stem.fig', 'Acquisizioni');
movefile('figure_errore_angolo_pitch.fig', 'Acquisizioni');
movefile('figure_errore_angolo_pitch_stem.fig', 'Acquisizioni');
movefile('figure_posizione_x_drone_auto.fig', 'Acquisizioni');
movefile('figure_posizione_y_drone_auto.fig', 'Acquisizioni');
movefile('figure_posizione_z_drone_auto.fig', 'Acquisizioni');

%Chiudo tutte le figure aperte
close all    