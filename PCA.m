function [Y,Z,E] = PCA(X,dim,centering)
%
% Principal component analysis
% This function supports both PCAs with and without data centering.
%
% Coded by D. Kitamura (d-kitamura@ieee.org)
%
% See also:
% http://d-kitamura.net
%
% [syntax]
%   [Y,Z,E] = PCA(X)
%   [Y,Z,E] = PCA(X,dim)
%   [Y,Z,E] = PCA(X,dim,centering)
%
% [inputs]
%          X: input data ( K (variables) x N (samples) )
%        dim: number of dimensions to which X is projected
%  centering: centering X before applying PCA or not (true or false, default: true)
%
% [outputs]
%          Y: output matrix (dim x N)
%          Z: transformation matrix (dim x K, Y = ZX)
%          E: all eigenvectors (K x K)

% Check errors and set default values
if (nargin < 3)
    centering = true; % Default setting
end

[K,N] = size(X); % variables x samples
if centering
    cX = X - mean(X,2); % Data centering (using implicit expansion)
%     cX = X - repmat(mean(X,2),1,N); % Data centering (prior to R2016b)
else
    cX = X; % Do not apply centering
end
V = cX*(cX')/N; % Covariance matrix of data matrix
[P,D] = eig(V); % Eigenvalue decomposition (V = P*D*inv(P), P includes eigenvectors and D is a diagonal matrix with eigenvalues)

% Sort eigenvalues in descending order
eigVal = diag(D);
[eigVal,idx] = sort(eigVal,'descend');
D = D(idx,idx);
P = P(:,idx);

% Pick up top-dim eigenvalues and their eigenvectors
reducedD = D(1:dim,1:dim);
reducedP = P(:,1:dim); 

Y = reducedP'*cX; % Output matrix
Z = reducedP'; % Transformation matrix
E = P'; % All eigenvectors
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%