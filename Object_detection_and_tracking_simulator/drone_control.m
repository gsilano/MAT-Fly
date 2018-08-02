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