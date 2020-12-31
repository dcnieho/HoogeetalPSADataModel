function intersection = intersectLineEllipse(start,vec,ellipseCent,ellipseRads,ellipseOri)
% from http://csharphelper.com/blog/2017/08/calculate-where-a-line-segment-and-an-ellipse-intersect-in-c/


% Translate the problem so the ellipse is centered at the origin.
start = start-ellipseCent;

% Rotate the problem so that ellipse's first radius is along X axis
Rmat = [cosd(ellipseOri) -sind(ellipseOri); sind(ellipseOri) cosd(ellipseOri)];
startR = Rmat'*start;
vec = Rmat'*vec;

% Get the semimajor and semiminor axes.
a = ellipseRads(1);
b = ellipseRads(2);

% Calculate the quadratic parameters.
A = vec(1)^2 / a^2 + vec(2)^2 / b^2;
B = 2 * startR(1) * vec(1) / a^2 + 2 * startR(2) * vec(2) / b^2;
C = startR(1)^2 / a^2 + startR(2)^2 / b^2 - 1;

% Calculate the discriminant.
discriminant = B^2 - 4 * A * C;
if discriminant==0
    t = -B / (2 * A);
elseif (discriminant > 0)
    t = (-B + [1 -1] * sqrt(discriminant)) / (2 * A);
else
    intersection = [];
    return;
end

% Convert the t values into vectors from line start.
segment = bsxfun(@times,t,vec);

% Rotate back
segment = Rmat*segment;

% translate back
intersection = bsxfun(@plus,start + ellipseCent, segment);
