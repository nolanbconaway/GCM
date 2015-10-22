function D = pairdist(A, B, METRIC, varargin)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Description: 
% 	This function computes the cityblock or euclidean distance 
% 	between the rows of A and B. An optional parameter, WTS, can be 
% 	provided to differentially weigh the columns of A and B in the 
% 	calculation of distance. WTS must be a row vector that should sum
%	to 1, though this is not a hard constraint.  A. B, and WTS must 
%	have the same number of columns.
% 
% Usage:
%	A = [ 1 2
%	      3 4 ];
% 
%	B = [ 2 2
%	      4 3
%	      1 3 ];
% 
%	% Get unweighted cityblock distance
% 	pairdist(A,B,'cityblock')
% 	ans =
% 		 1     4     1
% 		 3     2     3
%	
%	% Weigh euclidean distance only on column 1
% 	wts = [1 0];
% 	pairdist(A,B,'euclidean',wts)
% 	ans =
% 		 1     3     0
% 		 1     1     2
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% 	--------------------------------------------------
	% confirm that the data sizes all match up
	if ~isequal(size(A,2),size(B,2))
		error('A and B must have the same number of columns.')
	end
	
% 	--------------------------------------------------
	% Deal with WTS, if it was provided
	if ~isempty(varargin)
		WTS = varargin{1};
		
		% confirm weights are the correct size
		if ~isequal(size(A,2),size(WTS,2))
			error('A and B, and WTS must have the same number of columns.')
		end
		if size(WTS,1)>1
			error('WTS must be a row vector.')
		end
		
	else
		WTS = ones(1,size(A,2));
	end

% 	--------------------------------------------------
	% Compute pairwise distances
	if strcmp(METRIC,'cityblock')
		% This code is based on a StackOverflow reponse:
		%	http://stackoverflow.com/a/33247023/3521179
		
		% Calculate absolute element-wise subtractions
		absm = abs(bsxfun(@minus,permute(A,[1 3 2]),permute(B,[3 1 2])));		
		
		% Perform matrix multiplications with the given weights and reshape
		D = reshape(reshape(absm,[],size(A,2))*WTS(:),size(A,1),[]);
		
    elseif strcmp(METRIC,'euclidean')
		
		% this code is based on a blog post:
		%	http://trunghuyduong.blogspot.com/2011/09/pair-wise-weighted-euclidean-distance.html
		
		% get sqrt of WTS
		WTS = sqrt(WTS); 
		
		% modify A and B against weight values
		A = WTS(ones(1,size(A,1)),:).*A;
		B = WTS(ones(1,size(B,1)),:).*B; 
		
		% calculate distance
		AA = sum(A.*A,2);  
		BB = sum(B.*B,2)'; 
		D = sqrt(AA(:,ones(1,size(B,1))) + BB(ones(1,size(A,1)),:) - 2*A*B'); 

	else error('Function only accepts "cityblock" and "euclidean" distance')
	end
end