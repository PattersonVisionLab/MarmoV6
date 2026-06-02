function fPath = GetMarmoViewPath()
%GETMARMOVIEWPATH Summary of this function goes here
%   Detailed explanation goes here
    fPath = fileparts(fileparts(mfilename("fullpath")));
end

