function [A_rec]=es_repairing(A,mask,nmodes,tol)

% Algoritmo gappy POD de Everson-Sirovich

% A: Matriz con las snapshots en columnas
% mask: Matriz de posici�n de los valores a reparar (marcados con 1)
% nmodes: Modo usado para la reparaci�n
% tol: Tolerancia

nsnaps=size(A,2); % N�mero de snapshots
[cell_gap, snap_gap]=find(mask==1);  % Posici�n de cada error
ngaps=length(cell_gap); % N�mero de celdas a reparar

% Reconstrucci�n de la base de datos
A0=A; 
for i=1:ngaps % Valores iniciales nulos en las celdas a reparar
    A0(cell_gap(i),snap_gap(i))=0;
end

S0=A;

for i=1:ngaps % Valor promediado en las celda a reparar
    S0(cell_gap(i),snap_gap(i))=mean(A0(cell_gap(i),:));
end

% C�lculo de la matriz reconstruida
num_gaps=zeros(1,nsnaps);
imax=500;   % N�mero de iteraciones m�ximas
iter=0; % Contador inicial de iteraciones
tol_err=Inf; % Tolerancia inicial del error

while tol_err>tol && iter<imax
    S1=S0;
    [U,~,~]=svd(S0,'econ');
    for i=1:nsnaps
        num_gaps(i)=sum(mask(:,i)==1);   % N�mero de errores en cada snapshot
        if num_gaps(i)==0
            S0(:,i)=S0(:,i); 
        else
            
           Psi=U(:,1:nmodes).*abs(mask(:,i)-1);    % Anulaci�n de los modos POD (columnas de U) en celdas a reparar
           
           X=(Psi'*Psi)\(Psi'*A(:,i)); % Amplitud para cada modo mediante m�nimos cuadrados en celdas conocidas
           
           S0(:,i)=A0(:,i)+U(:,1:nmodes)*X.*mask(:,i);  % Reconstrucci�n de cada snapshots como combinaci�n lineal de modos en celdas a reparar
        
        end 
    end
    
    tol_err=norm(S1-S0,'fro')/sqrt(sum(num_gaps));
    iter=iter+1;
end
if iter==imax
    warning('No se ha cumplido la tolerancia de %d',tol)
end

% Matriz reconstruida
A_rec=S0;
