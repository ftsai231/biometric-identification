% gethammingdistance - returns the Hamming Distance between two iris templates
% incorporates noise masks, so noise bits are not used for
% calculating the HD
%
% Usage: 
% [template, mask] = createiristemplate(eyeimage_filename)
%
% Arguments:
%	template1       - first template
%   mask1           - corresponding noise mask
%   template2       - second template
%   mask2           - corresponding noise mask
%   scales          - the number of filters used to encode the templref = eyeimageates,
%                     needed for shifting.
%
% Output:
%   hd              - the Hamming distance as a ratio
%
% Author: 
% Libor Masek
% masekl01@csse.uwa.edu.au
% School of Computer Science & Software Engineering
% The University of Western Australia
% November 2003
clc

hd_a = zeros(length(mask_p), length(mask));

for i = 1:length(mask_p)
    for j = 1:length(mask)
        hd_a(i,j) = gethammingdistance2(template_p{i,1}, mask_p{i,1}, template{j,1}, mask{j,1},1);
    end
end


function hd = gethammingdistance2(template1, mask1, template2, mask2, scales)

template1 = logical(template1);
mask1 = logical(mask1);

template2 = logical(template2);
mask2 = logical(mask2);

hd = NaN;

% shift template left and right, use the lowest Hamming distance
for shifts=-8:8
    
    template1s = shiftbits(template1, shifts,scales);
    mask1s = shiftbits(mask1, shifts,scales);
    
    
    mask = mask1s | mask2;
    
    nummaskbits = sum(sum(mask == 1));
    
    totalbits = (size(template1s,1)*size(template1s,2)) - nummaskbits;
    
    C = xor(template1s,template2);
    
    C = C & ~mask;
    bitsdiff = sum(sum(C==1));
    
    if totalbits == 0
        
        hd = NaN;
        
    else
        
        hd1 = bitsdiff / totalbits;
        
        
        if  hd1 < hd || isnan(hd)
            
            hd = hd1;
            
        end
        
        
    end
   
end

end

%[row, col] = find(ismember(Imposter, max(Imposter(:))))

