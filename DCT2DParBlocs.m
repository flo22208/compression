
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022
                                               
%--------------------------------------------------------------------------
% Fonction de transformee (directe et inverse) en cosinus discrete par blocs
%--------------------------------------------------------------------------
% I_DCT = DCT2DParBlocs(sens,I,methode,taille_bloc)
%
% sortie  : I_DCT = image de la DCT ou IDCT par blocs
% 
% entrees : sens = sens pour la DCT : 'Direct' ou 'Inverse'
%           I = image avant DCT ou IDCT par blocs
%           methode = methode de calcul de la DCT : 'Matlab' ou 'Rapide'
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------

function I_DCT = DCT2DParBlocs(sens,I,methode,taille_bloc)
    

I_DCT = zeros(size(I));   

nx = size(I,1)/taille_bloc;
ny = size(I,2)/taille_bloc;
if strcmp(sens, "Direct")
    if strcmp(methode, "Matlab")
        for i=0:(nx-1)
           for j=0:(ny-1)
             I_DCT(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) = dct2(I(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc));
           end
        end
    end
elseif strcmp(sens, "Inverse")
    if strcmp(methode, "Matlab")
        for i=0:(nx-1)
           for j=0:(ny-1)
             I_DCT(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc) = idct2(I(i*taille_bloc+1:(i+1)*taille_bloc,j*taille_bloc+1:(j+1)*taille_bloc));
           end
        end
    end
end


end
  
%--------------------------------------------------------------------------
% Fonction de calcul de transformee en cosinus discrete rapide 
% pour un bloc de taille 8x8
%--------------------------------------------------------------------------
% Bloc_DCT2 = DCT2Rapide(Bloc_Origine, taille_bloc)
%
% sortie  : Bloc_DCT2 = DCT du bloc
% 
% entrees : Bloc_Origine = Bloc d'origine
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------
function Bloc_DCT2 = DCT2Rapide(Bloc_Origine,taille_bloc)
    


end

%--------------------------------------------------------------------------
% Fonction de calcul de transformee en cosinus discrete inverse rapide
% pour un bloc de taille 8x8
%--------------------------------------------------------------------------
% Bloc_IDCT2 = IDCT2Rapide(Bloc_DCT2,taille_bloc)
%
% sortie  : Bloc_IDCT2 = Bloc reconstruit par DCT inverse
% 
% entrees : Bloc_DCT2 = DCT du bloc 
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------

function Bloc_IDCT2 = IDCT2Rapide(Bloc_DCT2,taille_bloc)
    


end