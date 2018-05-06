In = dlmread ('input1.txt')
Out = dlmread ('target1.txt')
beta = 10;
bias1 = -1;
bias2 = -1;
wspUcz = 0.05;

liczbaEpok = 1000;
SkutecznoscEpoki=zeros(1,liczbaEpok);
skutecznosc=0;
wynik = 0;
[ W1przed , W2przed ] = init2 ( 2 , 2 , 1 );

%wynik sieci przed uczeniem
[ Y1 , Y2a ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,1) ) ;
[ Y1 , Y2b ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,2) ) ;
[ Y1 , Y2c ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,3) ) ;
[ Y1 , Y2d ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,4) ) ;
Yprzed = [ Y2a , Y2b , Y2c , Y2d ];
YprzedUczeniem = round(Yprzed,0)

index = 1;
losoweIndexy = [1,2,3,4];
losoweIndexy = losoweIndexy(randperm(length(losoweIndexy)));
for j=1:liczbaEpok
        skutecznosc = 0;
        %[ W1po , W2po ] = uczenie2 ( wspUcz, beta, bias1, bias2, W1przed , W2przed , In , Out , losoweIndexy(index) );
        index = index + 1;
         if index > length(losoweIndexy)
            index = 1;
            losoweIndexy = losoweIndexy(randperm(length(losoweIndexy)));
        end
        % funkcja uczy sieæ dwuwarstwow¹ na podanym ci¹gu ucz¹cym (P,T)
% przez zadan¹ liczbê epok (n)
% parametry: W1przed - macierz wag warstwy 1 przed uczeniem
% P - ci¹g ucz¹cy - przyk³ady - wejœcia
% T - ci¹g ucz¹cy - ¿¹dane wyjœcia
% n - liczba epok
% wynik: W1po – macierz wag warstwy 1 po uczeniu
% W2po – macierz wag warstwy 2 po uczeniu
W1 = W1przed ;
W2 = W2przed ;
wierW2 = size(W2,1) ; % liczba wierszy macierzy W2

% podaj przyk³ad na wejœcia...
X = In(:,losoweIndexy(index)) ; % wejœcia sieci
% ...i oblicz wyjœcia
[ Y1 , Y2 ] = dzialaj2 ( beta, bias1, bias2, W1 , W2 , X ) ;
X1 = [ -1 ; X ] ; % wejœcia warstwy 1
X2 = [ -1 ; Y1 ] ; % wejœcia warstwy 2
D2 = Out(:,losoweIndexy(index)) - Y2 ; % oblicz b³êdy dla warstwy 2
D1 = W2(2:wierW2,:) * D2 ; % oblicz b³êdy dla warstwy 1

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
        
       
       
        % sprawdzenie dzia³ania sieci po uczeniu
        [ Y1 , Y2a ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,1) ) ;
        [ Y1 , Y2b ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,2) ) ;
        [ Y1 , Y2c ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,3) ) ;
        [ Y1 , Y2d ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,4) ) ;
        W1przed = W1po;
        W2przed = W2po;
        Ypo = [ Y2a , Y2b , Y2c , Y2d ];
        YpoUczeniu = round(Ypo,0);

        for i=1:4
            if Out(i)==YpoUczeniu(i) 
             skutecznosc=skutecznosc+1;
            end
        end
        SkutecznoscEpoki(1,j)=skutecznosc*25;
end
YpoUczeniu
SkutecznoscProcentowa = skutecznosc * 25;
disp(sprintf('Skutecznoœæ = %d%%',SkutecznoscProcentowa));

dokladnosc=-1:0.0001:1;

%funkcja unipolarna:
funcA = 1 ./ ( 1 + exp ( -beta * dokladnosc ) ) ;
funcP = beta*(1-funcA).*funcA;
    
plotrows = 4;
plotcolumns = 3

figure
subplot(plotrows,plotcolumns,10)
plot(dokladnosc,funcA,'g')
axis([-1 1 0 1])  
xlabel('x')
ylabel('f(x)')
title('Funkcja aktywacji')


subplot(plotrows,plotcolumns,11)
plot(dokladnosc,funcP,'g')
axis([-1 1 0 5])
xlabel('x')
ylabel('df(x)/dx')
title('Pochodna funkcji aktywacji')


subplot(plotrows,plotcolumns,1:6)
plot(1:liczbaEpok,SkutecznoscEpoki,'g')
axis([0 liczbaEpok 0 100])  
xlabel('Liczba epok')
ylabel('Skutecznosc klasyfikacji w %')
title('Skutecznosc sieci')

wynik=['o','o','o','o'];
for i=1:4
    if YpoUczeniu(1,i)==1
        wynik(1,i)='x';
    end
end

subplot(plotrows,plotcolumns,12)
plot(In (1,1),In (2,1),wynik(1,1),In (1,2),In (2,2),wynik(1,2),In (1,3),In (2,3),wynik(1,3),In (1,4),In (2,4),wynik(1,4))
axis([-0.1 1.1 -0.1 1.1]) 
title('Wynik XOR')
legend ('=0','=1')

    

