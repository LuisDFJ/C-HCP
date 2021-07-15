classdef Gateway < dynamicprops
    properties
        n
        dim
        Q
    end
    methods
        %
        function obj = Gateway( n, dim, BS )
            rng( 'shuffle' );
            % Spatial Properties
            obj.n = n;
            obj.dim = dim;
            obj.place_gateway( BS.Q, n );
            %obj.Q = dim * ( rand( n, 2 ) - 0.5 );
            obj.init_BS( BS );
            
        end
        % 
        function place_gateway( obj, Q, k )
            l = length( Q );
            W = zeros( l, 1 );
            for i = 1 : l
                w = 0;
                for j = 1 : l
                    if i ~= j
                        d = sqrt( ( Q( i, 1 ) - Q( j, 1 ) )^2 + ( Q( i, 2 ) - Q( j, 2 ) )^2 );
                        w = w + 1/d;
                    end
                end
                W( i ) = w;
            end
            [ ~, I ] = maxk( W, l );
            J = zeros( k, 1 );
            c = 1;
            for i = 1 : l
                flag = 0;
                for j = 1 : k
                    if J( j ) ~= 0
                        d = sqrt( ( Q( I( i ), 1 ) - Q( J( j ), 1 ) )^2 + ( Q( I( i ), 2 ) - Q( J( j ), 2 ) )^2 );
                        if d < 200
                            flag = 1;
                        end
                    end
                end
                if ~flag && c <= k 
                    J( c ) = I( i );
                    c = c + 1;
                end
            end
            obj.Q = Q( J, : ) + 50 * ( rand( k, 2 ) - 0.5 );
        end
        %
        function init_BS( obj, BS )
            
            for i = 1 : BS.n
                BS.G( i ) = obj.shortest_distance( BS.Q( i, : ) );
            end
            
        end
        %
        function I = shortest_distance( obj, P )
            D = sqrt( ( obj.Q(:,1) - P(1) ).^2 + ( obj.Q(:,2) - P(2) ).^2 );
            [ ~, I ] = min( D );
        end
        %
        function plot( obj, id )
            pBSm = plot( obj.Q( :, 1 ), obj.Q( :, 2 ), id );
            if obj.n > 0
                pBSm.DataTipTemplate.DataTipRows(1).Label = 'X pos:';
                pBSm.DataTipTemplate.DataTipRows(2).Label = 'Y pos:';
                pBSm.DataTipTemplate.DataTipRows(4) = dataTipTextRow( 'GW:', 1:obj.n );
            end
        end
        
    end
end