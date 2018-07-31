clear all
close all
clc

%%                                                     PARAMETRI INIZIALE PER LA SIMULAZIONE DEL SISTEMA

%Indice dei frame che scatterò per osservare in real time l'evoluzione del
%sistema
k = 1;

%Carico il mat file contenente la dinamica del veicolo 
load('esp_on.mat');

%Nome detector
nomeDetector = 'carDetector_virtual_world_Haar.xml';

%Posizione iniziale dell'auto [m]
y_iniziale = 4;    
x_iniziale = 15;
z_iniziale = 0;

%Aggiorno la posizione iniziale del drone con quella imposta dai valori
%iniziali
y_pross = y_iniziale;
x_pross = x_iniziale;
z_pross = z_iniziale;

%Orientamento iniziale del drone, che tiene conto della posizione iniziale nel sistema di riferimento virtuale [xyz]
%All'interno della tesi è riportato un grafico che spiega nel dettaglio la cosa
yaw_iniziale = 0;
pitch_iniziale = 0;
roll_iniziale = 0;

%Faccio corrispondere i valori iniziali dell'angolo ai valori che saranno
%utilizzati al primo passo della simulazione
yaw_reale = yaw_iniziale;
pitch_reale = pitch_iniziale; 
roll_reale = roll_iniziale;

%Scambio valori degli angoli per cambiamento sistema di riferimento, da
%[xyz] al sistema di riferimento utilizzato nel mondo virtuale
roll_virtuale = pitch_reale;
pitch_virtuale = yaw_reale;
yaw_virtuale = roll_reale;

%%                                                                  PARAMETRI SIMULAZIONE

%Parametri tempo simulazione
tempo_simulazione = 33;             %Tempo di simulazione dello scenario [secondi]
passo = 0.05;                       %Passo di campionamento [secondi]
start_time = 0;                     %Istante di tempo avvio simulazione [secondi], primo passo
stop_time = start_time + passo;     %Istante di tempo fine simulazione [secondi], primo passo

%%                                               PARAMETRI SISTEMA DI CONTROLLO - REFERENCE GENERATOR

%Area minima e massima misurata sempre attraverso file Matlab estern
area_di_riferimento = 30000;            %[px^2]    %Cacolata sperimentalmente in un altro file Matlab, vedi Detector Virtual World cartella 7
raggio = 15;                            %Distanza utilizzata per il calcolo dell'area di riferimento, [metri]

%Parametri risoluzione immagine
w_im = 600; %Pixel larghezza immagine
h_im = 800; %Pixel altezza immagine

% %Valori iniziali per l'angolo di yaw e pitch al passo k-1
yaw_regolatore_prec_1 = yaw_iniziale;                   %Ad un passo precedente
pitch_regolatore_prec_1 = pitch_iniziale;               %Ad un passo precedente
roll_regolatore_prec_1 = roll_iniziale;

%Valori iniziali della posizione al passo k-1
z_pross_prec_1 = y_iniziale;                 %Ad un passo precedente
x_pross_prec_1 = x_iniziale;                 %Ad un passo precedente
y_pross_prec_1 = -z_iniziale;                 %Ad un passo precedente

%Valori iniziali dell'errore al passo k-1
errore_pitch_prec_1 = pitch_iniziale;
errore_yaw_prec_1 = yaw_iniziale;

%Valori iniziali dell'errore al passo k-1
errore_angolo_pitch_prec_1 = 0;
errore_angolo_yaw_prec_1 = 0;
errore_distance_prec_1 = 0;

%Guadagni proporzionali dei regolatori su yaw e pitch
k_pitch_p = -0;         %E' rimasto il meno perché questo guadagno deve crescere/decrescere per negativi
k_yaw_p = -0;           %E' rimasto il meno perché questo guadagno deve crescere/decrescere per negativi

%Guadagni integrali dei regolatori su yaw e pitch
k_pitch_i = -1e-3;
k_yaw_i = -1e-3;

