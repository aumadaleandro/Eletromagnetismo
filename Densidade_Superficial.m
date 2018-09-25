linhasParametro = 9
resolucao = 0.01

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
iteracoes = 1000


iCondI = ((b-(d+h))/dy)+1
iCondF = ((b-h)/dy)+1
jCondI = (g/dx)+1
jCondF = ((g+c)/dx)+1

A = zeros (ny + 1,nx + 1);

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

##Densidade superficial
ps_min = 0
ps = 0
eps0 = 8.854E-12
eps = eps0*1.9

##Borda Esquerda
for i = 1:ny
  ps = eps*(A(i,1) - A(i,2))/resolucao
  if (ps < ps_min)
    ps_min = ps
  end
end

##Borda Direita
for i = 1:ny
  ps = -eps*(A(i,nx - 1) - A(i,nx))/resolucao
  if (ps < ps_min)
    ps_min = ps
  end
end

##Borda Superior
for j = 1:nx
  ps = -eps*(A(2,j) - A(1,j))/resolucao
  if (ps < ps_min)
    ps_min = ps
  end
end

##Borda Inferior
for j = 1:nx
  ps = eps*(A(ny,j) - A(ny - 1,j))/resolucao
  if (ps < ps_min)
    ps_min = ps
  end
end
ps_min