function anatomy = getAnatomy()
global pixelTc
anatomy = pixelTc{1}(:,:,1); %snapshot from the first frame should be sufficient
%     
%     a = cellfun(@(x)mean(x,3),pixelTc,'uniformoutput',false);
%     a = cell2mat(reshape(a,[1 1 length(a)]));
%     anatomy = a;
    %anatomy = std(a,[],3);
end