%Guadagni del sistema di controllo
k_area_p = 1e-6;
k_z_p = -15;           %Guadagno di segno negativo perché l'angolo cresce dall'alto verso il basso (guarda schema sul quaderno)
k_y_p = 1e-2;              %Guadagno di segno positivo perché l'angolo cresce dal basso verso l'alto (guarda schema sul quaderno)
       
%Guadagni azione integrale
k_area_i = -6e-6;
k_z_i = -57.5;
k_y_i = 1e-2;

%Guadagni azione derivativa
k_z_d = +3.75;

%Inizializzo le azioni derivative
azione_derivativa_z = 0;

%Inizializzo le azioni integrali
azione_integrale_pitch = 0;
azione_integrale_yaw = 0;
azione_integrale_x = 0;
azione_integrale_z = 0;
azione_integrale_y = 0;

%Soglia angoli per azione di controllo. Maggiori dettagli sono presenti
%nella tesi. Ipotesi che ho fatto è quella di vedere la macchina al primo passo
angolo_yaw_riferimento = yaw_iniziale;      
angolo_pitch_riferimento =  pitch_iniziale;

%%                                                    CONDIZIONI INIZIALI INTEGRATORI MODELLO DRONE

%Errori di posizione istante precendete
chi_6_prec_1 = 0;
chi_5_prec_1 = 0;
    
%Accelerazioni angolari allo stato precedente
phi_dot_prec_1 = 0;
theta_dot_prec_1 = 0;
psi_dot_prec_1 = 0;
    
%Velocità allo stato precedente
x_dot_prec_1 = 0;
y_dot_prec_1 = 0;
z_dot_prec_1 = 0;

%%                                                              CONTROLLO DI POSIZIONE QUADRIROTORE

%Parametri per il controllo in traiettoria
lambda_5 = 0.025;
lambda_6 = 0.025;

C_9 = 2;
C_10 = 0.5;
C_11 = 2; 
C_12 = 0.5;


%%                                                      GUADAGNI DEL SISTEMA DI CONTROLLO QUADRIROTORE

%Guadagno controllore PD sulla Phi (roll)
kpp = 0.8e1;
kdp = 0.4e1;

%Guadagno controllore PD su Theta (Pitch)
kpt = 1.2e1;
kdt = 0.4e1;

%Guadagno controllore PD su Psi (Yaw)
kpps = 1e1;
kdps = 0.4e1;

%Guadagno controllore sulla Z
kpz = 100e1;
kdz = 20e1;

%%                                                          PARAMETRI DEL QUADRI-ROTORE

Ix = 7.5*10^(-3);  % Quadrotor moment of inertia around X axis
Iy = 7.5*10^(-3);  % Quadrotor moment of inertia around Y axis
Iz = 1.3*10^(-2);  % Quadrotor moment of inertia around Z axis
Jr = 6.5*10^(-5);  % Total rotational moment of inertia around the propeller axis
b = 3.13*10^(-5);  % Thrust factor
d = 7.5*10^(-7);  % Drag factor
l = 0.23;  % Distance to the center of the Quadrotor
m = 0.65;  % Mass of the Quadrotor in Kg
g = 9.81;   % Gravitational acceleration

%%                                                     ACQUISISCO I FRAME NELLE DIVERSE POSIZIONI

%In questa prova non scorro il vettore della dinamica dell'auto (lo scorrimento 
%avviene all'interno dell'ambiente Simulink aumentando il tempo di simulazione
%fissato al momento a 0.04 secondi, ipotizzo che tutto sia fermo in modo da 
%verificare l'effettivo funzionamento del controllo di orientamento
 
%Il numero di frame scandisce la durata della simulazione
numeroFrame = floor(tempo_simulazione - start_time)/passo;   %Arrotonda all'intero immediatamente inferiore

%Vettori di appoggio utilizzati per tenere traccia degli errori lungo
%l'ascissa e lungo l'ordinata. Ricordo che l'obiettivo del controllo è
%quello di far in modo che i due centroidi coincidano.
errore_x_pixel_vett = zeros(1, numeroFrame);
errore_y_pixel_vett = zeros(1, numeroFrame);
errore_area_vett = zeros(1, numeroFrame);
errore_angolo_yaw_vett = zeros(1, numeroFrame);
errore_angolo_pitch_vett = zeros(1, numeroFrame);

