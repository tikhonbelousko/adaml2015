  function T = writetab(S,file,fmt)
% keywords: exporting data
% call: T = writetab(S,file,fmt)
% The function replaces spaces to single tab's. A numerical input
% matrix is first transformed to a string matrix according to the
% format given in 'fmt'. Useful for exporting Matlab tables to
% spreadsheet and word processing programs.
% NOTE: only for Matlab version 4.0 or higher.
%
% INPUT:        S       A string matrix (table) or a matrix (fmt must be given)
%               file    A string containing the output file name
%               fmt     output format string, needed only if S is not a string
%
% OUTPUT:               A file whose name is given in the string file.
%                       All blanks are replaced by single TABs.

if nargin == 2, fmt = []; end

if length(fmt) > 0
    S = sprintf(fmt,S');
end 

fid = fopen(file,'w');

[nr,nc] = size(S);

if length(fmt) == 0
    S(:,nc) = ones(nr,1)*10; % Linefeeds to the end
end

S       = S';
S       = abs(S(:));

iblank = find(S == 32);  % Find the blanks

i      = [iblank-[0;iblank(1:length(iblank)-1)]];
itab   = iblank(find(i  > 1)); 
iblank = iblank(find(i == 1));

S(itab) = ones(size(itab))*9;   % Place the tabs
S       = remove(S,iblank);     % Remove the blanks
k       = find(S(1:length(S)-1)==9 & S(2:length(S))==10); % tabs that replaced trailing blanks
S       = remove(S,k);
k       = find(S(1:length(S)-1)==10 & S(2:length(S))==9); % tabs that replaced heading blanks
S       = remove(S,k+1);

if nargout > 0, T = S; end

fwrite(fid,S);

fclose(fid);
