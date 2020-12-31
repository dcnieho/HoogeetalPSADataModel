function [projPosLeft,projPosRight,pupPlanePosLeft,pupPlanePosRight] = IgnacePSARunner2(alpha,d,pl,pr,setup)

%% setup model
% 1. put input parameters in right place in setup
setup.cameraDistance    = d;
setup.eyeDirection      = alpha;

% 2. check input assumptions
assert(all(pl<=pr),'left pupil edges should be to the left (more negative) than right pupil edges')

% 3. position elements, etc.
geom                    = setupPhysicial(setup);


%% run model
% position inner iris borders
irisBordersPositions    = positionInnerIrisBorders(pl,pr,setup,geom,true);

% find ray to camera
iSectPoints             = rayFinder([irisBordersPositions.left(:,1) irisBordersPositions.right(:,1)],0,[geom.corneaPosteriorCenter geom.corneaAnteriorCenter],[setup.corneaPosteriorRadii setup.corneaAnteriorRadii],geom.opticalAxisOrientation([1 1]),[geom.refract.corneaAqueous geom.refract.airCornea],geom.cameraCenter);

% first column of output is intersection point of ray with first surface it
% meets. This is the posterior corneal surface, as we start our ray at the
% pupil edge. Second column is the intersection with the anterior corneal
% surface, which corresponds to the optical position of the pupil edge as
% seen by the camera. So select these points for further processing:
perceivedPupilPosOnCornea   = squeeze(iSectPoints(:,2,:));

% project perceived pupil positions (i.e. rays from cornea to camera) to
% camera's projection plane
projectedPositions      = getProjsAndCenter(geom.cameraCenter,perceivedPupilPosOnCornea);

%% output
projPosLeft  = projectedPositions(1);
projPosRight = projectedPositions(2);

%% output 2: extend external line onto pupil plane
% Coordinate system is the pupil plane, where 0 is on the optical axis
irisSz              = setup.irisOuterEdges(2)-setup.irisOuterEdges(1);
[~,t]               = intersectLines([irisBordersPositions.left(:,2) irisBordersPositions.right(:,2)],[geom.cameraCenter perceivedPupilPosOnCornea(:,1)]);
pupPlanePosLeft     = setup.irisOuterEdges(1)+t*irisSz;
[~,t]               = intersectLines([irisBordersPositions.left(:,2) irisBordersPositions.right(:,2)],[geom.cameraCenter perceivedPupilPosOnCornea(:,2)]);
pupPlanePosRight    = setup.irisOuterEdges(1)+t*irisSz;