%Vettori con i quali tengo traccia delle variabili  provenienti dal modello
%del drone
chi_6_prec_1_vett = zeros(1, numeroFrame);
chi_5_prec_1_vett = zeros(1, numeroFrame);
    
psi_dot_prec_1_vett = zeros(1, numeroFrame);
phi_dot_prec_1_vett = zeros(1, numeroFrame);
theta_dot_prec_1_vett = zeros(1, numeroFrame);
    
x_dot_prec_1_vett = zeros(1, numeroFrame);
y_dot_prec_1_vett = zeros(1, numeroFrame);
z_dot_prec_1_vett = zeros(1, numeroFrame);

%Tengo traccia durante la simulazione della posa generata dal reference
%generator e di quella assunta dal drone
observer_position_reference_generator_vett = zeros(3, numeroFrame);
observer_orientation_reference_generator_vett = zeros(3, numeroFrame);

%Salvo all'interno di due vettori la posizione dell'auto durante la
%simulazione e quella del donre, in modo da visualizzare gli andamenti e
%calcolare l'errore
posizione_auto = zeros(numeroFrame, 3);   %Tante righe quanti sono i frame raccolti e 3 colonne per memorizzare le posizioni [z, y, x]
posizione_drone = zeros(numeroFrame, 3);
orientamento_drone = zeros(numeroFrame, 3);

%Variabile necessaria per effettuare detection solo al primo passo
primo_ciclo=1;

%Il loop di controllo continua fin quando non scattati il numero di frame
%decisi
for l=1:numeroFrame
%%                                                      SIMULO IL SISTEMA NEL VIRTUAL WORLD    
    
    %Aggiorno la nuova posizione dell'osservatore
    observer_position = [z_pross y_pross x_pross];
    
    %Orientamento del drone: yaw, pitch, roll in angoli reali. Mi consente
    %di vedere in real-time come variano gli angoli
    observer_orientation = [yaw_virtuale pitch_virtuale roll_virtuale];
    
    %Salvo la posizione del drone
    posizione_drone(l,:) = [z_pross y_pross x_pross];
    orientamento_drone(l,:) = observer_orientation;
        
    %Calcolo le matrici di rotazione
    R_1 = [   cos(yaw_virtuale)    sin(yaw_virtuale)    0; 
             -sin(yaw_virtuale)    cos(yaw_virtuale)    0; 
                       0                   0            1];
          
    R_2 = [   cos(pitch_virtuale)      0   -sin(pitch_virtuale); 
                       0               1             0; 
              sin(pitch_virtuale)      0   cos(pitch_virtuale)];
        
    R_3 = [       1               0                     0; 
                  0       cos(roll_virtuale)   sin(roll_virtuale); 
                  0       -sin(roll_virtuale)  cos(roll_virtuale)];
                
    rotation_matrix = R_1 * R_2 * R_3;
       
    %Lancio il modello Simulink il cui tempo di simulazione è 0.04 secondi,
    %tempo imposto dall'esempio di Matlab
    mdl = 'virtual_world';
    load_system(mdl);
    sim(mdl);
    
    %Salvo la posizione dell'auto
    posizione_auto(l,:) = car_position;
    
