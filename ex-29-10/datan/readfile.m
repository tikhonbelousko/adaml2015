  function [S,n] = readfile(file,idisp,ansi,linefeed)
% keywords: importing data
% call: [S,n] = readfile(file,idisp,ansi,linefeed)
% The function reads any ascii file into a string matrix. Shorter
% lines expanded to maximum row length by spaces.
% NOTE: only for Matlab version 4.0 or higher.
% INPUT:   file      a string containing the file name
%          idisp     a display option, any value > 0 displays
%                    the lines read.
%                    OPTIONAL, default: idisp = 0
%          ansi      if ansi = 1 <-> ansi standard (lines end with
%                    ascii 13 and 10 (carriage return and line feed).
%                    Otherwise lines end with ascii 10 (line feed) only.
%                    Default: ansi = 1
%          linefeed  a linefeed option, any value ~= 0 takes
%                    the linefeeds into S,
%                    OPTIONAL, default: linefeed = 0
% OUTPUT:  S         a string matrix containing the file
%          n         number of lines in the file

vers = abs(version); vers = vers(1);

if nargin == 3, linefeed = 0; end
if nargin == 2, linefeed = 0; ansi = 1; end
if nargin == 1, idisp = 0; linefeed = 0; ansi = 1; end

fid = fopen(file,'r');
s   = fread(fid);
s   = setstr(s');

if ansi ~= 1

    if s(length(s)) ~= 10, s(length(s)+1) = 10; end

    k   = find(abs(s)==10); k = [0;k(:)]; nrS = length(k);
    dk  = diff(k)-1;
    ncS = max(dk);
    S   = 32*ones(nrS,ncS);

    for i = 2:nrS
        if linefeed ~= 0
            S(i-1,1:dk(i-1)+1) = s(k(i-1)+1:k(i));
        else
            if k(i) > k(i-1)+1
                S(i-1,1:dk(i-1)) = s(k(i-1)+1:k(i)-1);
            end
        end
        if idisp > 0, disp(setstr(s(k(i-1)+1:k(i)-1))), end
        if idisp < 0 & rem(i,idisp) == 0, disp([i size(S)]), end
    end

else

    if s(length(s)) ~= 10, s(length(s)+1:length(s)+2) = [13 10]; end

    k   = find(abs(s)==10); k = [0;k(:)]; nrS = length(k);
    dk  = diff(k)-2;
    ncS = max(dk);
    S   = 32*ones(nrS,ncS);

    for i = 2:nrS
        if linefeed ~= 0
            S(i-1,1:dk(i-1)+2) = s(k(i-1)+1:k(i));
        else
            if k(i) > k(i-1)+1
                S(i-1,1:dk(i-1)) = s(k(i-1)+1:k(i)-2);
            end
        end
        if idisp > 0, disp(setstr(s(k(i-1)+1:k(i)-2))), end
        if idisp < 0 & rem(i,idisp) == 0, disp([i size(S)]), end
    end

end

S = setstr(S);
n = nrS;

fclose(fid);
