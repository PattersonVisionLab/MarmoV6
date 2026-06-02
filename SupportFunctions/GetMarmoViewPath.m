function fPath = getMarmoViewPath()
% GETMARMOVIEWPATH
%
% Description:
%   Returns full path of MarmoView directory, assuming SupportFunctions loc
%
% Syntax:
%   fPath = getMarmoViewPath()
%
% History
%   06/02/2026 - SSP

    fPath = fileparts(fileparts(mfilename("fullpath")));
end

