function [iSectPoint,intSegment,extSegment,normal] = intersectAndRefractRay(start,vecDir,ellipseCents,ellipseRadiis,ellipseOrientations,whichIsects,refractNs,targetZ,doDebugPlots)

if isempty(whichIsects)
    whichIsects = ones(size(ellipseOrientations));
end
if nargin<9 || isempty(doDebugPlots)
    doDebugPlots = false;
end

[iSectPoint,intSegment,extSegment,normal] = deal(nan(size(ellipseCents)));

for p=1:size(ellipseCents,2)
    ellipseCent         = ellipseCents(:,p);
    ellipseRadii        = ellipseRadiis(:,p);
    ellipseOrientation  = -ellipseOrientations(p);  % negate orientation because negative is counterclockwise for us, not clockwise
    whichIsect          = whichIsects(p);
    refractN            = refractNs(p);
    
    if p==1
        inVec   = [-sind(vecDir); cosd(vecDir)];
    else
        start   = iSectPoint(:,p-1);
        inVec   = outVec;
    end
    
    
    if isscalar(ellipseRadii) || ellipseRadii(1)==ellipseRadii(2)
        % find intersection point with circle
        iSectPoint_ = intersectLineCircle(start,inVec,ellipseCent,ellipseRadii(1));
    else
        % find intersection point with ellipse
        iSectPoint_ = intersectLineEllipse(start,inVec,ellipseCent,ellipseRadii,ellipseOrientation);
    end
    
    % take the right intersection point
    iSectPoint(:,p) = iSectPoint_(:,whichIsect);
    
    % make relative to start point
    intSegment(:,p) = iSectPoint(:,p)-start;
    
    
    % get circle/ellipse normal at intersection point
    if isscalar(ellipseRadii) || ellipseRadii(1)==ellipseRadii(2)
        % circle, thats simple, just line pointing out from center
        normal_         = iSectPoint(:,p)-ellipseCent;
        startingOutside = hypot(start(1)-ellipseCent(1),start(2)-ellipseCent(2)) > ellipseRadii(1);
    else
        % ellipse
        relPos          = (iSectPoint(:,p)-ellipseCent);
        normal_         = relPos.*[1; ellipseRadii(1)/ellipseRadii(2)];
        startingOutside = (cosd(ellipseOrientation)*(start(1)-ellipseCent(1))+sind(ellipseOrientation)*(start(2)-ellipseCent(2)))^2/ellipseRadii(1)^2 + (sind(ellipseOrientation)*(start(1)-ellipseCent(1))-cosd(ellipseOrientation)*(start(2)-ellipseCent(2)))^2/ellipseRadii(2)^2 > 1;
    end
    normal(:,p) = normal_/norm(normal_);
    % if we start outside the object, flip normal
    if startingOutside
        normal(:,p) = -normal(:,p);
    end
    
    cost        = dot(normal(:,p),inVec);
    
    % get direction of out vector
    outVec = refractN*inVec+(refractN*cost-sqrt(1-refractN^2*(1-cost^2)))*-normal(:,p);
    
    if doDebugPlots
        plot(iSectPoint(1,p)-[0 inVec(1)],iSectPoint(2,p)-[0 inVec(2)],'g-')
        plot(iSectPoint(1,p)-[0 normal(1,p)],iSectPoint(2,p)-[0 normal(2,p)],'b-')
        plot(iSectPoint(1,p)+[0 outVec(1)]  ,iSectPoint(2,p)+[0 outVec(2)],'r-')
        % reflection vector: NB: something seems wrong with it, but we
        % don't need it
        % reflec(:,p) = inVec + 2*cost*normal(:,p); 
        % plot(iSectPoint(1,p)-[0 reflec(1,p)],iSectPoint(2,p)-[0 reflec(2,p)],'c-')
    end
end

% turn into segment reaching to camera's Z-position
if nargin>7 && ~isempty(targetZ)
    t = (targetZ-iSectPoint(2,p))/outVec(2);
else
    % make unit vector
    t = 1;
end
extSegment(:,p) = t*outVec;

for p=1:size(ellipseCents,2)-1
    extSegment(:,p) = intSegment(:,p+1);
end
