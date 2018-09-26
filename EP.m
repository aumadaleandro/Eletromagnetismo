
%Parametros
linhasParametro = 23
resolucao = 0.1
sigma = (3.2) * 10^-3 %Condutividade Elétrica do Meio
eps = 1.9 * (8.8541878117 * 10^(-12)) %Permissividade Eletrica do Meio

a = 11
b = 7
c = 4
d = b - 3
g = 4
h = (b-d)/2
dx = resolucao
dy = resolucao
nx = a/dx
ny = b/dy
iteracoes = 100000
corrente = 0
espessura = 1


iCondI = ((b-(d+h))/dy)+1
iCondF = ((b-h)/dy)+1
jCondI = (g/dx)+1
jCondF = ((g+c)/dx)+1

A = zeros (ny + 1,nx + 1);
%Calculo da Matriz de Potenciais
for i = iCondI:iCondF
  for j = jCondI:jCondF
    A(i,j) = 100;
  end
end
for n = 0:iteracoes
  for i = 2: ny
    for j = 2: nx
      if (~(i >= iCondI && i <= iCondF && j >= jCondI && j <= jCondF))
        A (i,j) = (A(i-1,j) + A(i+1,j) + A(i,j-1) + A(i,j+1))/4;
      end
    end
  end
end
contour (A,'LevelStep',10, 'ShowText','on')
A


%Calculo da Matriz de Campo
eX = zeros (ny+2,nx+2);
eY = zeros (ny+2,nx+2);
for i = 1:ny
    for j = 1:nx
        eX(i+1,j+1)= (A(i+1,j) + A(i,j) - A(i+1,j+1) - A(i,j+1))/ (2*dx*10^-2);
        eY(i+1,j+1)= (A(i,j+1) + A(i,j) - A(i+1,j+1) - A(i+1,j))/(2*dy*10^-2);
    end
end

for i = 1:ny+2
    eX(i,1)= eX(i,2);
    eX(i,nx+2)=eX(i,nx+1);
end
for j = 1:nx+2
    eY(1,j)= eY(2,j);
    eY(ny+2,j)=eY(ny+1,j);
end

hold on
u = jCondI:((jCondF-jCondI)/(linhasParametro)):jCondF;
t = iCondI*ones(size(u));
s = (iCondF+0.00000001)*ones(size(u));

v = iCondI:(iCondF-iCondI)/(linhasParametro-1):iCondF;
z = (jCondI)*ones(size(v));
w = (jCondF+0.00000001)*ones(size(v));

x = [u u z w];
y = [t s v v];

%Linhas de Campo
streamline(eX,eY,x,y)

%Definição da Matriz de Corrente
jX = sigma * eX;
jY = sigma * eY;

%Corrente dado jX
for i = 2:ny
    corrente = corrente + dy*10^-2 * espessura * abs(jX(i,2));
    corrente = corrente + dy*10^-2 * espessura * abs(jX(i,nx));
end
%Corrente dado jY
for j = 2:nx
    corrente = corrente + dx*10^-2 * espessura * abs(jY(2,i));
    corrente = corrente + dx*10^-2 * espessura * abs(jY(ny,2));
end

corrente
resistencia = 100 / corrente

%Resistencia para o dual da metade do problema
resistenciaDual = 1 / (resistencia*2*sigma^2*espessura^2) 

%Densidade superficial
ps_min = 0;
ps = 0;

%Borda Esquerda
for i = 1:ny
  ps = eps*(A(i,1) - A(i,2))/resolucao;
  if (ps < ps_min)
    ps_min = ps;
  end
end

%Borda Direita
for i = 1:ny
  ps = -eps*(A(i,nx - 1) - A(i,nx))/resolucao;
  if (ps < ps_min)
    ps_min = ps;
  end
end

%Borda Superior
for j = 1:nx
  ps = -eps*(A(2,j) - A(1,j))/resolucao;
  if (ps < ps_min)
    ps_min = ps;
  end
end

%Borda Inferior
for j = 1:nx
  ps = eps*(A(ny,j) - A(ny - 1,j))/resolucao;
  if (ps < ps_min)
    ps_min = ps;
  end
end
ps_min

