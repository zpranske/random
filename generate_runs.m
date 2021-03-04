%%  GENERATE RUNS
%   Used to generate all unique pairings of animals for block design experiment
%   Constraints:
%       1. A rat cannot run 2x in a row on same side
%       2. A rat cannot run 3x in a row
%       3. A rat cannot run more than x% of trials on the same side
%           (user-defined, see side_balance_coef below)

n_seqs = 1; %Number of sequences desired
n_animals = 4; %Runtime is O(n!), practical limit ~8 animals
side_balance_coef = .7; %Max percent of runs a rat can do on the same side

n_pairs = nchoosek(n_animals,2);
list = [];

 while(size(list,3)<n_seqs+1)
    flag = false;
    
    % Generate sequence
    %Get all combinations of animals in order
    v = 1:n_animals;
    seq = nchoosek(v,2);
    seq = seq(randperm(size(seq, 1)), :); %Shuffle rows
    
    %Shuffle columns in each row
    for k=1:n_pairs
        tmp = seq(k,:);
        tmp = tmp(randperm(length(tmp)));
        seq(k,:) = tmp;       
    end
    
    %Throw out list if a rat runs the same side twice in a row
    for j=1:n_pairs-1
        if seq(j,1)==seq(j+1,1) || seq(j,2)==seq(j+1,2)
            flag = true;
        end
    end
    
    % Make sure no rat runs 3 times in a row -- 
    % if either member of a pair appears in the next 2 pairs
    for j=1:n_pairs-2
        n1 = seq(j,1);
        n2 = seq(j,2);

        if ismember(n1,seq(j+1,:)) && ismember(n1,seq(j+2,:))
            flag = true;
        end
        if ismember(n2,seq(j+1,:)) && ismember(n2,seq(j+2,:))
            flag = true;
        end
    end
    %Throw out list if a rat runs the same side three times
      for j=1:n_animals
          max = side_balance_coef*(n_animals-1); %Where n_animals-1 is number of times each animal runs
          if(sum(seq(:,1)==j)>max) || (sum(seq(:,2)==j)>max)
              flag = true;
          end
      end
    
    if ~flag
        list(:,:,end+1) = seq;
    end
 end
 
 for i=2:size(list,3)
     disp(list(:,:,i));
 end
 
 disp('Done! Number of sequences generated: ')
 disp(size(list,3)-1)