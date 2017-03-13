function spec = getExpSpec(Analyzer)
    spec.id = getPosixTimeNow;
    spec.tstamp =  datestr(datetime('now'),31);
    
    spec.animal = Analyzer.M.anim;
    spec.unit = Analyzer.M.unit;
    spec.expt = Analyzer.M.expt;
    spec.hemisphere = Analyzer.M.hemi;
    
    spec.module = Analyzer.modID;
    
    % get domains and convert to string
    [domains,domval] = getdomainvalue(Analyzer);
    domains = savejson('',domains);
    spec.paramlist = domains;
    
    % get blocking and convert to string
    spec.block = cell2mat(cellfun(@(x)x{3},Analyzer.L.param,'uniformoutput',false));
    spec.block = ['[' num2str(spec.block) ']'];
    
    % convert domval and triallist to json
    opt.ArrayToStruct = 1;
    spec.domval = savejson('',domval,opt);
    spec.triallist = savejson('',getcondtrial(Analyzer),opt);
    
    roots = textscan(Analyzer.M.analyzerRoot, '%s%s', 'delimiter', '; ');
    filename = [Analyzer.M.anim '_' sprintf('u%s',Analyzer.M.unit) '_' Analyzer.M.expt];
    spec.analyzerpath = [strrep(roots{1}{2},'\','/') '/' Analyzer.M.anim '/' filename '.analyzer'];
    
    spec.analyzer = savejson('',Analyzer);
end