%%                                                  ACQUISIZIONE DEL FRAME E RILEVAMENTO OGGETTO

    %Attribuisco i giusti nomi ai frame acquisiti
    nomeFrame = strcat('screenCaptured_', num2str(k), '.tif');
    
    %Creo dalla matrice uno screen da poi inviare al detector per il
    %riconoscimento dell'auto
    immagine_virtual_world = image(:,:,:,end);
    imwrite(immagine_virtual_world, nomeFrame);
    
    %Sposto le immagini nella relativa cartella, se non è presente la creo
    cartellaImmagini = 'Acquisizioni';
    if ~(exist(cartellaImmagini, 'dir'))
          mkdir(cartellaImmagini);
    end
    movefile(nomeFrame, cartellaImmagini);
    
    %Elabora l'immagine appena acquisita
    %Utilizzo il file xml prodotto dal classifier  per rilevare la macchina all'interno dell'immagine
    detector = vision.CascadeObjectDetector(nomeDetector);
    
    %Leggo l'immagine da file
    posizioneImg = strcat(cartellaImmagini, '\', nomeFrame);
    img = imread(posizioneImg);
    
    %Rilevo la macchina all'interno dell'immagine, operazione al primo
    %passo poi sostituita dall'algoritmo di tracking
    if(primo_ciclo)
        bbox = step(detector,img);
    end
        
    %Se all'interno dell'immagine non è stato rilevato l'oggetto il drone
    %resta fermo alla posizione precedente
    if(size(bbox,1) > 0)
        
        if(primo_ciclo)
            %Inserisco la maschera dei contorni e ritorno l'immagine
            detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'carDetected');
            
            %Attribuisco i giusti nomi ai frame elaborati
            nomeFrameDetected=strcat('carDetected_', num2str(k), '.tif');
            
            %Salvo su file l'immagine con le diverse bounding box
            imwrite(detectedImg, nomeFrameDetected);
            movefile(nomeFrameDetected, cartellaImmagini);
            
            %Inizializzo le variabili per la ricerca della massima bounding box
            larghezza_max = 0;
            altezza_max = 0;
            
            %Scelgo la massima bounding box che contorna la macchina. Scorro tutte le
            %righe della matrice bbox_ per il calcolo del max
            for i = 1 : size(bbox,1)
                
                %If necessario per la ricerca del massimo
                if(larghezza_max < bbox(i,3) && altezza_max < bbox(i,4))
                    
                    x_max = bbox(i,1);
                    y_max = bbox(i,2);
                    larghezza_max = bbox(i,3);
                    altezza_max = bbox(i,4);
                    
                end
                
            end
    
            %Memorizzo le informazioni in merito alla bounding box massima
            bbox_max = [x_max y_max larghezza_max altezza_max];
            
            %Applico l'algoritmo di tracking, il CAM Shift
            [hueChannel,~,~] = rgb2hsv(img);
            tracker = vision.HistogramBasedTracker;
            initializeObject(tracker, hueChannel, [x_max+larghezza_max y_max+altezza_max/2 54 38]);
            
        else
        
            [hueChannel,~,~] = rgb2hsv(img);
            bbox_max = step(tracker, hueChannel);
        
        end
    
        %Inserisco la maschera dei contorni e ritorno l'immagine con bounding box
        %maassima
        detectedImg_max = insertObjectAnnotation(img, 'rectangle',bbox_max, 'carDetected');
    
        %Attribuisco i giusti nomi ai frame elaborati
        nomeFrameDetected_max=strcat('carDetectedMax_', num2str(k), '.tif');
    
        %Salvo su file l'immagine con la bounding box massima
        imwrite(detectedImg_max, nomeFrameDetected_max);
        movefile(nomeFrameDetected_max, cartellaImmagini);
        
        %Attribuisco i giusti nomi ai frame elaborati
        nomeFrameDetected_hueChannel=strcat('hueChannel_', num2str(k), '.tif');
    
        %Salvo su file l'immagine convertita dallo spazio colori RGB a
        %quello HSV
        imwrite(hueChannel, nomeFrameDetected_hueChannel);
        movefile(nomeFrameDetected_hueChannel, cartellaImmagini);
    
