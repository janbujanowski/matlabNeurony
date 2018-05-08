In = dlmread ('input1.txt')
Out = dlmread ('target1.txt')
beta = 10;
bias1 = -1;
bias2 = -1;
wspUcz = 0.15;  

liczbaEpok = 1000;
SkutecznoscEpoki=zeros(2,liczbaEpok);
skutecznosc=0;
wynik = 0;

%100% dla wielomianu uda³o siê nauczyæ :
% W1 = [0.046232539369607 0.904045586855245;0.951166773369903 1.043810180720127;-1.192796752294291 -0.748014324612826];
% W2 = [-1.331716564497053;0.887554057441470;-0.475863799191821];
% W1a = randn(3,1)/2;
% W1b = randn(3,1)/2;
% W1przed = [W1a,W1b];
% W2przed = randn(3,1);
[ W1przed , W2przed ] = init2 ( 2 , 2 , 1 );

%wynik sieci przed uczeniem
[ Y1 , Y2a ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,1) ) ;
[ Y1 , Y2b ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,2) ) ;
[ Y1 , Y2c ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,3) ) ;
[ Y1 , Y2d ] = dzialaj2 ( beta, bias1, bias2, W1przed , W2przed , In (:,4) ) ;
Yprzed = [ Y2a , Y2b , Y2c , Y2d ];
YprzedUczeniem = round(Yprzed,0)

% [ Y1w , Y2aw ] = dzialajWielomian ( beta, bias1, bias2, W1przed , W2przed , In (:,1) ) ;
% [ Y1w , Y2bw ] = dzialajWielomian ( beta, bias1, bias2, W1przed , W2przed , In (:,2) ) ;
% [ Y1w , Y2cw ] = dzialajWielomian ( beta, bias1, bias2, W1przed , W2przed , In (:,3) ) ;
% [ Y1w , Y2dw ] = dzialajWielomian ( beta, bias1, bias2, W1przed , W2przed , In (:,4) ) ;
% YprzedW = [ Y2aw , Y2bw , Y2cw , Y2dw ];
% YprzedUczeniemW = round(YprzedW,0)

blad = zeros(2,liczbaEpok);
W1 = W1przed;
W2 = W2przed;
for j=1:liczbaEpok
        skutecznosc = 0;
        %nrwejscia = mod(j,4)+ 1;
        nrwejscia = randi([1 4],1);
        %[ W1po , W2po,blad1,blad2 ] = uczenie2 ( wspUcz, beta, bias1, bias2, W1 , W2 , In , Out , nrwejscia);
        [ W1po , W2po,blad1,blad2 ] = uczenieWielomian ( wspUcz, beta, bias1, bias2, W1 , W2 , In , Out , nrwejscia);
        blad(1,j) = blad1(1);
        blad(2,j) = blad2;
        % sprawdzenie dzia³ania sieci po uczeniu
%         [ Y1 , Y2a ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,1) ) ;
%         [ Y1 , Y2b ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,2) ) ;
%         [ Y1 , Y2c ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,3) ) ;
%         [ Y1 , Y2d ] = dzialaj2 ( beta, bias1, bias2, W1po , W2po , In (:,4) ) ;
        
        [ Y1 , Y2a ] = dzialajWielomian ( beta, bias1, bias2, W1po , W2po , In (:,1) ) ;
        [ Y1 , Y2b ] = dzialajWielomian ( beta, bias1, bias2, W1po , W2po , In (:,2) ) ;
        [ Y1 , Y2c ] = dzialajWielomian ( beta, bias1, bias2, W1po , W2po , In (:,3) ) ;
        [ Y1 , Y2d ] = dzialajWielomian ( beta, bias1, bias2, W1po , W2po , In (:,4) ) ;
        
        W1 = W1po;
        W2 = W2po;
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
disp(sprintf('Skutecznosc = %d%%',SkutecznoscProcentowa));

dokladnosc=-1:0.0001:1;

%funkcja unipolarna:
funcA = 1 ./ ( 1 + exp ( -beta * dokladnosc ) ) ;
funcP = beta*(1-funcA).*funcA;
    
plotrows = 4;
plotcolumns = 3;


figure
plot(1:liczbaEpok,blad(1,1:liczbaEpok));
% axis([0 1000 -1 1 ])
 hold on
plot(1:liczbaEpok,blad(2,1:liczbaEpok));
 hold off
title('Blad na wagach')
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

    

