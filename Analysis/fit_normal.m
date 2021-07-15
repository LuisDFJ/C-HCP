function fit_normal( tile, Array )
    pd = fitdist( Array, 'normal' );
    x = (-1:0.1:1) * 3.5 * pd.sigma + pd.mu;
    y = pdf( pd, x );
    plot( tile, x, y )
    str = { "\mu: " + string( pd.mu ),
            "\sigma: " + string( pd.sigma )
          };
    annotation( 'textbox', [0.6 0.1 0.3 0.3], 'String', str, 'FitBoxToText','on' );
end