function [ A,B,C,D ] = hovermodel(  )
%HOVERMODEL Summary of this function goes here
%   Detailed explanation goes here

%% tailsitter model set-up
% x = [x y vx vy the w] in R6
% u = [wi del] in R2

T0 = 10;
Kmom = 25;
Kfor = 20;

% model memory alloc
A = zeros(6,6);
B = zeros(6,2);
C = eye(6);
D = zeros(6,2);

% position derivative
A(1:2,3:4) = eye(2);
% velocity derivative
A(3:4,5) = [-T0;0];
% pitch derivative
A(5,6) = 1;
% angular velocity derivative
%   no presence in A!

% actuators model
B(4,1) = Kfor;
B(6,2) = Kmom;

end