%%                                              ESTRAZIONI INFORMAZIONI PER L'ALGORITMO DI CONTROLLO

        %Utilizzando la funzione bbox2point ricavo le coordinate della bounding
        %box, ricordo che sto utilizzando la bounding box max
        matrice_vertici = bbox2points(bbox_max);

        %Distanza dell'oggetto dal centroide partendo dallo spigolo superiore laterale sinistro
        x_bb = bbox_max(1,1);           %Distanza asse orizzontale, bbox_max = [x, y, larghezza, altezza]
        y_bb = bbox_max(1,2);         %Distanza asse verticale, bbox_max = [x, y, larghezza, altezza]

        %Larghezza ed altezza del target, quelle della bounding box
        w_bb = bbox_max(1,3);  %bbox_max = [x, y, larghezza, altezza]
        h_bb = bbox_max(1,4);
    
        %Coordinate x e y centroide bounding box
        x_centroid_bounding_box = x_bb + (w_bb/2);
        y_centroid_bounding_box = y_bb + (h_bb/2);

        %Coordinate x e y centroide immagine
        x_centroid_img = w_im/2;
        y_centroid_img = h_im/2;
       
        %Inserisco sull'immagine le coordinate dei due centroidi
        %Centroide dell'immagine
        figure_1 = figure();
        movegui(figure_1, [50 50]);
        imshow(detectedImg_max);
        hold on
        set(figure_1, 'Position', [50 50 576 631]);
        plot(x_centroid_img, y_centroid_img, 'yx', 'MarkerSize', 10, 'LineWidth', 4);
    
        %Centroide della bounding box
        plot(x_centroid_bounding_box, y_centroid_bounding_box, 'gx', 'MarkerSize', 10, 'LineWidth', 4);
    
        %Rappresento il vettore tra i due centroidi
        %Rappresento vettore che collega il centroide della bounding box con quello
        %dell'immagine
        lunghezza_bounding_box = length(x_bb + w_bb/2 : 1 : w_im/2);

        %Ho necessità di realizzare questo if-else perché non so dove sarà il
        %centroide dell'immagine rispetto a quello della bounding box
        if(lunghezza_bounding_box == 0)
            vector_bounding_box = x_bb + w_bb/2 : -1 : w_im/2;
        else
            vector_bounding_box = x_bb + w_bb/2 : 1 : w_im/2; 
        end

        %Retta che collega i due punti
        f_vector_bounding_box = (((vector_bounding_box - (x_bb + w_bb/2)) / (w_im/2 - (x_bb + w_bb/2))) * (h_im/2 - (y_bb + (h_bb/2)))) + ...
                            y_bb + h_bb/2;

        %plot(vector_bounding_box, f_vector_bounding_box, 'b--', 'LineWidth', 2);
        differenzaPunti = [x_centroid_bounding_box-x_centroid_img, y_centroid_bounding_box-y_centroid_img];
        quiver(x_centroid_img, y_centroid_img, differenzaPunti(1,1), differenzaPunti(1,2), 0, 'LineWidth', 1);
        hold off
        legend('Centroide IMG', 'Centroide BB', 'Vettore distanza');
        axis([0 600 0 800]);
    
        cartellaFigure = 'FileFigure';
        if ~(exist(cartellaFigure, 'dir'))
             mkdir(cartellaFigure);
        end

        %Salvo immagine su file .fig e .tif
        nomeFrameVector = strcat('vettoreCentroidi_', num2str(k), '.tif');
        nomeFiguraVector = strcat('vettoreCentroidi_', num2str(k), '.fig');
        F = getframe;
        [X,map] = frame2im(F);
        imwrite([X,map], nomeFrameVector);
        savefig(figure_1, nomeFiguraVector);
        close all
        movefile(nomeFrameVector, cartellaImmagini);
        movefile(nomeFiguraVector, cartellaFigure);
        
%%                                                  CONTROLLO DI ORIENTAMENTO - REFERENCE GENERATOR

        %Calcolo l'errore
        errore_pitch = y_centroid_img - y_centroid_bounding_box;
        errore_yaw = x_centroid_img - x_centroid_bounding_box;
    
        %Colleziono i valori assunti dall'errore per poi graficarli al termine
        %della simulazione
        errore_x_pixel_vett(1,l) = errore_yaw;
        errore_y_pixel_vett(1,l) = errore_pitch;
    
        %Controllo di orientazione
        azione_integrale_pitch = azione_integrale_pitch + passo*k_pitch_i*errore_pitch;
        azione_proporzionale_pitch = k_pitch_p*errore_pitch;  
        delta_pitch_regolatore =  azione_integrale_pitch + azione_proporzionale_pitch;
        pitch_regolatore = delta_pitch_regolatore + pitch_iniziale;
        
        azione_integrale_yaw = azione_integrale_yaw + passo*k_yaw_i*errore_yaw;
        azione_proporzionale_yaw = k_yaw_p*errore_yaw;
        delta_yaw_regolatore = azione_integrale_yaw + azione_proporzionale_yaw;
        yaw_regolatore = delta_yaw_regolatore + yaw_iniziale;
        
        %Aggiorno il valore dell'errore al passo precedente
        errore_pitch_prec_1  = errore_pitch;
        errore_yaw_prec_1 = errore_yaw;
  
    
