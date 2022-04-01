function [puredata,iterator] = loadNext5(iteratorCount,filenames,puredata,nfiles)

        for K = iteratorCount : iteratorCount+5
            if iteratorCount > nfiles
                break
            end
            thisfile = filenames{K};                                %get file
            currentdata = readtable(thisfile);                      %load data from currently extracted file
            
            currentdata = renamevars(currentdata,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9",], ...
                 ["PRN","Year","Month","Day","Hour","Minute","Second","MessageType","Message",])
            
            puredata = cat(1,puredata,currentdata);                 %concatenate data into final table
        end
        
        iterator = iteratorCount + 5;
        
end

