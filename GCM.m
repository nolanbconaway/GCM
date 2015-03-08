function probability = GCM(model)
% ------------------------------------------------------------------------
% This function simulates the generalized context model (GCM; Nosofsky, 
% 1984, 1986), given the design specified in the function's sole argument. 
% 
% 'model' is a struct which must include:
%    specificity       exemplar response tuning parameter. (0 < specificity
%                      < Inf)
%    attentionweights  Vector of feature weights (should sum to 1)
%    distancemetric    basis for similarity function. Must be 'cityblock' 
%                      or 'euclidean'
%    exemplars         matrix of stored exemplars. Each row is a separate
%                      pattern, each column is a feature.
%    memorystrength    Matrix of memory strengths signaling each exemplar's
%                      association to each category. Each row corresponds
%                      to an exemplar, and each column to a category. Rows
%                      should sum to 1.
% 
% The user may also supply these optional arguments in 'model':
%    inputs            Matrix of coordinates used to evaluate GCM's
%                      predictions. By default the training exemplars are
%                      used.
%    responsemapping   Phi (gamma) parameter adjusting response determinism
%                      (0 < responsemapping < Inf). Default: 1.
% 
% The function will return:
%     probability       classification probabilities for each item in the
%                       inputs, at each category (Input X Category).
% ------------------------------------------------------------------------

% unpack input struct
v2struct(model)
result =  struct;

%******************** Declaration of Global Variables ********************%
%-------------------------------------------------------------------------%
numexemplars    = size(exemplars,1);
numcategories = size(memorystrength,2);

% set up model inputs
if ~exist('inputs','var')
    inputs = exemplars;
end
numinputs = size(inputs,1);

% set up distance function
if strcmp(distancemetric,'cityblock')
    r = 1;
elseif strcmp(distancemetric,'euclidean')
    r = 2;
else error('ERROR: Distance metric must be "cityblock" or "euclidean".')
end    

% scale attention to sum = 1
attentionweights = attentionweights./sum(attentionweights);
attentionweights = repmat(attentionweights,[numexemplars,1]);

% scale memory strengths so each row sums to 1.
memorystrength = memorystrength ./ ...
	repmat(sum(memorystrength,2),[1,numcategories]);


% set up response mapping constant
if ~exist('responsemapping','var')
	responsemapping = 1;
end

%***************************** Run Simulation ****************************%
%-------------------------------------------------------------------------%
% get weighted similarity of all inputs to all exemplars
distances = zeros(numinputs,numexemplars);
for i = 1:numinputs
    d = abs(repmat(inputs(i,:),[numexemplars,1]) - exemplars) .^ r;
    d = sum(d.* attentionweights,2);
    distances(i,:) = d .^ (1/r);    
end

% Similarity is an inverse exponential function of distance, following
% Shepard's (1957,1987) universal law of generalization.
similarity = exp(-specificity .* distances);

% Multiply similarity values against memory strengths. 
% This calculation returns activation of each category given each input.
categoryactivation = similarity * memorystrength;

% apply response mapping (gamma, phi) parameter, as per Nosofsky & Zaki
% (2002)
categoryactivation = categoryactivation .^ responsemapping;

% calculate classification probabilities via Luce's (1963) choice rule
probability = categoryactivation ./ ...
	repmat(sum(categoryactivation,2), [1,numcategories]);

end