function [MergedData] = concatenateMergedData(MergedData,puredata,AnalyzedMessages)
%% concatenate both tables
    
   	MergedDataNew = [puredata,AnalyzedMessages];
    
    %% filter by prefered band and block ID
    % filter by prefered band number
    
    %   chosen IGP:     15 E lon, 50 N lat
    %   band number:    4
    %   block ID:       13 in whole map, 4 in EGNOS window
    %   IGP in block:   5 (200 in band 4)
    
    MergedDataNew(MergedDataNew.MSGBandNumber ~= 4, :) = [];
    MergedDataNew(MergedDataNew.MSGBlockID ~= 4, :) = [];
    
    %% select our IGP in block
    % our IGP - 5
    
    for K = 1 : height(MergedDataNew)
        
        binMessage = hexToBinaryVector(string(MergedDataNew.Message(K)),256);
    
        MergedDataNew.IGP_Delay(K) = binaryVectorToHex(binMessage(1,205:213)); 
        MergedDataNew.IGP_GIVEI(K) = binaryVectorToHex(binMessage(1,214:217));
        
    end
    
    %convert to decimal
    MergedDataNew.IGP_Delay = hex2dec(MergedDataNew.IGP_Delay);
    MergedDataNew.IGP_GIVEI = hex2dec(MergedDataNew.IGP_GIVEI);
    
    %scale factor 0.125 for VDelay as per RTCA DO-229D
    
    MergedDataNew.IGP_Delay = MergedDataNew.IGP_Delay*0.125;
    
    MergedData = vertcat(MergedData,MergedDataNew)
end

