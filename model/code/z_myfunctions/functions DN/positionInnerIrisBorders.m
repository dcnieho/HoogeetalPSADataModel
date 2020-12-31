function [irisBorders] = positionInnerIrisBorders(leftEdge,rightEdge,setup,geom,qFarAlso)

if qFarAlso
    distsL = [ leftEdge setup.irisOuterEdges(1)];
    distsR = [rightEdge setup.irisOuterEdges(2)];
else
    distsL = leftEdge;
    distsR = rightEdge;
end

% place points in model space
irisBorders.left    = placeIrisPoint(distsL, geom.pupilReferencePoint, geom.opticalAxisOrientation);
irisBorders.right   = placeIrisPoint(distsR, geom.pupilReferencePoint, geom.opticalAxisOrientation);

% determine which is far and which is near edge (far is on the side the eye
% is rotated towards, since that edge is further from the camera under that
% rotation)
if geom.opticalAxisOrientation>0
    irisBorders.near    = irisBorders.left;
    irisBorders.far     = irisBorders.right;
else
    irisBorders.near    = irisBorders.right;
    irisBorders.far     = irisBorders.left;
end
