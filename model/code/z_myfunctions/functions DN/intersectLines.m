function [intersect,t,s] = intersectLines(l1,l2)
% https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
% l1 and l2 each contain a line. These lines are defined by two points on
% them, but are treated as infinite lines
% s1 is 2x2 matrix with start and end laid out over columns
% s2 is 2xn matrix with multiple line segments laid out over columns, each
% end of a segment is start of the next segment as well

s1 = diff(l1,[],2);
s2 = diff(l2,[],2);

denom = (-s2(1,:) .* s1(2) + s1(1) .* s2(2,:));
t = (s2(1,:) .* (l1(2,1) - l2(2,1:end-1)) - s2(2,:) .* (l1(1,1) - l2(1,1:end-1))) ./ denom;
if nargout>2
    % check where on other segment as well
    s = (-s1(2) .* (l1(1,1) - l2(1,1:end-1)) + s1(1) .* (l1(2,1) - l2(2,1:end-1))) ./ denom;
end
intersect = bsxfun(@plus,l1(:,1),bsxfun(@times,t,s1));
