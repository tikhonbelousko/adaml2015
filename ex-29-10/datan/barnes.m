  function [xsol,basic,objective] = barnes(A,b,c,tol)
% keywords: linear programming, optimization, Karmarkar's algorithm
% call: [xsol,basic,objective] = barnes(A,b,c,tol)
%
% From Linfield & Penny: Numerical Methods using MATLAB, 
% Ellis Horwood 1995 (modified by VMT 1995)
%

if nargin < 4, tol = 1e-5; end

[m,n] = size(A);

% Set up initial problem

A  = [A b-sum(A(1:m,:)')'];
c  = [c 1e6];
B  = [];
n  = n+1;
x0 = ones(n,1);
x  = x0; 

alpha  = 1e-4;
lambda = zeros(m,1);
iter   = 0;

%Main loop:

while abs(c*x-lambda'*b) > tol

    x2      = x.*x;
    D       = diag(x);
    D2      = diag(x2);
    AD2     = A*D2;
    lambda  = (AD2*A')\(AD2*c');
    dualres = c'-A'*lambda;
    normres = norm(D*dualres);
    for i = 1:n
        if dualres(i) > 0
            ratio(i) = normres/(x(i)*(c(i)-A(:,i)'*lambda));
        else
            ratio(i) = inf;
        end
    end
    R          = min(ratio)-alpha;
    x1         = x - R*D2*dualres/normres;
    x          = x1;
    basiscount = 0;
    B          = [];
    basic      = [];
    cb         = [];
    for k = 1:n
        if x(k) > tol
            basiscount = basiscount+1;
            basic      = [basic k];
        end
    end
    
%Only used if problem is non-degenerate

    if basiscount == m
        for k = basic
            B  = [B A(:,k)];
            cb = [cb c(k)];
        end
        primalsol = b'/B';
        break
    end
    iter = iter+1;
end

objective = c*x;
xsol      = x;


