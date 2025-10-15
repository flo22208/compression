
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Fonction d'estimation du mouvement par "block-matching"
%--------------------------------------------------------------------------
% MVr = EstimationMouvement(Ic,Ir)
%
% sortie  : MVdr = matrice des vecteurs de deplacements relatifs
% 
% entrees : Ic = image courante
%           Ir = image de reference
%--------------------------------------------------------------------------

function MVr = EstimationMouvement(Ic,Ir)
    

taille_bloc = 16;
nx = size(Ic,1);
ny = size(Ic,2);
MVr = [];
nb_bloc_x = nx/taille_bloc;
nb_bloc_y = ny/taille_bloc;
MVr = zeros(nb_bloc_x,nb_bloc_y,2);
for x =1:nb_bloc_x 
    for y=1:nb_bloc_y
        x_deb = (x-1)*taille_bloc + 1;
        y_deb = (y-1)*taille_bloc + 1;
        x_fin = x_deb + taille_bloc - 1;
        y_fin = y_deb + taille_bloc - 1;

        % Bloc courant
        MB_IC = Ic(x_deb:x_fin, y_deb:y_fin);
        Vp = [x_deb,y_deb];
        Vm = CSAMacroBloc(MB_IC, Vp, Ir);
        MVr(x,y,:) = Vm;
    end
end
end

%--------------------------------------------------------------------------
% Fonction de recherche par 'Cross Search Algorithm' :         
%   - Recherche pour un macro-bloc de l'image courante
%--------------------------------------------------------------------------
% Vm = CSAMacroBloc(MBc, Vp, Iref)
%
% sorties : Vm = vecteur de mouvement 
% 
% entrées : Mbc = macro-bloc dans l'image courante Ic
%           Vp = vecteur de prediction (point de depart du MacroBloc)
%           Iref = image de reference (qui sera conservee dans le GOP)
%--------------------------------------------------------------------------

function Vm = CSAMacroBloc(MB_IC, Vp, IRef)
 
directions = ["haut", "gauche", "centre", "droite","bas"];
Vm=[0,0];
EQM_min = inf;
size_x_Ir = size(IRef,1);
size_y_Ir = size(IRef,2);
MB_IC_V =  MB_IC(:);
mouvement_x = 0;
mouvement_y = 0;
voisin_courant ="haut";
taille_bloc_x = 16;
taille_bloc_y = 16;

    
    while voisin_courant~="centre"
        %%%%% trouver le minimum
        coordx = Vp(:,1) + mouvement_x;
        coordy = Vp(:,2) + mouvement_y;
        
        vecteur_x = coordx : (coordx + taille_bloc_x-1);
        vecteur_y = coordy : (coordy + taille_bloc_y-1);
        EQM_min = inf;
       
        
            
        for voisin =directions
            
        
            eqm_tmp = EQMMacrocBlocVoisin(MB_IC_V,IRef,size_x_Ir,size_y_Ir,vecteur_x,vecteur_y,voisin);
            if eqm_tmp<EQM_min
                EQM_min = eqm_tmp;
                voisin_courant = voisin;
            end
            
        end
        %%%%%%% fin de recherche de direction
        %%%%%%%%%%%%%% choix de la direction par minimum
        if voisin_courant=="haut"
            mouvement_y = mouvement_y - 1;
            %%%% enleve le bas
            directions = ["haut", "gauche", "centre", "droite"];
            
        elseif voisin_courant=="gauche"
            mouvement_x = mouvement_x - 1;
            directions = ["haut", "gauche", "centre","bas"];   
              
        elseif voisin_courant == "droite"
            mouvement_x= mouvement_x + 1;
            directions = ["haut", "centre", "droite","bas"];
        
        elseif voisin_courant=="bas"
            mouvement_y= mouvement_y + 1;
            directions = [ "gauche", "centre", "droite","bas"];
    end
    
    Vm = [mouvement_x,mouvement_y];
    end
end

%--------------------------------------------------------------------------
% Fonction de calcul de l'EQM avec differents voisins 
% dans l'image de reference
%--------------------------------------------------------------------------
% EQM = EQMMacrocBlocVoisin(MB_IC_V,IRef,size_x_Ref,size_y_Ref,coordx,coordy,voisin)
%
% sortie  : EQM = erreur quadratique moyenne entre macro-blocs
% 
% entrées : MB_IC_V = macro-bloc dans l'image courante (vectorise)
%           Ir = Image de reference
%           size_x_Ir = nombre de lignes de Ir (pour effets de bords)
%           size_y_Ir = nombre de colonnes de Ir (pour effets de bords)
%           coordx = les 16 coordonnees du bloc suivant x
%           coordy = les 16 coordonnees du bloc suivant y
%           voisin = choix du voisin pour decaler le macro-bloc dans Ir
%                    ('haut', 'gauche', 'centre', 'droite', bas', ...)
%--------------------------------------------------------------------------

function EQM = EQMMacrocBlocVoisin(MB_IC_V,Ir,size_x_Ir,size_y_Ir,coordx,coordy,voisin)

dx = 0;
dy = 0;


if voisin=="haut"
    dy =-1;

elseif voisin=="gauche"
    dx=-1;

elseif voisin=="centre"
    dx=0;
    dy=0;
      
elseif voisin == "droite"
    dx=1;
elseif voisin=="bas"
    dy=1;

else 
    "ahhahahhahahahhah"

end

x = coordx+dx;
y = coordy+dy;

if ((min(x)<1) || (max(x)>size_x_Ir) || (min(y)<1) || (max(y)>size_y_Ir))

   EQM = inf;
else 
    Ir_non_vect = Ir(x,y);
    Vect_I = Ir_non_vect(:);
    
    EQM = sum((MB_IC_V-Vect_I).^2);
end

end
