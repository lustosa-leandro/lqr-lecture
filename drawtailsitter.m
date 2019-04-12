function drawtailsitter( fig, pos, the, del )
%DRAWTAILSITTER Summary of this function goes here
%   Detailed explanation goes here

L = 0.07;

R = [ cos(the) -sin(the); sin(the) cos(the) ];

PROP1 = pos + R*[-L;L];
PROP2 = pos + R*[L;L];
FUSELAGE1 = pos + R*[0;L];
FUSELAGE2 = pos + R*[0;-L];
ELEVON1 = pos + R*[0;-L];
ELEVON2 = pos + R*[-L*sin(del);-L-L*cos(del)];

clearpoints(fig);

addpoints(fig, PROP1(1), PROP1(2));
addpoints(fig, PROP2(1), PROP2(2));
addpoints(fig, FUSELAGE1(1), FUSELAGE1(2));
addpoints(fig, FUSELAGE2(1), FUSELAGE2(2));
addpoints(fig, ELEVON2(1), ELEVON2(2));

drawnow;

end
