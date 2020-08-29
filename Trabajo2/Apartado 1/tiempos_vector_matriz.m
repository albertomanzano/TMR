A = rand(11);
B = rand(11,1);

M = 100000;

t_initial = cputime;
for i=1:M
   C = A*B; 
end
t_final = cputime;
t_matriz = t_final-t_initial;


A = rand(1000,1);
B = rand(1000,1);

t_initial = cputime;
for i=1:M
   C = A.*B; 
end
t_final = cputime;
t_vector = t_final-t_initial;

t_initial = cputime;
for i=1:M
   C = [0;A];
end
t_final = cputime;
t_alojamiento = t_final-t_initial;

t_vector
t_matriz
t_alojamiento