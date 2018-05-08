function [ W1po , W2po,blad1,blad2 ] = uczenieWielomian ( wspUcz, beta, bias1, bias2, W1przed , W2przed , P , T, nrPrzykladu,blad1,blad2 )
a = 0.3;
b= -0.2;
W1 = W1przed ;
W2 = W2przed ;
wierW2 = size(W2,1) ; % liczba wierszy macierzy W2

% podaj przyk³ad na wejœcia...
X = P(:,nrPrzykladu) ; % wejœcia sieci
% ...i oblicz wyjœcia
[ Y1 , Y2 ] = dzialajWielomian ( beta, bias1, bias2, W1 , W2 , X ) ;
X1 = [ -1 ; X ] ; % wejœcia warstwy 1
X2 = [ -1 ; Y1 ] ; % wejœcia warstwy 2
D2 = T(:,nrPrzykladu) - Y2 ; % oblicz b³êdy dla warstwy 2
D1 = W2(2:wierW2,:) * D2 ; % oblicz b³êdy dla warstwy 1
blad2 = D2;
blad1 = D1;

funcA2 = a * X2 .^3 + b * X2;
funcP2 = 3* a* X2 .^2 +b ;

funcA = a * X1 .^3 + b * X1;
funcP = 3* a* X1 .^2 +b ;

dW1 = wspUcz * X1 * D1' .* funcP2; % oblicz poprawki wag warstwy 1
dW2 = wspUcz * X2 * D2' .* funcP; % oblicz poprawki wag warstwy 2
W1 = W1 + dW1 ; % dodaj poprawki do wag warstwy 1
W2 = W2 + dW2 ; % dodaj poprawki do wag warstwy 2

W1po = W1 ;
W2po = W2 ;
