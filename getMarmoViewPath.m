function fPath = getMarmoViewPath()
% GETMARMOVIEWPATH
%
% Description:
%   Returns full path of MarmoView directory
%
% Syntax:
%   fPath = getMarmoViewPath()
%
% History
%   06/02/2026 - SSP

    fPath = fileparts(mfilename("fullpath"));
end

