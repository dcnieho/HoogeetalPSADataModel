function [iSectPoint,intSegment,extSegment,normal] = rayFinder(start,vecDir,ellipseCent,ellipseRads,ellipseOrientation,refractN,target)

if size(start,2)>1 && isscalar(vecDir)
    vecDir = repmat(vecDir,1,size(start,2));
end

% optimize until vertical distance of outSegment end from cameraCenter is minimal
for r=size(start,2):-1:1
    calcFunc    = @(x) intersectAndRefractRay(start(:,r),x,ellipseCent,ellipseRads,ellipseOrientation,[],refractN,target(2));
    optimFunc   = @(x) errorCalc(x,calcFunc,target);
    
    correctDir = fminsearch(optimFunc,vecDir(r),optimset('TolX',10e-10));
    [iSectPoint(:,:,r),intSegment(:,:,r),extSegment(:,:,r),normal(:,:,r)] = calcFunc(correctDir);
end

function distance = errorCalc(vecDir,func,target)
[segmentOrigin,~,segment] = func(vecDir);
err = target-(segmentOrigin(:,end)+segment(:,end));
distance = abs(err(1)); % horizontal distance only, ray is constructed such that axial distance is 0
