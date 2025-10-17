
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Fonction de quantification (directe et inverse) des coefficients DCT
%--------------------------------------------------------------------------
% I_Quant = QuantificationDCT(sens,I_DCT,canal,F_Qualite,taille_bloc)
%
% sorties : I_Quant = image quantifiee
% 
% entrees : sens = sens de la quantification : 'Direct' ou 'Inverse'
%           I_DCT = image avant la quantification
%           canal = canal pour le choix de la table de quantification :
%                   'Luminance', 'Chrominance' ou 'Residu'
%           F_Qualite = facteur de qualite pour la compression
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)       
%--------------------------------------------------------------------------

function I_Quant = QuantificationDCT(sens,I,canal,F_Qualite,taille_bloc)

nx = size(I,1)/taille_bloc;
ny = size(I,2)/taille_bloc;

T_Quand = ChoixTableQuantification(canal,F_Qualite);
I_Quant = zeros(size(I));

if strcmp(sens, "Direct")
    for i=0:(nx-1)
           for j=0:(ny-1)
             I_Quant(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) = round(I(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) ./T_Quand);
           end
    end
elseif strcmp(sens, "Inverse")
    for i=0:(nx-1)
        for j=0:(ny-1)
            I_Quant(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) = I(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) .* T_Quand;
        end
    end
end


end

%--------------------------------------------------------------------------
% Fonction de selection d'une table de quatification JPEG en fonction du
% type de canal et du facteur de qualite
%--------------------------------------------------------------------------
% T_Quant = ChoixTableQuantification(Canal, F_Qualite)
%
% sortie  : T_Quant = Table de quantification JPEG
% 
% entrees : canal = 'Luminance' ou 'Chrominance' (tables differentes)
%           F_Qualite = facteur de qualite (entre 0 et 97)
%--------------------------------------------------------------------------

function T_Quant = ChoixTableQuantification(canal,F_Qualite)
  
    
Fql = [16 11 10 16 24 40 51 61;12 12 14 19 26 58 60 55;14 13 16 24 40 57 69 56;14 17 22 29 51 87 80 62;18 22 37 56 68 109 103 77;24 35 55 64 81 104 113 92;49 64 78 87 103 121 120 101;72 92 95 98 112 100 103 99];

if canal=='Luminance'
    Fqr = Fql;
end

if F_Qualite > 50
    T_Quant = round(((100-F_Qualite)/50) * Fqr);
end
if F_Qualite <= 50
    T_Quant = round(((50)/F_Qualite) * Fqr);
end

end