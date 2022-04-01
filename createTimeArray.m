function [Time] = createTimeArray(MergedData)
    
    Timearray = strings;
    
    %create timestamp for each change
    
    for K = 1 : height(MergedData)
        
        Timearray(K) = "20"+MergedData.Year(K)+"-"+MergedData.Month(K)+"-"+MergedData.Day(K)+" "+MergedData.Hour(K)+":"+MergedData.Minute(K)+":"+MergedData.Second(K);
        
    end
    
    Time = datetime(Timearray,'InputFormat','yyyy-MM-dd HH:mm:ss');
    
end

