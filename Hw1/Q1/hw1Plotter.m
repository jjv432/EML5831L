function [] = hw1Plotter(positions)


    clf
    x_positions = positions(:, 1);
    y_positions = positions(:, 2);
    plot(x_positions, y_positions);


end