function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% ================================
% Part 1: Compute J

% Forward propagation
X = [ones(m,1) X];
z2 = X * Theta1';
a2 = sigmoid(z2);
a2 = [ones(m,1) a2];
z3 = a2 * Theta2';
hX = sigmoid(z3);

% Build encoded label array
yEncode = zeros(m,num_labels);
for i=1:m
    yEncode(i, y(i)) = 1;
endfor

% Compute costs element-wise
costs = -yEncode .* log(hX) - (1-yEncode) .* log(1 - hX);

Theta1Reg = Theta1(:,2:end) .^ 2;
Theta2Reg = Theta2(:,2:end) .^ 2;

reg = lambda * (sum(Theta1Reg(:)) + sum(Theta2Reg(:))) / 2;

J = (sum(costs(:)) + reg)/ m;

% -------------------------------------------------------------
% Part 2: Backprop


%Who needs a for loop???
gradSum1 = zeros(size(Theta1));
gradSum2 = zeros(size(Theta2));

d3 = hX - yEncode;
d2 = (Theta2' * d3')' .* sigmoidGradient([ones(m,1) z2]);
gradSum1 = d2(:,2:end) ' * X;
gradSum2 = d3' * a2;


%Kept in case someone needs a for loop
%for t=1:m

    %Forward prop
%    a1m = X(t,:);
%    z2m = a1m * Theta1';
%    a2m = [1 sigmoid(z2m)];
%    z3m = a2m * Theta2';
%    a3m = sigmoid(z3m);

    %Delta calculation
%    d3 = a3m - yEncode(t,:);
%    d2 = (Theta2' * d3')' .* [1 sigmoidGradient(z2m)];

    %Sum gradients
%    gradSum1 = gradSum1 + (d2(2:end)' * a1m);
%    gradSum2 = gradSum2 + (d3' * a2m);

%endfor

Theta1_grad = gradSum1 / m;
Theta2_grad = gradSum2 / m;

%Regularize gradient
reg1 = (lambda / m) * Theta1;
reg2 = (lambda / m) * Theta2;
reg1(:,1) = 0;
reg2(:,1) = 0;
Theta1_grad = Theta1_grad + reg1;
Theta2_grad = Theta2_grad + reg2;

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
