clear all
clc

%%load files

 projectdir = 'F:\Škola\Magisterské studium\diplomka\edas data\2017\1. půlka';                  % specifying root directory - from here all subdirectories will containt ems files
    dinfo = dir(fullfile(projectdir, '**', '*.txt'));           % list of all files in all subdirectories
    filenames = fullfile({dinfo.folder}, {dinfo.name});         %all subdirectiroes
    nfiles = length(filenames);                                 %number of all files
   
    [puredata] = createpuredata()
    
    iterator = 1;
        
        %%initiate iteration

        [puredata,iterator] = loadNext5(iterator,filenames,puredata,nfiles)

        %%puredata table now has all values, we now need to delete everything except message type 26

        puredata(puredata.MessageType ~= 26, :) = [];

        %%AnalyzedMessages

        [AnalyzedMessages] = createAnalyzedMessagesTable(puredata)

        %%create MergedData array, analyze GIVEI and VDelay

        [MergedData] = mergeData(puredata,AnalyzedMessages)        
        
    %%reiterate for nfiles
    
    for K = 1 : nfiles-5
        
        clear AnalyzedMessages puredata
        
        [puredata] = createpuredata()
        
        [puredata,iterator] = loadNext5(iterator,filenames,puredata,nfiles)

        puredata(puredata.MessageType ~= 26, :) = [];

        [AnalyzedMessages] = createAnalyzedMessagesTable(puredata)
        
        %concatenate MergedData tables

        [MergedData] = concatenateMergedData(MergedData,puredata,AnalyzedMessages)
        
    end
    
    %check if only one PRN
    
    for K = 1 : length(MergedData)
       
        if MergedData.PRN(K)~="120"
            msg='Error: Multiple PRNs included - filter dataset for only one PRN.';
            error(msg)
        end
        
    end
    
    %create Time array
    
    [Time] = createTimeArray(MergedData)
    
    %%plot
   
    
        figure('Name','GIVEI Values','NumberTitle','off');
        
        scatter(Time,MergedData.IGP_GIVEI,'r.')
            title('GIVEI Values')
            xlabel('Time')
            ylabel('GIVEI')
        
        figure('Name','Vertical Delay Values','NumberTitle','off');
        
        scatter(Time,MergedData.IGP_Delay,'b.')
            title('Vertical Delay values')
            xlabel('Time')
            ylabel('Vertical Delay [m]')
        
     

     