%%                                                    CONTROLLO DI POSIZIONE - REFERENCE GENERATOR    
    
        %Area bounding box
        area_bounding_box = w_bb * h_bb; 
  
        %Calcolo dell'errore
        errore_area = area_di_riferimento - area_bounding_box;
        errore_angolo_yaw = angolo_yaw_riferimento - yaw_regolatore;
        errore_angolo_pitch = angolo_pitch_riferimento - pitch_regolatore;
        
        %Salvo l'errore per poi plottarlo
        errore_area_vett(1,l) = errore_area;
        errore_angolo_yaw_vett(1,l) = errore_angolo_yaw;
        errore_angolo_pitch_vett(1,l) = errore_angolo_pitch;
    
        %Stuttura sistema di controllo
        %controllore = proporzionale + intergrativo
        azione_integrale_x = azione_integrale_x + passo*k_area_i*errore_area;
        azione_proporzionale_x = k_area_p*errore_area;
        delta_x_pross =  azione_proporzionale_x + azione_integrale_x;         
        x_pross = delta_x_pross + x_iniziale;
        
        azione_integrale_z = azione_integrale_z + passo*k_z_i*errore_angolo_yaw;
        azione_derivativa_z = k_z_d*((errore_angolo_yaw - errore_angolo_yaw_prec_1)/passo);
        azione_proporzionale_z = k_z_p*errore_angolo_yaw;
        delta_z_pross = azione_proporzionale_z + azione_integrale_z + azione_derivativa_z;
        z_pross = delta_z_pross + z_iniziale;
        
        azione_integrale_y =  azione_integrale_y + passo*k_y_i*errore_angolo_pitch;
        azione_proporzionale_y = k_y_p*errore_angolo_pitch;
        delta_y_pross =  azione_proporzionale_y + azione_integrale_y; 
        y_pross = delta_y_pross + y_iniziale;
        
        %Aggiorno le variabili dell'errore al passo precedente
        errore_angolo_yaw_prec_1 = errore_angolo_yaw;
        errore_angolo_pitch_prec_1 =  errore_angolo_pitch;
        errore_distance_prec_1 = errore_area;
         
    end
    
    %%                                                            MODELLO DEL DRONE
    
    %Utilizzo i riferimenti estratti dai singoli ai frame come riferimenti
    %per la traiettoria da inviare al modello del drone
    
    inizio_simulazione = 0;     %[s]
    fine_simulazione = 10;       %[s]
    
    %Posizione di riferimento  fornita dal reference generator
    observer_position_reference_generator = [z_pross y_pross x_pross];
    observer_position_reference_generator_vett (:,l) = observer_position_reference_generator;
    
    observer_orientation_reference_generator = [yaw_regolatore pitch_regolatore 0];
    observer_orientation_reference_generator_vett(:,l) = observer_orientation_reference_generator;
    
    %Cambio coordinate del sistema per porle in ingresso al modello del drone
    x_pross_drone = x_pross;
    y_pross_drone = -z_pross;
    z_pross_drone = y_pross;
    
    %Lancio la simulazione
    mdl_drone = 'PDQuadrotor_con_controllo_di_posizione';
    load_system(mdl_drone);
    sim(mdl_drone);
    
    %Salvo le variabili di stato degli integratori, in questo modo il
    %modello tiene conto del fatto che l'UAV al passo precedente non era
    %fermo ma era già in volo ed è solo cambiato il punto di riferimento
    
    %Errori di posizione istante precendete
    chi_6_prec_1 = chi_6(end);
    chi_5_prec_1 = chi_5(end);
    
    %Accelerazioni angolari allo stato precedente
    phi_dot_prec_1 = phi_dot(end);
    theta_dot_prec_1 = theta_dot(end);
    psi_dot_prec_1 = psi_dot(end);
    
    %Velocità allo stato precedente
    x_dot_prec_1 = x_dot(end);
    y_dot_prec_1 = y_dot(end);
    z_dot_prec_1 = z_dot(end);
    
    %Aggiorno il valore dell'angolo al passo precedente con il nuovo valore
    pitch_regolatore_prec_1 = theta_mis(end);
    yaw_regolatore_prec_1 = psi_mis(end);
    roll_regolatore_prec_1 = phi_mis(end);
    
    %Aggiorno il valore della posizione al passo precedente con il nuovo
    %valore
    z_pross_prec_1 = z_mis(end);
    x_pross_prec_1 = x_mis(end);
    y_pross_prec_1 = y_mis(end);
    
    %Aggiorno la posa del velivolo che sarà utilizzata per il rendering
    %nell'ambiente di realtà virtuale
    z_pross = -y_mis(end);
    y_pross = z_mis(end);
    x_pross = x_mis(end);
    
    %Orientamento assunto dal drone che poi invio all'ambiente virtuale.
    %Variabili create solo per tenere traccia dell'evoluzione
    roll_virtuale = phi_mis(end);
    yaw_virtuale = psi_mis(end);
    pitch_virtuale = theta_mis(end); 
    
    %Tengo traccia dell'evoluzione delle variabili nel tempo, ciò mi
    %consente di indiviudare possibili errori durante l'evoluzione del
    %sistema
    chi_6_prec_1_vett(1,l) = chi_6_prec_1;
    chi_5_prec_1_vett(1,l) = chi_5_prec_1;
    
    psi_dot_prec_1_vett(1,l) = psi_dot_prec_1;
    phi_dot_prec_1_vett(1,l) = phi_dot_prec_1;
    theta_dot_prec_1_vett(1,l) = theta_dot_prec_1;
    
    x_dot_prec_1_vett(1,l) = x_dot_prec_1;
    y_dot_prec_1_vett(1,l) = y_dot_prec_1;
    z_dot_prec_1_vett(1,l) = z_dot_prec_1;
    
    
    %%                                                  PARAMETRI PER LA PROSSIMA SIMULAZIONE
    
    %Incremento l'indice delle foto
    k = k + 1;
    
    %Aggiorno i tempi della simulazione 
    tempo_simulazione_drone = fine_simulazione;
    start_time =  stop_time;
    stop_time = stop_time + passo; %+ tempo_simulazione_drone;
    
    primo_ciclo = 0;
   
