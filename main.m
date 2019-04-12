
%% animation set-up
FIG_LENGTH = 1; % figure fixed axis in meters
h = animatedline;
axis([-FIG_LENGTH,FIG_LENGTH,-FIG_LENGTH,FIG_LENGTH]);

%% drawing a demo
a = tic; % start timer
i = 0;
while (1)
    b = toc(a); % check timer
    if (b > 1/30) % refresh screen period
        drawtailsitter(h,[i*1/30;0],30*pi/180,30*pi/180);
        a = tic; % reset timer after updating     
        i = i+1;
    end
    if (i>30)
        break
    end
end
