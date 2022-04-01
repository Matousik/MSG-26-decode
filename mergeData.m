function [MergedData] = mergeData(puredata,AnalyzedMessages)
    %% concatenate both tables
    
   	MergedData = [puredata,AnalyzedMessages];
    
    %% filter by prefered band and block ID
    % filter by prefered band number
    
    %   chosen IGP:     15 E lon, 50 N lat
    %   band number:    4
    %   block ID:       13 in whole map, 4 in EGNOS window
    %   IGP in block:   5 (200 in band 4)
    
    MergedData(MergedData.MSGBandNumber ~= 4, :) = [];
    MergedData(MergedData.MSGBlockID ~= 4, :) = [];
    
    %% select our IGP in block
    % our IGP - 5
    
    for K = 1 : height(MergedData)
        
        binMessage = hexToBinaryVector(string(MergedData.Message(K)),256);
    
        MergedData.IGP_Delay(K) = binaryVectorToHex(binMessage(1,205:213)); 
        MergedData.IGP_GIVEI(K) = binaryVectorToHex(binMessage(1,214:217));
        
    end
    
    %convert to decimal
    MergedData.IGP_Delay = hex2dec(MergedData.IGP_Delay);
    MergedData.IGP_GIVEI = hex2dec(MergedData.IGP_GIVEI);
    
    %scale factor 0.125 for VDelay as per RTCA DO-229D
    
    MergedData.IGP_Delay = MergedData.IGP_Delay*0.125;
end

