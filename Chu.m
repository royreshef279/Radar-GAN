function x = Chu(N)
chu = zeros(N,1);
for j = 0:N-1
    if mod(j,2) == 0
        chu(j+1) = exp(1i*2*pi*(j^2/(2*N)));
    else
        chu(j+1) = exp(1i*2*pi*(j*(j+1)/(2*N)));
    end
end
x = chu;