end


%%                                                          SALVO I DATI DELLA SIMULAZIONE


%Sposto le immagini nella relativa cartella, se non è presente la creo
cartellaFileMat = 'FileMat';
if ~(exist(cartellaFileMat, 'dir'))
    mkdir(cartellaFileMat);
end

%Nomi file .mat
nomeMatFileInformazioniVarie = 'informazioniVarie.mat';
nomeMatFileErroreXPixel = 'erroreXPixel.mat';
nomeMatFileErroreYPixel = 'erroreYPixel.mat';
nomeMatFileErroreAreaPixel = 'erroreAreaPixel.mat';
nomeMatFileErroreAngolaYawReferenceGenerator = 'erroreYawReferenceGenerator.mat';
nomeMatFileErroreAngoloPitchReferenceGenerator = 'errorePitchReferenceGenerator.mat';
nomeMatFileChi_6 = 'chi_6.mat';
nomeMatFileChi_5 = 'chi_5.mat';
nomeMatFilePsi_dot = 'psi_dot.mat';
nomeMatFilePhi_dot = 'phi_dot.mat';
nomeMatFileTheta_dot = 'theta_dot.mat';
nomeMatFileX_dot = 'x_dot.mat';
nomeMatFileY_dot = 'y_dot.mat';
nomeMatFileZ_dot = 'z_dot.mat';
nomeMatFileObserverPositionReferenceGenerator = 'observerPositionReferenceGenerator.mat';
nomeMatFileObserverOrientationReferenceGenerator = 'observerOrientationReferenceGenerator.mat';
nomeMatFilePosizioneAuto = 'posizioneAuto.mat';
nomeMatFilePosizioneDrone = 'posizioneDrone.mat';
nomeMatFileOrientamentoDrone = 'orientamentoDrone.mat';

