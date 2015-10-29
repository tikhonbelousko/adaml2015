  function [x,y,MINX,MAXX,DELTAX] = irmat(file)
% keywords: spectrum, spectra, IR-spectroscopy
% call: [x,y,MINX,MAXX,DELTAX] = irmat(file)
% INPUT      file         a string containing the file name (JCAMP-DX format)
%
% OUTPUT     x            a vector containing the wave numbers
%            y            a vector containing the absorbances
%            MINX         the smalles wave number
%            MAXX         the largest wave number
%            DELTAX       the wave number increment
%
% REMARK the JDX format may differ in different platforms, in case of
% trouble check, e.g., the options used in READFILE.

% S = readfile(file,0,0);

y = [];

S = readfile(file);

[n,m] = size(S);

jend  = [];
yi    = [];
i     = 0;

while length(jend) == 0 % go through the whole file until ##END line

    i = i+1;

    jend = findstr(S(i+1,:), '##END');

    if length(findstr(S(i,1:2),'##')) > 0 % lookfor ## lines

        j = findstr(S(i,:),'##MAXX');     % find the line containing ##MAXX
        if length(j) > 0
           eval(S(i,3:m))                 % evaluate MAXX = <value>
        end
        j = findstr(S(i,:),'##MINX');     % find the line containing ##MINX
        if length(j) > 0
           eval(S(i,3:m))                 % evaluate MINX = <value>
        end
        j = findstr(S(i,:),'##DELTAX');   % find the line containing ##DELTAX
        if length(j) > 0
           eval(S(i,3:m))                 % evaluate DELTAX = <value>
        end

    else                                  % the actual spectrum is on these lines which
                                          % do not start with ##
        
        jj = findstr(S(i,:),'?');         % the absorbances with ? are set to value 0
        for ii = 1:length(jj)
            S(i,jj(ii)) = '0';
        end
        
        eval(['yi = [' S(i,1:m-1) '];'])  % evaluate a line of data
        y = [y yi(2:length(yi))];         % concatenate it to the vector y (the 1. number is a
                                          % x-value)

    end

end

x = linspace(MINX,MAXX,length(y));        % construct the wavenumbers 
