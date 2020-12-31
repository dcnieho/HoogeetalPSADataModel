function geom = setupPhysicial(setup)

geom.opticalAxisOrientation = setup.eyeDirection+setup.opticalAxisRotation;

angForRotMat                = -geom.opticalAxisOrientation; % negative is counterclockwise for us, not clockwise
Rmat                        = [cosd(angForRotMat) -sind(angForRotMat); sind(angForRotMat) cosd(angForRotMat)];
% cornea
geom.corneaAnteriorCenter   = Rmat*([0;                               -setup.corneaAnteriorRadii(2) ]-setup.eyeRotationCenter)+setup.eyeRotationCenter;
geom.corneaPosteriorCenter  = Rmat*([0; -setup.corneaPosteriorDistance-setup.corneaPosteriorRadii(2)]-setup.eyeRotationCenter)+setup.eyeRotationCenter;

% pupil reference point
geom.pupilReferencePoint    = Rmat*([0; -setup.pupilDistance]-setup.eyeRotationCenter)+setup.eyeRotationCenter;

% nodal points
if isscalar(setup.corneaAnteriorRadii) || setup.corneaAnteriorRadii(1)==setup.corneaAnteriorRadii(2)
    geom.nodalFirst         = geom.corneaAnteriorCenter;
else
    c                       = sqrt(setup.corneaAnteriorRadii(2)^2-setup.corneaAnteriorRadii(1)^2);
    geom.nodalFirst         = geom.corneaAnteriorCenter+Rmat*c*[0 1].';
end
if isscalar(setup.corneaPosteriorRadii) || setup.corneaPosteriorRadii(1)==setup.corneaPosteriorRadii(2)
    geom.nodalSecond        = geom.corneaPosteriorCenter;
else
    c                       = sqrt(setup.corneaPosteriorRadii(2)^2-setup.corneaPosteriorRadii(1)^2);
    geom.nodalSecond        = geom.corneaPosteriorCenter+Rmat*c*[0 1].';
end

% camera
geom.cameraCenter           = [0; setup.cameraDistance];

% prep effective refraction index at optical surfaces
% air (N=1) -> cornea
geom.refract.airCornea      = setup.refractN.cornea/1;
% cornea -> aqueous
geom.refract.corneaAqueous  = setup.refractN.aqueous/setup.refractN.cornea;