%Salvo i file .mat
save(nomeMatFileInformazioniVarie, 'tempo_simulazione', 'passo', 'area_di_riferimento', 'raggio', 'g', 'm', 'l', 'd', 'b', 'Jr', 'Iz', 'Iy', 'Ix', ...
    'kpz', 'kdz', 'kpps', 'kdps', 'kpt', 'kdt', 'kpp', 'kdp', 'C_12', 'C_11', 'C_10', 'C_9', 'lambda_6', 'lambda_5', 'k_z_d', 'k_y_i', 'k_z_i', ...
    'k_area_i', 'k_y_p', 'k_z_p', 'k_area_p', 'k_yaw_i', 'k_pitch_i', 'k_yaw_p', 'k_pitch_p', 'w_im', 'h_im');
save(nomeMatFileErroreXPixel, 'errore_x_pixel_vett');
save(nomeMatFileErroreYPixel, 'errore_y_pixel_vett');
save(nomeMatFileErroreAreaPixel , 'errore_area_vett');
save(nomeMatFileErroreAngolaYawReferenceGenerator , 'errore_angolo_yaw_vett');
save(nomeMatFileErroreAngoloPitchReferenceGenerator , 'errore_angolo_pitch_vett');
save(nomeMatFileChi_6 , 'chi_6_prec_1_vett');
save(nomeMatFileChi_5 , 'chi_5_prec_1_vett');
save(nomeMatFilePsi_dot , 'psi_dot_prec_1_vett');
save(nomeMatFilePhi_dot , 'phi_dot_prec_1_vett');
save(nomeMatFileTheta_dot , 'theta_dot_prec_1_vett');
save(nomeMatFileX_dot , 'x_dot_prec_1_vett');
save(nomeMatFileY_dot , 'y_dot_prec_1_vett');
save(nomeMatFileZ_dot , 'z_dot_prec_1_vett');
save(nomeMatFileObserverPositionReferenceGenerator , 'observer_position_reference_generator_vett');
save(nomeMatFileObserverOrientationReferenceGenerator , 'observer_orientation_reference_generator_vett');
save(nomeMatFilePosizioneDrone , 'posizione_auto'); 
save(nomeMatFileOrientamentoDrone , 'posizione_drone');

%Li sposto nella specifica cartella
movefile(nomeMatFileInformazioniVarie, cartellaFileMat);
movefile(nomeMatFileErroreXPixel, cartellaFileMat);
movefile(nomeMatFileErroreYPixel, cartellaFileMat);
movefile(nomeMatFileErroreAreaPixel , cartellaFileMat);
movefile(nomeMatFileErroreAngolaYawReferenceGenerator , cartellaFileMat);
movefile(nomeMatFileErroreAngoloPitchReferenceGenerator , cartellaFileMat);
movefile(nomeMatFileChi_6 , cartellaFileMat);
movefile(nomeMatFileChi_5 , cartellaFileMat);
movefile(nomeMatFilePsi_dot , cartellaFileMat);
movefile(nomeMatFilePhi_dot , cartellaFileMat);
movefile(nomeMatFileTheta_dot , cartellaFileMat);
movefile(nomeMatFileX_dot , cartellaFileMat);
movefile(nomeMatFileY_dot , cartellaFileMat);
movefile(nomeMatFileZ_dot , cartellaFileMat);
movefile(nomeMatFileObserverPositionReferenceGenerator , cartellaFileMat);
movefile(nomeMatFileObserverOrientationReferenceGenerator , cartellaFileMat);
movefile(nomeMatFilePosizioneDrone , cartellaFileMat); 
movefile(nomeMatFileOrientamentoDrone , cartellaFileMat);


