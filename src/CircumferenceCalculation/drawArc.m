function drawArc(center,arcAngles,radius)
    % Define parameters of the arc.
    xCenter = center(1);
    yCenter = center(2); 
    %disp([arcAngles.startPoint, arcAngles.endPoint])
    % Define the angle theta as going from 30 to 150 degrees in 100 steps.
    if arcAngles.endPoint - arcAngles.startPoint > 0
        theta = 360 - linspace(arcAngles.startPoint, arcAngles.endPoint, 100);
    else
        theta = 360 - linspace(arcAngles.startPoint, 360, 100);
        theta2 = 360 - linspace(0, arcAngles.endPoint, 100);
        theta = [theta,theta2];
    end
    % Define x and y using "Degrees" version of sin and cos.
    x = radius * cosd(theta) + xCenter;
    y = radius * sind(theta) + yCenter;
        
    % Now plot the points.
    hold on
    plot(x, y, 'r', 'LineWidth', 3); 
    axis equal; 
    grid on;
end

