function setup = parametersSheena
% core model parameters
setup.eyeRotationCenter     = [0; -12.35];      % mm  [horizontal; axial], arbitrarily chosen as middle of axial length of eye
setup.corneaAnteriorRadii   = [7.7; 7.7];       % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.corneaPosteriorRadii  = [6.5; 6.5];       % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.corneaPosteriorDistance = 1.2;            % mm, axial, given in Young and Sheena (1975)
setup.pupilDistance         = 3.5;              % mm, distance in axial direction of pupil center from anterior surface of cornea. Given in Young and Sheena (1975)
setup.opticalAxisRotation   = 0;                % deg, Aguirre (2019) code notes that results from Navarro et al (2006) indicate that the optical axis of the eye is rotated slightly nasally (2.37 deg on average). I do not have the expertise to understand w.r.t. what this rotation is, and thus cannot assess whether it is relevant for us. It does not chnage the magnitude of the PSA, and thus i leave this to zero.

% test situation
setup.cameraDistance        = 530;              % mm

% just for plotting:
setup.irisOuterEdges        = 11.14/2*[-1 1];   % mm, value from Aguirre's (2019) code
setup.retinaRadii           = [10.6; 10.35];    % mm, [horizontal; axial] measured from eye model in Figure 44 of Young and Sheena (1975)
setup.scleraRadii           = [12; 11.75];      % mm, [horizontal; axial] measured from eye model in Figure 44 of Young and Sheena (1975)
setup.axialLength           = 24.7;             % mm, measured from eye model in Figure 44 of Young and Sheena (1975)
setup.lensFrontRadii        = [9.2; 9.2];       % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.lensFrontDistance     = 3.5;              % mm, distance in axial direction of pupil center from anterior surface of cornea. Given in Young and Sheena (1975)
setup.lensBackRadii         = [5.4; 5.4];       % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.lensBackDistance      = 7.6;              % mm, distance in axial direction of pupil center from anterior surface of cornea. Given in Young and Sheena (1975)

% refractive indices
% these are needed for the model:
setup.refractN.cornea       = 1.37;             % from Young and Sheena (1975)
setup.refractN.aqueous      = 1.33;             % from Young and Sheena (1975)
% these are just for plotting full eye
setup.refractN.lens         = 1.41;             % from Young and Sheena (1975)
setup.refractN.vitreous     = 1.33;             % from Young and Sheena (1975)
