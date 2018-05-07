function [ Y1 , Y2 ] = dzialaj2 ( beta, bias1, bias2, W1 , W2 , X )
% funkcja symuluje dzia³anie sieci dwuwarstwowej
% parametry: W1 - macierz wag pierwszej warstwy sieci
% W2 - macierz wag drugiej warstwy sieci
% X - wektor wejœæ do sieci
% sygna³ podany na wejœcie ( sieci / warstwy 1 )
% wynik: Y1 - wektor wyjœæ warstwy 1 ( przyda siê podczas uczenia )
% Y2 - wektor wyjœæ warstwy 2 / sieci
% sygna³ na wyjœciu sieci
X1 = [ bias1 ; X ] ;
U1 = W1' * X1 ;

%funkcja unipolarna
Y1 = 1 ./ ( 1 + exp ( -beta * U1 ) ) ;
X2 = [ bias2 ; Y1 ] ;
U2 = W2' * X2 ;
Y2 = 1 ./ ( 1 + exp ( -beta * U2 ) ) ;


 
 
 
