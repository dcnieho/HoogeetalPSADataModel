function points = placeIrisPoint(distance, reference, opticalAxisOrientation)

perpToOpticalAxis   = [cosd(opticalAxisOrientation) -sind(opticalAxisOrientation)];
points              = [reference(1)+distance.*perpToOpticalAxis(1); reference(2)+distance.*perpToOpticalAxis(2)];
