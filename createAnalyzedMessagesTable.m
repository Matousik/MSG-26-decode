function [AnalyzedMessages] = createAnalyzedMessagesTable(puredata)

    %%create AnalyzedMessages table

    AnalyzedMessages = table('Size',[height(puredata) 6],'VariableTypes',{'string','string','string','string','string','string'});
    
    AnalyzedMessages = renamevars(AnalyzedMessages,["Var1","Var2","Var3","Var4","Var5","Var6"], ...
                 ["MSGPreamble","MSGTypeIdentifier","MSGBandNumber","MSGBlockID","IGP_Delay","IGP_GIVEI",]);
    
    %% loop through new table only with analyzed messages      
             
    for K = 1 : height(AnalyzedMessages)
        
        %message in binary format with length of 256 bits
        
        binMessage = hexToBinaryVector(string(puredata.Message(K)),256);   
                                                                   
        %Preamble,Type Identifier (26), band number and block id
        
        AnalyzedMessages.MSGPreamble(K) = string(binaryVectorToHex(binMessage(1,1:8)));
        AnalyzedMessages.MSGTypeIdentifier(K) = string(binaryVectorToHex(binMessage(1,9:14)));
        AnalyzedMessages.MSGBandNumber(K) = string(binaryVectorToHex(binMessage(1,15:18)));
        AnalyzedMessages.MSGBlockID(K) = string(binaryVectorToHex(binMessage(1,19:22)));
        
    end
    
    %% change hex to dec - we need this to separate rows by band number and block id
    
    AnalyzedMessages.MSGBandNumber = hex2dec(AnalyzedMessages.MSGBandNumber);
    AnalyzedMessages.MSGBlockID = hex2dec(AnalyzedMessages.MSGBlockID);
    
end

