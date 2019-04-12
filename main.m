
%% tailsitter model set-up
% x = [x y vx vy the w] in R6
% u = [wi del] in R2

T0 = 10;
Kmom = 25; %0.01*0.25e4;
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

% build state space system
sys = ss(A,B,C,D);

%% design a LQR controller for this system
Q = diag([1/(0.1)^2 1/(0.1)^2 1/(0.4)^2 1/(0.4)^2 0*1/(0.8)^2 0*1/(4)^2]);
R = 10*diag([1/(5)^2 1/(0.4)^2]);
K = lqr(A,B,Q,R);
sys_closed = ss(A-B*K,0*B,C,D);

%% simulate the system to a given initial condition

t = 0:0.01:3;
u = zeros(length(t),2);
x0 = zeros(6,1);
x0(1:2) = [0.2; 0.2];
x0(5) = 0.4;
[y,t,x] = lsim(sys_closed,u,t,x0);
u = (-K*x')';

%% plot results
figure;
% position
subplot(6,2,1);
plot(t,x(:,1));
ylabel('hor. pos. (m)');
subplot(6,2,3);
plot(t,x(:,2));
ylabel(' vert. pos. (m)');
% velocity
subplot(6,2,5);
plot(t,x(:,3));
ylabel('hor. vel. (m/s)');
subplot(6,2,7);
plot(t,x(:,4));
ylabel('vert. vel. (m/s)');
% pitch angle
subplot(6,2,9);
plot(t,x(:,5)*180/pi);
ylabel('angle (deg)');
% angular velocity
subplot(6,2,11);
plot(t,x(:,6)*180/pi);
ylabel('ang. vel. (deg/s)');
xlabel('time (s)');
% actuator thrust
subplot(6,2,2);
plot(t,u(:,1));
ylabel('thrust (N)');
% elevon deflection
subplot(6,2,4);
plot(t,u(:,2)*180/pi);
ylabel('elevon (deg)');

%% animation set-up
FIG_LENGTH = 1; % figure fixed axis in meters
figure;
h = animatedline;
axis([-FIG_LENGTH,FIG_LENGTH,-FIG_LENGTH,FIG_LENGTH]);

%% drawing a demo
a = tic; % start timer
i=1;
while (1) 
    b = toc(a); % check timer
    if (b > 0.01) % refresh screen period
        drawtailsitter(h,x(i,1:2)',x(i,5),u(i,2));
        a = tic; % reset timer after updating     
        i=i+1;
        if (i>length(t))
            break;
        end
    end
end
