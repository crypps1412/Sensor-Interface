function y = Calib(x,x0,y0,type)
if strcmp(type,'Exact')
    y = matrixExact(x,x0,y0);
elseif strcmp(type,'Linear')
    y = matrixLinear(x,x0,y0);
elseif strcmp(type,'Lagrange')
    y = matrixLagrange(x,x0,y0);
end


function y = matrixExact(x,x0,y0)
if ~isequal(size(y0),size(x0))
    errordlg(sprintf('ERROR!\nX_0 and Y_0 must have the same number of elements'));
    y = NaN;
elseif ~isequal(size(x,2),size(x0,2))
    errordlg(sprintf('ERROR!\nX and X_0 must have the same number of columns'));
    y = NaN;
else
    y = x;
    for c = 1:size(x,2)
        y(:,c) = Exact(x(:,c),x0(:,c),y0(:,c));
    end
end

function y = Exact(x,x0,y0)
y = x;
for i = 1:length(x)
    if x(i) <= x0(1)
        y(i) = y0(1);
    elseif x(i) > x0(end)
        y(i) = y0(end);
    else
        for j = 1:length(x0)-1
            if x(i) > x0(j) && x(i) < mean([x0(j),x0(j+1)])
                y(i) = y0(j);
                break;
            elseif x(i) >= mean([x0(j),x0(j+1)]) && x(i) <= x0(j+1)
                disp(num2str(x(i)));
                y(i) = y0(j+1);
                break;
            end
        end
    end
end


function y = matrixLinear(x,x0,y0)
if ~isequal(size(y0),size(x0))
    errordlg(sprintf('ERROR!\nX_0 and Y_0 must have the same number of elements'));
    y = NaN;
elseif ~isequal(size(x,2),size(x0,2))
    errordlg(sprintf('ERROR!\nX and X_0 must have the same number of columns'));
    y = NaN;
else
    y = x;
    for c = 1:size(x,2)
        y(:,c) = Linear(x(:,c),x0(:,c),y0(:,c));
    end
end

function y = Linear(x,x0,y0) % Linear Interpolation
X0 = [ones(length(x0),1),x0];
w = [0;1];
learning_rate = 0.0001;
numOfIteration = 200;
for i=1:numOfIteration
    r = X0*w-y0;
    w(1) = w(1)-learning_rate*sum(r);
    w(2) = w(2)-learning_rate*sum(x0.*r);
end
X = [ones(length(x),1),x];
y = X*w;



function y = matrixLagrange(x,x0,y0)
if size(y0) ~= size(x0)
    errordlg(sprintf('ERROR MATRIX LAGRANGE!\nX_0 and Y_0 must have the same number of elements'));
    y = NaN;
elseif size(x,2) ~= size(x0,2)
    errordlg(sprintf('ERROR MATRIX LAGRANGE!\nX and X_0 must have the same number of columns'));
    y = NaN;
else
    y = x;
    for c1 = 1:size(x,1)
        for c2 = 1:size(x,2)
            y(c1,c2) = LI(x(c1,c2),x0(:,c2),y0(:,c2));
        end
    end
end

function y = LI(x,x0,y0) % Lagrange Interpolation
n = length(x0);
a = zeros(1,n);
b = 0;
X0 = x0;
Y0 = y0;
for i = 1:n
    if ~a(i)
        c = find(y0 == y0(i));
        b = b + 1;
        X0(b) = mean(x0(c));
        Y0(b) = y0(i);
        a(c) = 1;
    end
end
X0 = X0(1:b);
Y0 = Y0(1:b);

n = length(X0);
L = ones(1,n);
for i=1:n
   for j=1:n
      if (i~=j)
         L(i)=L(i)*(x-X0(j))/(X0(i)-X0(j));
      end
   end
end
y = L*Y0;