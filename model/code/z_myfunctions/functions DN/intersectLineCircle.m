function [intSegment] = intersectLineCircle(start,vec,circCent,circRad)

A = sum(vec.^2);
B = 2 * (vec(1) * (start(1) - circCent(1)) + vec(2) * (start(2) - circCent(2)));
C = (start(1) - circCent(1))^2 + (start(2) - circCent(2))^2 - circRad^2;

t = (-B + [1 -1] * sqrt(B^2 - 4 * A * C)) / (2 * A);
intSegment = bsxfun(@plus,bsxfun(@times,t,vec),start);
