  function [y,inter1] = varnames(inter,nx,intcep)
% keywords: regression analysis, demo
% call: [y,inter1] = varnames(inter,nx,intcep)
%
% This function is used to
% 1) add [0;0] (standing for intercept) to 'inter'  and transpose
%    it for displaying purposes (e.g., after REG)
% 2) add linear terms to inter (see INTERA), whenever 'nx > 0'
%
% INPUT:  inter        names for interactions (see INTERA)
%         nx           number of variables; used only if linear terms
%                      are missing in 'inter'. (DEFAULT: nx = 0)
%         intcep       intcep=1 => model contains an intercept (DEFAULT!)
%                      intcep=0 => model does not contain an intercept
% OUTPUT: y            'inter' transposed + possibly added linear terms
%                      and intercept
%         inter1       'inter' + possibly added linear terms

if nargin == 2
   intcep = 1;
elseif nargin == 1
   intcep = 1; nx = [];
end

if intcep ~= 1, intcep = 0; end

if length(nx) > 0
    inter = [[1:nx;zeros(1,nx)] inter];
end

%y = '      ';
%y = ones(length(inter(1,:))+intcep,1)*y;

y = inter';

if intcep == 1
%    y(1,:) = 'intcep';
    y = [[0 0];y];
end

%for i = 1+intcep:length(inter(1,:))+intcep

%    k = i-intcep;
%    if inter(2,k) == 0
%        y(i,:) = sprintf('%6.0f',inter(1,k));
%    else
%        y(i,:) = [sprintf('%3.0f',inter(1,k)) sprintf('%3.0f',inter(2,k))];
%    end

%end

inter1 = inter;
   
