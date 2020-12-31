function setup = parametersAguirre
% core model parameters
setup.eyeRotationCenter     = [0.79; -14.7];        % mm  [horizontal; axial], from code of Aguirre (2019), who attributes his numbers to Hill & Fry (1962, 1963)
setup.corneaAnteriorRadii   = [10.43; 14.26];       % mm, [horizontal; axial] radii from Aguirre (2019)
setup.corneaPosteriorRadii  = [9.3027; 13.7716];    % mm, [horizontal; axial] radii from Aguirre (2019)
setup.corneaPosteriorDistance = 0.55;               % mm, axial, from Aguirre (2019)
setup.pupilDistance         = 3.6;                  % mm, distance in axial direction of pupil center from anterior surface of cornea from Drexler (1997). We ignore that the inner iris border rides along the anterior surface of the lens, and thus that pupil's distance from eye's outer nodal point (center or cornea) change as pupil dilates and constricts
setup.opticalAxisRotation   = 0;                    % deg, Aguirre (2019) code notes that results from Navarro et al (2006) indicate that the optical axis of the eye is rotated slightly nasally (2.37 deg on average). I do not have the expertise to understand w.r.t. what this rotation is, and thus cannot assess whether it is relevant for us. It does not chnage the magnitude of the PSA, and thus i leave this to zero.

% test situation
setup.cameraDistance        = 530;                  % mm

% just for plotting:
setup.irisOuterEdges        = 11.14/2*[-1 1];       % mm, horizontal, value from Aguirre's (2019) code
setup.retinaRadii           = [11.455; 10.148];     % mm, [horizontal; axial] for an emmetrope. Values from Atchison (2006), as given in code of Aguirre (2019)
setup.scleraRadii           = [11.455; 10.148]+1.4; % mm, [horizontal; axial] take Aguirre's retina radii, add 1.4 mm as measured from Young and Sheena (1975, Figure 44) for distance from retina to sclera
setup.axialLength           = 23.58;                % mm, axial length of the whole eye. As given in code of Aguirre (2019), who derived from Atchison (2006) for emmetropic eye
setup.lensFrontRadii        = [9.2; 9.2];           % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.lensFrontDistance     = 3.6;                  % mm, distance in axial direction of pupil center from anterior surface of cornea. Given in Young and Sheena (1975), adjusted for Drexler's axial pupil position
setup.lensBackRadii         = [5.4; 5.4];           % mm, [horizontal; axial] given in Young and Sheena (1975)
setup.lensBackDistance      = 7.6;                  % mm, distance in axial direction of pupil center from anterior surface of cornea. Given in Young and Sheena (1975)

% refractive indices
waveLength                  = 890;                  % nm, EyeLink illuminator
% these are needed for the model:
c                           = [1.362994, 6.009687e3, -6.760760e8, 5.908450e13];
setup.refractN.cornea       = cauchy(c,waveLength);
c                           = [1.323031, 6.070796e3, -7.062305e8, 6.147861e13];
setup.refractN.aqueous      = cauchy(c,waveLength);
% these are just for plotting full eye
age                         = 40;                   % roughly middle of age range of our subjects
A                           = 1.40965 + (3.55e-4 * age) - (7.5e-6 * age);
c                           = [A, 6.521218e3, -6.11066e8, 5.908191e13];
setup.refractN.lens         = cauchy(c,waveLength); % NB: we're ignoring the lens capsule
c                           = [1.323757, 5.560240e3, -5.817391e8, 5.036810e13];
setup.refractN.vitreous     = cauchy(c,waveLength);


function n = cauchy(c,wavelength)        
n = c(1) + c(2)/wavelength^2 + c(3)/wavelength^4 + c(4)/wavelength^6;
