 function [xsol,ysol] = linprog(A,b,c,inequ,tol)
% keywords: linear programming, optimization
% call: [xsol,ysol] = linprog(A,b,c,inequ,tol);
%
% linprog solves a linear minimization problem
%
% INPUT:         A       Coefficients for constraining equations and inequations,
%                        last 'inequ' equations are inequations (<=)
%                b       Right hand side of Ax = (<=) b
%                c       Coefficients of the linear cost function c'*x
%                inequ   see A
%                tol     tolerance for the solution, OPTIONAL, DEFAULT = 1e-5
%
% OUTPUT:        xsol    The solution vector
%                ysol    c'*xsol
%
% EXAMPLE:       Churchman, Ackoff, Arnoff, Introduction to Operations Research,
%                p. 304-, Wiley 1957:
%
%                A     = 0.01*[1 1 1 3 3 3;2 0 0 5 0 0;0 2 0 0 5 0;0 0 3 0 0 8];
%                b     = [850 700 100 900]';
%                c     = -0.01*[40 28 32 72 64 60]'; % must be negative for maximization!
%                inequ = 4;
%                [x,y] = linprog(A,b,c,inequ)

[m,n] = size(A);

if nargin < 5, tol = 1e-5; end
if nargin < 4, tol = 1e-5; inequ = 0; end

%Add slack variables

c = c(:)';
b = b(:);

if inequ > 0

    A = [A [zeros(m-inequ,inequ);eye(inequ)]];
    c = [c zeros(1,inequ)];

end

%Solution by Barnes' algorithm

[xsol,basic,ysol] = barnes(A,b,c,tol);

xsol = xsol(1:n);
