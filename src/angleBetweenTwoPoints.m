function D2 = angleBetweenTwoPoints(XI,XJ)  
%ANGLEBETWEENTWOPOINTS Angle between two points (as vectors)
distanceVector = XI-XJ;
xe = [1 0];
angle = acos(min(1,max(-1, xe(:).' * distanceVector(:) / norm(xe) / norm(distanceVector) )));
D2 = angle;
