function [dist] = getEuclideanDist(startPoint, endPoint)

dist = sqrt( (startPoint(2) - endPoint(2) )^2 + (startPoint(1) - endPoint(1) )^2 );
end