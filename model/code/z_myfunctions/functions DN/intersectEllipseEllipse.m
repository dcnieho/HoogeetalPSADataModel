function [intersections,angles1,angles2] = intersectEllipseEllipse(ellipseCent1,ellipseRads1,ellipseOri1,ellipseCent2,ellipseRads2,ellipseOri2)
% as ellipse-ellipse intersection is a very complicated problem, we do it
% numerically here. 

% 1. generate vertices of ellipse 1 (reference) that we'll test against for
% intersection. We first generate also a bunch of vertices for ellipse 2,
% as seed to find intervals where intersections occur. We assume there are
% not multiple intersections very close together (less than 1 deg rotation
% along second ellipses surface)

% generate the ellipses
dirs        = [0:360];
refPoints   = getEllipseVertices(dirs,ellipseCent1,ellipseRads1,ellipseOri1);
testPoints  = getEllipseVertices(dirs,ellipseCent2,ellipseRads2,ellipseOri2);

% see where test intersections with ref, if anywhere along the segment
intersections = getIntersections(refPoints,testPoints,dirs,dirs);

% now refine each intersection a few times
nRefine = 3;
for p=1:nRefine
    for q=1:4
        if isnan(intersections(1,q))
            continue;
        end
        dirs1       = linspace(intersections(3,q),intersections(4,q),360);
        dirs2       = linspace(intersections(5,q),intersections(6,q),360);
        refPoints   = getEllipseVertices(dirs1,ellipseCent1,ellipseRads1,ellipseOri1);
        testPoints  = getEllipseVertices(dirs2,ellipseCent2,ellipseRads2,ellipseOri2);
        its         = getIntersections(refPoints,testPoints,dirs1,dirs2);
        intersections(:,q) = its(:,1);
    end
end

% finally, extract angle at which intersection point occurs for each
% ellipse
[angles1,angles2] = deal(nan(1,4));
for q=1:4
    if isnan(intersections(1,q))
        continue;
    end
    angles1(q) = getAngle(intersections(1:2,q),ellipseCent1,ellipseRads1,ellipseOri1);
    angles2(q) = getAngle(intersections(1:2,q),ellipseCent2,ellipseRads2,ellipseOri2);
end

% clean up output
qNaN = isnan(angles1);
intersections(:,qNaN) = [];
intersections(3:end,:) = [];
angles1(qNaN) = [];
angles2(qNaN) = [];


function verts = getEllipseVertices(dirs,center,rads,orientation)
Rmat    = [cosd(orientation) -sind(orientation); sind(orientation) cosd(orientation)];
verts   = bsxfun(@times,rads(:),[cosd(dirs); sind(dirs)]);
verts   = bsxfun(@plus,Rmat*verts,center);

function intersections = getIntersections(el1,el2,dirs1,dirs2)
intersections   = nan(6,4); % there can be up to 4 intersections
i = 1;
for p=1:size(el2,2)-1
    [int,t,s] = intersectLines(el2(:,p+[0 1]),el1);
    j = find(t>=0 & t<=1 & s>=0 & s<=1);
    if ~isempty(j)
        intersections(1:2,i) = int(:,j);
        intersections(3:4,i) = dirs1(j+[0 1]);
        intersections(5:6,i) = dirs2(p+[0 1]);
        i = i+1;
    end
end


function angle = getAngle(point,center,rads,orientation)
Rmat  = [cosd(orientation) -sind(orientation); sind(orientation) cosd(orientation)];
point = Rmat'*(point-center)./rads(:);
angle = atan2(point(2),point(1))/pi*180;
