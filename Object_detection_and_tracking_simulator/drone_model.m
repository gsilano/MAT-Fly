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