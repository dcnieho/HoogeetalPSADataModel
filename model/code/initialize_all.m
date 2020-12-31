function [fold] =  initialize_all()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fold.thuis = pwd;
cd ..;                      fold.base      = pwd;
cd code;
cd z_myfunctions;           addpath(genpath(cd)); % add myfunctions and all enclosed folders 
cd ..; cd ..;

mkdir(fold.base,'results');
cd results;                 fold.res      = cd;
cd ..; cd(fold.thuis);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fold.cal        = [fold.base filesep 'calfiles']; % folder with calibration table
