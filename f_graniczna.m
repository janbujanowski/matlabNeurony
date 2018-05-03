function [ Wynik ] = f_graniczna( L, prog )
    [x,y] = size(L);
    Wynik = zeros(x,y);
    for i=1:x
        for j=1:y
            if L(i,j)> prog
                Wynik(i,j) = 1;
            else
                Wynik(i,j) = 0;
            end
        end
    end
end

