%Number fraction 
y = i./length(i); 
%Area fraction 
y = cumsum(A./sum(A)); 
%Plotting 
plot(d,y); 

%Defining the number of bins. 
nrbins=35; 
%create logarithmic bins 
bins = logspace(log10(MINarea),log10(MAXarea),nrbins); 


%Stepping through the bin intervals 
%bins = upper bin limits in which the data will be grouped <= bins(i) 
 
for i = 1:length(bins) 
 
%searching for the indexes in the first bin and 
%calculating the sum within the bin range 
indexes = find(area<=bins(i)); 
Ni = length(indexes); 
Ai = sum(area(indexes)); 
 
%storing the values 
N = [N Ni]; 
A = [A Ai]; 
 
%removing the areas to the next loop 
area(indexes) = []; 
diameter(indexes) = []; 
 
end 
 
%Normalizing on the total area and number. 
N = N./sum(N); 
A = A./sum(A); 
 
%Calculating the bin centers. We don’t want to plot versus the upper binlimits 
%First we calculate the width of the bins. 
binwidths = [(bins(1)-0) bins(2:end)-bins(1:end-1)]; 
 
%then calculating the bincenters 
bincenters = [bins(1:end)-binwidths(1:end)./2];