function [MSG26output] = MSG26decode(msg)
    
    %% messages extraction from .ems files into whole table, erase
    %everything except message type 26
    
    projectdir = 'C:\Users\Matous\Desktop\zk';                  % specifying root directory - from here all subdirectories will containt ems files
    dinfo = dir(fullfile(projectdir, '**', '*.txt'));           % list of all files in all subdirectories
    filenames = fullfile({dinfo.folder}, {dinfo.name});         %all subdirectiroes
    nfiles = length(filenames);                                 %number of all files
    puredata = table;                                           %first empty table, defining variable names
    
    puredata.PRN = zeros(0);
    puredata.Year = zeros(0);
    puredata.Month = zeros(0);
    puredata.Day = zeros(0);
    puredata.Hour = zeros(0);
    puredata.Minute = zeros(0);
    puredata.Second = zeros(0);
    puredata.MessageType = zeros(0);
    puredata.Message = zeros(0);
    
        for K = 1 : nfiles
            thisfile = filenames{K};                                %get file
            currentdata = readtable(thisfile);                      %load data from currently extracted file
            
            currentdata = renamevars(currentdata,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9",], ...
                 ["PRN","Year","Month","Day","Hour","Minute","Second","MessageType","Message",])
            
            puredata = cat(1,puredata,currentdata);                 %concatenate data into final table
        end
        
        
    %puredata table now has all values, we now need to delete everything
    %except message type 26
    
   puredata(puredata.MessageType ~= 26, :) = []



    %% analyze every message - convert into binary and push elementary
    %%information into new matrices
    
    
    %converting message to binary and extracting elementary information
    %into array which we will then use for 
    
    AnalyzedMessages = table('Size',[height(puredata) 6],'VariableTypes',{'string','string','string','string','string','string'})
    
    AnalyzedMessages = renamevars(AnalyzedMessages,["Var1","Var2","Var3","Var4","Var5","Var6"], ...
                 ["MSGPreamble","MSGTypeIdentifier","MSGBandNumber","MSGBlockID","IGP_Delay","IGP_GIVEI",])
    
    %% loop through new table only with analyzed messages      
             
    for K = 1 : height(AnalyzedMessages)
        
        binMessage = hexToBinaryVector(string(puredata.Message(K)),256);   %message in binary format with length of 256 bits
                                                                        %p.53
        AnalyzedMessages.MSGPreamble(K) = string(binaryVectorToHex(binMessage(1,1:8))); %Preamble,Type Identifier (26), band number and block id
        AnalyzedMessages.MSGTypeIdentifier(K) = string(binaryVectorToHex(binMessage(1,9:14)));
        AnalyzedMessages.MSGBandNumber(K) = string(binaryVectorToHex(binMessage(1,15:18)));
        AnalyzedMessages.MSGBlockID(K) = string(binaryVectorToHex(binMessage(1,19:22)));
        
    end
    
    %% change hex to dec - we need this to separate rows by band number and block id
    
    AnalyzedMessages.MSGBandNumber = hex2dec(AnalyzedMessages.MSGBandNumber);
    AnalyzedMessages.MSGBlockID = hex2dec(AnalyzedMessages.MSGBlockID);
    
    %% concatenate both tables
    
   	MergedData = [puredata,AnalyzedMessages];
    
   
  
    %% filter by prefered band and block ID
    % filter by prefered band number
    
    %   chosen IGP:     15 E lon, 50 N lat
    %   band number:    4
    %   block ID:       13
    %   IGP in block:   5 (200 in band 4)
    
    MergedData(MergedData.MSGBandNumber ~= 4, :) = [];
    MergedData(MergedData.MSGBlockID ~= 4, :) = [];
    
    %% select our IGP in block
    % our IGP - 5
    % bit spacing - 
    
    for K = 1 : height(MergedData)
        
        binMessage = hexToBinaryVector(string(MergedData.Message(K)),256);
    
        MergedData.IGP_Delay(K) = binaryVectorToHex(binMessage(1,205:213)); 
        MergedData.IGP_GIVEI(K) = binaryVectorToHex(binMessage(1,214:217));
        
    end
    
    %convert to decimal
    MergedData.IGP_Delay = hex2dec(MergedData.IGP_Delay);
    MergedData.IGP_GIVEI = hex2dec(MergedData.IGP_GIVEI);
    
    %scale factor 0.125 for VDelay
    
    MergedData.IGP_Delay = MergedData.IGP_Delay*0.125;
    
     %% create time array
    
    Timearray = strings;
    
    for K = 1 : height(MergedData)
        
        Timearray(K) = "20"+MergedData.Year(K)+"-"+MergedData.Month(K)+"-"+MergedData.Day(K)+" "+MergedData.Hour(K)+":"+MergedData.Minute(K)+":"+MergedData.Second(K);
        
    end
    
    Time = datetime(Timearray,'InputFormat','yyyy-MM-dd HH:mm:ss');
    
    %% plotting
    
    scatter(Time,MergedData.IGP_GIVEI,'r.')
    
    



    
    
    
    
    %% u need to -1 by everything - we start from index 0 in matrix

    binMSG = hexToBinaryVector(msg); %message in binary format
    
    MSG26Preamble = binaryVectorToHex(binMSG26(1,1:8)); %preamble
    
    MSG26TypeIdentifier = hex2dec(binaryVectorToHex(binMSG26(1,9:14))); %message identifier - should be 26 - used for verification purposes

    MSG26BandNumber = binaryVectorToHex(binMSG26(1,15:18)); %band number

    MSG26BlockID = binaryVectorToHex(binMSG26(1,19:22)); %block ID
    
    %% defining GIVEI and VDelay for each IGP

    IGP1_VDelay = binaryVectorToHex(binMSG26(1,23:31)); %%VDelay - 9 bits
    IGP1_GIVEI = binaryVectorToHex(binMSG26(1,32:35));  %%GIVEI - 4 bits
    
    IGP2_VDelay = binaryVectorToHex(binMSG26(1,36:44)); 
    IGP2_GIVEI = binaryVectorToHex(binMSG26(1,45:48));

    IGP3_VDelay = binaryVectorToHex(binMSG26(1,49:57)); 
    IGP3_GIVEI = binaryVectorToHex(binMSG26(1,58:61));
    
    IGP4_VDelay = binaryVectorToHex(binMSG26(1,62:70)); 
    IGP4_GIVEI = binaryVectorToHex(binMSG26(1,71:74));

    IGP5_VDelay = binaryVectorToHex(binMSG26(1,75:83)); 
    IGP5_GIVEI = binaryVectorToHex(binMSG26(1,84:87));
    
    IGP6_VDelay = binaryVectorToHex(binMSG26(1,88:96)); 
    IGP6_GIVEI = binaryVectorToHex(binMSG26(1,97:100));

    IGP7_VDelay = binaryVectorToHex(binMSG26(1,101:109)); 
    IGP7_GIVEI = binaryVectorToHex(binMSG26(1,110:113));
    
    IGP8_VDelay = binaryVectorToHex(binMSG26(1,114:122));
    IGP8_GIVEI = binaryVectorToHex(binMSG26(1,123:126));
    
    IGP9_VDelay = binaryVectorToHex(binMSG26(1,127:135)); 
    IGP9_GIVEI = binaryVectorToHex(binMSG26(1,136:139));

    IGP10_VDelay = binaryVectorToHex(binMSG26(1,140:148)); 
    IGP10_GIVEI = binaryVectorToHex(binMSG26(1,149:152));
    
    IGP11_VDelay = binaryVectorToHex(binMSG26(1,153:161)); 
    IGP11_GIVEI = binaryVectorToHex(binMSG26(1,162:165));

    IGP12_VDelay = binaryVectorToHex(binMSG26(1,166:174)); 
    IGP12_GIVEI = binaryVectorToHex(binMSG26(1,175:178));
    
    IGP13_VDelay = binaryVectorToHex(binMSG26(1,179:187)); 
    IGP13_GIVEI = binaryVectorToHex(binMSG26(1,188:191));

    IGP14_VDelay = binaryVectorToHex(binMSG26(1,192:200)); 
    IGP14_GIVEI = binaryVectorToHex(binMSG26(1,201:204));

    IGP15_VDelay = binaryVectorToHex(binMSG26(1,205:213)); 
    IGP15_GIVEI = binaryVectorToHex(binMSG26(1,214:217));
    
    %the remaining bits are of no use - spare and parity





end