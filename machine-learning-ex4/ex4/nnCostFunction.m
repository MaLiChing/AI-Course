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
                 
%size(Theta1) 25*401
%size(Theta2) 10*26

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

K = num_labels;

a1 = [ones(m, 1) X];  % Add ones to the X data matrix for a1's bias unit
z2 = a1*Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2]; % add a2's bias unit
z3 = a2*Theta2';
a3 = sigmoid(z3);     % a3 = h(x)
hx = a3;              % 5000*10

%Temp = [ones(m,1) 2*ones(m,1) 3*ones(m,1) 4*ones(m,1) 5*ones(m,1) 6*ones(m,1) 7*ones(m,1) 8*ones(m,1) 9*ones(m,1) 10*ones(m,1)];
%Temp = Temp(:,1:K);
for i=1:K
  Temp(:,i)=i*ones(m,1);
end
%yk=(Temp==y); mx_el_eq issue on V3.8.0
yk=bsxfun(@eq,Temp,y);% Recode the labels as vectors containing only values 0 or 1

Theta1_SumOfSquares = sum(sum(Theta1(:, (2:end)).^2));
Theta2_SumOfSquares = sum(sum(Theta2(:, (2:end)).^2));

J = sum( sum( -yk.*log(hx) - (1-yk).*log(1-hx) ) )/m + lambda*( Theta1_SumOfSquares + Theta2_SumOfSquares )/(2*m);


% BP START
ev3 = a3 - yk; %5000*10
ev2 = ev3*Theta2(:, (2:end)).*sigmoidGradient(z2); %5000*25

delta1 = zeros(size(Theta1));
delta2 = zeros(size(Theta2));
delta1 = ev2'*a1; %25*401
delta2 = ev3'*a2; %10*26

%delta1 = ev2'*a1; %25*401
%delta2 = ev3'*a2; %10*26

D1 = zeros(size(delta1));
D1(:,1)= delta1(:,1)/m; 
D1(:, (2:end)) = delta1(:, (2:end))/m + (lambda*Theta1(:, (2:end)))/m;
 
D2 = zeros(size(delta2)); 
D2(:,1)= delta2(:,1)/m; 
D2(:, (2:end)) = delta2(:, (2:end))/m + (lambda*Theta2(:, (2:end)))/m;
% BP END

Theta1_grad = D1;
Theta2_grad = D2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
