fact(n) = gamma(n + 1)
poisson(n, lambda) = lambda**n*exp(-lambda)/fact(n)
binomial(n, N, p) = fact(N)/(fact(n)*fact(N - n))*p**n*(1 - p)**(N - n)
chi_square(x, n, s2) = (x/(2*s2))**(n/2.0 - 1)*exp(-x/(2*s2))/(2*s2*gamma(n/2.0))
