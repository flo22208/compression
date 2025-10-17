
% TP CoCodages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Fonction de compression JPEG d'une image
%--------------------------------------------------------------------------
% [I_Codee,Poids,Compression,nb_coeffs_AC,nb_coeffs_DC] = 
%                        CompressionJPEG(I_Origine,canal,methode,F_Qualite)
%
% sorties : I_Codee = image de DCT quantifiee
%           Poids = poids de l'image d'origine en ko pour les differentes
%                   etapes de la compression
%           Compression = taux de compression final
%           nb_coeffs_AC = nombre de coefficients AC dans l'image compressee
%           nb_coeffs_DC = nombre de coefficients DC dans l'image compressee
% 
% entrees : I_Origine = image originale (ou residuelle)
%           canal = canal pour le choix de la table de quantification :
%                   'Luminance', 'Chrominance' ou 'Residu'
%           methode = methode de calcul de la DCT : 'Matlab' ou 'Rapide'
%           F_Qualite = facteur de qualite pour la compression
%--------------------------------------------------------------------------
% Fonctions a coder/utiliser : DCT2DParBlocs.m
%                              QuantificationDCT.m
%                              CodageEntropique.m
%                              CoefficientsACDC.m
%--------------------------------------------------------------------------

function [I_Codee,Poids,Compression,nb_coeffs_AC,nb_coeffs_DC] = ...
                         CompressionJPEG(I_Origine,canal,methode,F_Qualite)
sens = 'Direct';
taille_bloc = 8;

Poids.Origine = numel(I_Origine) / 1024; 


I_DCT = DCT2DParBlocs(sens,I_Origine,methode,taille_bloc);
I_Quant = QuantificationDCT(sens,I_DCT,canal,F_Qualite,taille_bloc);
[Coeff_AC, Coeff_DC] = CoefficientsACDC(I_Quant, taille_bloc);



[PAC, H] = CodageEntropique(Coeff_AC');
[PDC, H] = CodageEntropique(Coeff_DC');

Poids.H_JPEG = PAC + PDC;
I_Codee = I_Quant;

Compression = (1- (Poids.H_JPEG/Poids.Origine))*100;
nb_coeffs_AC = length(Coeff_AC);
nb_coeffs_DC = length(Coeff_DC);

end

%--------------------------------------------------------------------------
% Fonction de recuperation des coefficients AC/DC de la DCT par blocs
%--------------------------------------------------------------------------
%[Coeff_AC_Image, Coeff_DC_Image] = CoefficientsACDC(I_Quant, taille_bloc)
%
% sortie : Coeff_AC = vecteur reunissant tous les coefficients AC de 
%                     l'image jusqu'au dernier coefficient non nul 
%                     (taille variable)
%          Coeff_DC = vecteur reunissant tous les coefficients DC de
%                     l'image (taille fixe) 
% 
% entree : I_Quant = Image de DCT quantifiee
%          taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------
function [Coeff_AC, Coeff_DC] = CoefficientsACDC(I_Quant, taille_bloc)
   
nx = size(I_Quant,1)/taille_bloc;
ny = size(I_Quant,2)/taille_bloc;
nbpixel = taille_bloc*taille_bloc;
Coeff_DC = [];
Coeff_AC = [];
for i=0:(nx-1)
       for j=0:(ny-1)
            bloc = I_Quant(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc);
            Parcours = ParcoursBlocZigzag(bloc,nbpixel);
            Coeff_DC = [Coeff_DC Parcours(1)];
            non_0_index = find_last_nonzero_index(Parcours);
            % r=2;
            % while( (r<nbpixel) && Parcours(r)~=0)
            %     Coeff_AC = [Coeff_AC Parcours(r)];
            %     r=r+1;
            % end    
            for r=2:non_0_index
                Coeff_AC = [Coeff_AC Parcours(r)];
            end
            Coeff_AC = [Coeff_AC 1000];
       end
end


end


function index =find_last_nonzero_index(vecteur)
    index = -1;
    for i=length(vecteur):-1:1
        if vecteur(i) ~= 0
            index = i;
            break;
        end
    end
end

%--------------------------------------------------------------------------
% Fonction de parcours d'un bloc en zigzag pour recuperer les coefficients
% AC/DC de la DCT
%--------------------------------------------------------------------------
% Vecteur_zigzag = ParcoursBlocZigzag(Bloc_DCT,nb_pixels)
%
% sortie : Vecteur_zigzag = vecteur des coefficients DC/AC ordonnes du bloc
% 
% entrée : Bloc_DCT = DCT du bloc courant
%          nb_pixels = nombre de pixels dans le bloc
%--------------------------------------------------------------------------
function Vecteur_zigzag = ParcoursBlocZigzag(Bloc_DCT,nb_pixels)
    % Initialisation du vecteur qui contiendra les coefficients
    Vecteur_zigzag = zeros(1,nb_pixels);
    % Remplissage en partant du debut et de la fin
    for k = 1:nb_pixels/2
        n = ceil(sqrt(2*k+1/4)-0.5);
        temp = k - n*(n-1)/2;
        if (mod(n,2) < 1)
            i = temp; 
        else
            i = n + 1 - temp;
        end
        j = n + 1 - i;
        % Positionnement des coefficients dans le vecteur
        Vecteur_zigzag(k) = Bloc_DCT(i,j);
        Vecteur_zigzag(65-k) = Bloc_DCT(9-j,9-i);
    end
end




