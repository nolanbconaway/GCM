%  ---------------------------------------------------------------------  %
%  This script simply uses the GCM to generate classification predictions
%  for the classic 5-4 categories (Medin & Schaffer, 1978) at a set of
%  user-provided model parameters. 
% 
%  The attention weights used below are the optimal weights as calculated 
%  by Nosofsky (1984).
%  ---------------------------------------------------------------------  %
close;clear;clc

% set up search path
addpath([pwd '/utils/'])

% initialize model struct
model = struct;

%  ---------------------------------------------------------------------  %
%  SET UP MODEL DESIGN (PARAMETERS, ATTENTION, DISTANCE METRIC)
%  ---------------------------------------------------------------------  %
  model.specificity		 = 2; % specificity tuning (c) parameter
  model.responsemapping	 = 1; % response bias (phi) parameter
  model.distancemetric	 = 'cityblock'; % 'cityblock' or 'euclidean'

  % vector of feature weights (should sum to 1)
  model.attentionweights = [0.3187    0.0712    0.3006    0.3095]; 

%  ---------------------------------------------------------------------  %
%  SET UP MODEL INPUT (EXEMPLARS, LABELS, TRANSFER)
%  ---------------------------------------------------------------------  %
% a matrix of training exemplars, used as the basis for the kernel
% similarity function
model.exemplars = [	 1	 1	 1	-1
					 1	-1	 1	-1
					 1	-1	 1	 1
					 1	 1	-1	 1 
					-1	 1	 1	 1
					 1	 1	-1	-1
					-1	 1	 1	-1
					-1	-1	-1	 1
					-1	-1	-1	-1];
				
% Memory strengths signaling each exemplars association to each category.
model.memorystrength = [1 0
	                    1 0
						1 0
	                    1 0
						1 0
	                    0 1
						0 1
						0 1
						0 1];

% a set of items to evaluate classification probabilities at
model.inputs = [model.exemplars;
				 1	-1	-1	 1
				 1	-1	-1	-1
				 1	 1	 1	 1
				-1	-1	 1	-1 
				-1	 1	-1	 1
				-1	-1	 1	 1
				-1	 1	-1	-1];

%  ---------------------------------------------------------------------  %
%  RUN SIMULATION AND PLOT RESULTS
%  ---------------------------------------------------------------------  %
% run simulation
probabilities = GCM(model);

figure
plot(probabilities(:,1),'k-s','linewidth',2,'markerfacecolor','k')
v=axis;
v(1:2) = [0.5, size(model.inputs,1)+0.5];
v(3:4)= [0 1];
axis(v)
set(gca,'xtick',1:size(model.inputs,1),...
	'linewidth',2,'box','on','ygrid','on','fontsize',15)
xlabel('Stimulus')
ylabel('Category A Probability')