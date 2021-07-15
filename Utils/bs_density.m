function P = bs_density( Q, k )
    n = length( Q );
    W = zeros( n, 1 );
    for i = 1 : n
        w = 0;
        for j = 1 : n
            if i ~= j
                d = sqrt( ( Q( i, 1 ) - Q( j, 1 ) )^2 + ( Q( i, 2 ) - Q( j, 2 ) )^2 );
                w = w + 1/d;
            end
        end
        W( i ) = w;
    end
    [ ~, I ] = maxk( W, k );
    P = Q( I, : ) + 50 * ( rand( k, 2 ) - 0.5 );
end