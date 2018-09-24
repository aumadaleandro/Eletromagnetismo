
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
iteracoes = 10000


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
A


eX = zeros (ny+2,nx+2);
eY = zeros (ny+2,nx+2);
for i = 1:ny
    for j = 1:nx
        eX(i+1,j+1)= (A(i+1,j) + A(i,j) - A(i+1,j+1) - A(i,j+1))/2*dx;
        eY(i+1,j+1)= (A(i,j+1) + A(i,j) - A(i+1,j+1) - A(i+1,j))/2*dy;
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
u = jCondI:linhasParametro:jCondF;
t = iCondI*ones(size(u));
s = (iCondF+0.00000001)*ones(size(u));

v = iCondI:linhasParametro:iCondF;
z = (jCondI)*ones(size(v));
w = (jCondF+0.00000001)*ones(size(v));

x = [u u z w];
y = [t s v v];

streamline(eX,eY,x,y)
%quiver(eX,eY)
jX = 3*10^-3*eX;
jY = 3*10^-3*eY;
