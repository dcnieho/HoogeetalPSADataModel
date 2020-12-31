close all; clear all; clc; warning off;                                             % Get rid of everything
fold        =  initialize_all();                                                    % Get rid of everything

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters used for Figure 14, panels A and B (the simplified eye model):
alpha                       = [-12 -6 0 6 12];                                      % Viewing angle in degrees. Negative is counterclockwise
d                           = 530;                                                  % Distance from the eye to camera in mm
pl                          = [-1:-0.25:-3];                                        % Position left pupil border from optical axis in mm. Negative is leftward
pr                          = [ 1: 0.25: 3];                                        % Position right pupil border from optical axis in mm. Negative is leftward
pupsz                       = pr - pl;                                              % Pupil diameter = right pupil border - left pupil border

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% other model parameters
setup                       = parametersAguirre();                                  % Do not confuse Aguirre parameters with the Aguirre model (we only used parameters from Aguirre)
caltabnm                    = [fold.cal filesep 'calibrationtablepup4mm.txt'];
caltab                      = readcaltable(caltabnm,1);                             % Load calibration table

% run model
for r=1:numel(alpha)                                                                % Run for all viewing angles
    [x1,x2,pLI4(r),pRI4(r)] = IgnacePSARunner2(alpha(r),d,-2,2,setup);              % x1 and x2 are not used here
    puppos(r)               = (pLI4(r) + pRI4(r))/2;
    for p=1:numel(pupsz)
        [pLP,pRP,pLI,pRI]   = IgnacePSARunner2(alpha(r),d,pl(p),pr(p),setup);
        
        % in pupil plane
        pupcentFedtke(p)    = (pLI + pRI)/2.0;
        deviationP(p)       = pupcentFedtke(p) - puppos(r);
        
        % in angles
        pupcent(p)          = (pLP + pRP)/2.0;
        angle(p)            = dist2angle(caltab,pupcent(p));
        deviation(p)        = angle(p) - alpha(r);
    end
    subplot(121), plot(pupsz,deviation,'k-'); hold on
    axis([1.5 7.5 -0.1 0.1]);
    axis square
    xlabel('Pupil diameter (mm)','FontSize',14);
    ylabel('Deviation (deg)','FontSize',14);
    slope(r)                = fitline(pupsz,deviation);
end
hold off

subplot(122), plot(alpha,slope,'k-');
axis([-14 14 -0.04 0.04]);
xlabel('Viewing angle (deg)','FontSize',14);
ylabel('Slope of the PSA (deg/mm)','FontSize',14);
axis square

plotname                    = [fold.res filesep 'PSAsimulation.png'];
print('-dpng','-r300',plotname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
