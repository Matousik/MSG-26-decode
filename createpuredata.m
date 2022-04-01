function [puredata] = createpuredata()
    puredata = table;     %first empty table, defining variable names
    
    puredata.PRN = zeros(0);
    puredata.Year = zeros(0);
    puredata.Month = zeros(0);
    puredata.Day = zeros(0);
    puredata.Hour = zeros(0);
    puredata.Minute = zeros(0);
    puredata.Second = zeros(0);
    puredata.MessageType = zeros(0);
    puredata.Message = zeros(0);
end

