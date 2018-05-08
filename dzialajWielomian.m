function [Y1,Y2] = dzialajWielomian ( beta, bias1, bias2, W1 , W2 , X )
a = 0.2;
b= -0.1;

X1 = [ bias1 ; X ] ;
U1 = W1' * X1 ;

%funkcja kwadratowa
Y1 = a * U1 .^2 + b * U1;
X2 = [ bias2 ; Y1 ] ;
U2 = W2' * X2 ;
Y2 = a * U2 .^2 + b * U2;
