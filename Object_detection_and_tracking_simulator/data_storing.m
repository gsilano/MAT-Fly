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


