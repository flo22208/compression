
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Prediction de l'image courante avec l'image de reference et le mouvement
%--------------------------------------------------------------------------
% Ip = PredictionImage(Ir,MVr)
%
% sortie  : Ip = image predictive
%           
% entrees : Ir = image de reference
%           MVr = matrice des vecteurs de déplacements relatifs
%--------------------------------------------------------------------------

function Ip = PredictionImage(Ir,MVr)

taille_bloc = 16;
nx = size(Ir,1);
ny = size(Ir,2);
nb_bloc_x = nx/taille_bloc;
nb_bloc_y = ny/taille_bloc;
Ip = Ir;
for x =1:nb_bloc_x 
    for y=1:nb_bloc_y
        x_deb = (x-1)*taille_bloc + 1;
        y_deb = (y-1)*taille_bloc + 1;
        x_fin = x_deb + taille_bloc - 1;
        y_fin = y_deb + taille_bloc - 1;
        vect_x = x_deb:x_fin;
        vect_y = y_deb:y_fin;


        Vd = MVr(x,y,:);
        Ip(vect_x,vect_y) = Ir(vect_x + Vd(1), vect_y +Vd(2));

    end
end
end
    


