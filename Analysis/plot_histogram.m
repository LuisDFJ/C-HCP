function plot_histogram( Array, bins, Title, T, U, Model )
    tiledlayout( 2, 1 );
    tile1 = nexttile;
    histogram( tile1, Array, bins );
    title( Title );
    str = { "Time(s): " + string( T ),
            "Users: " + string( U ),
            "Model: " + Model
          };
    annotation( 'textbox', [0.6 0.6 0.3 0.3], 'String', str, 'FitBoxToText','on' );
    minlim = min( Array );
    maxlim = max( Array );
    xlim( [ minlim, maxlim ] );
    tile2 = nexttile;
    fit_normal( tile2, Array );
    xlim( [ minlim, maxlim ] );
end