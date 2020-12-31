function [proj,projCent] = getProjsAndCenter(cameraCenter,pos)

% get camera-relative position
relPos      = bsxfun(@minus,cameraCenter,pos);
% project
proj        = relPos(1,:)./relPos(2,:);
% negative corresponds to left-ward in the world, seen from the _eye_'s
% direction. This projection is done on an image taken from the camera's
% view. So we should flip to remain in the eye's coordinate system. Hence
% the minus below
proj        = -1.*proj;

projCent    = [];
if size(proj,2)>1 && mod(size(proj,2),2)==0
    projCent   = mean([proj(1:end/2); proj(end/2+1:end)],1);
end
