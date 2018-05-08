function [ W1po , W2po,blad1,blad2 ] = uczenie2 ( wspUcz, beta, bias1, bias2, W1przed , W2przed , P , T, nrPrzykladu,blad1,blad2 )
% funkcja uczy sie� dwuwarstwow� na podanym ci�gu ucz�cym (P,T)
% przez zadan� liczb� epok (n)
% parametry: W1przed - macierz wag warstwy 1 przed uczeniem
% P - ci�g ucz�cy - przyk�ady - wej�cia
% T - ci�g ucz�cy - ��dane wyj�cia
% n - liczba epok
% wynik: W1po � macierz wag warstwy 1 po uczeniu
% W2po � macierz wag warstwy 2 po uczeniu
W1 = W1przed ;
W2 = W2przed ;
wierW2 = size(W2,1) ; % liczba wierszy macierzy W2

% podaj przyk�ad na wej�cia...
X = P(:,nrPrzykladu) ; % wej�cia sieci
% ...i oblicz wyj�cia
[ Y1 , Y2 ] = dzialaj2 ( beta, bias1, bias2, W1 , W2 , X ) ;
X1 = [ -1 ; X ] ; % wej�cia warstwy 1
X2 = [ -1 ; Y1 ] ; % wej�cia warstwy 2
D2 = T(:,nrPrzykladu) - Y2 ; % oblicz b��dy dla warstwy 2
D1 = W2(2:wierW2,:) * D2 ; % oblicz b��dy dla warstwy 1
blad2 = D2;
blad1 = D1;

funcA2 = 1 ./ ( 1 + exp ( -beta * X2) ) ;
funcP2 = beta*(1-funcA2).*funcA2;

funcA = 1 ./ ( 1 + exp ( -beta * X1) ) ;
funcP = beta*(1-funcA).*funcA;

dW1 = wspUcz * X1 * D1' .* funcP2; % oblicz poprawki wag warstwy 1
dW2 = wspUcz * X2 * D2' .* funcP; % oblicz poprawki wag warstwy 2
W1 = W1 + dW1 ; % dodaj poprawki do wag warstwy 1
W2 = W2 + dW2 ; % dodaj poprawki do wag warstwy 2

W1po = W1 ;
W2po = W2 ;
