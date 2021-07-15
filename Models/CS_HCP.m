function [ hom, ttt ] = CS_HCP( obj )
    hom = obj.hom;
    ttt = obj.ttt;
    if ( obj.event ~= 0 )
        if ( obj.BSs > obj.Network.Nm )
            bs = obj.BSs - obj.Network.Nm;
            n = obj.Network.BSs.G( bs );
            v = obj.v;
            rss = obj.BS( obj.BSs );
            X = [ bs, v, rss, hom, ttt ]';
            obj.Controler.X.M = X;
            S = obj.Controler.feedforward( n );

            hom = round( 4 * ( S( 1 ) - 0.25 ), 2 );
            ttt = round( 300 * S( 2 ) + 100, -1 );
            
            %disp( "HOM: " + string( hom ) );
            %disp( "TTT: " + string( ttt ) );
        end
    end
end