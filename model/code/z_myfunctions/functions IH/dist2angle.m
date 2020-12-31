function [angle] = dist2angle(ijktab,a_number)

mindist     = min(abs(ijktab.dist - a_number));
qmindist    = abs(ijktab.dist - a_number) == mindist;
angle       = ijktab.angle(qmindist);
if numel(angle) == 2
    angle   = mean(angle);
end
