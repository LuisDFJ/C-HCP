classdef loss_function < handle
    properties
        fnc;
        fnc_dev;
        tag;
    end
    methods
        function obj = loss_function( tag )
            obj.tag = tag;
            switch tag 
                case 'mse'
                    obj.fnc = @obj.mse;
                    obj.fnc_dev = @obj.dev_mse;
                case 'mae'
                    obj.fnc = @obj.mae;
                    obj.fnc_dev = @obj.dev_mae;
                case 'mbe'
                    obj.fnc = @obj.mbe;
                    obj.fnc_dev = @obj.dev_mbe;
                case 'svm'
                    obj.fnc = @obj.svm;
                    obj.fnc_dev = @obj.dev_svm;
                case 'ce'
                    obj.fnc = @obj.ce;
                    obj.fnc_dev = @obj.dev_ce;
            end
        end
        % MEAN SQUARE ERROR
        function l = mse( ~, yp, yr )
            l = mean( ( yr - yp ) .^ 2 );
        end
        function d = dev_mse( ~, yp, yr )
            d = -2 * ( yr - yp );
        end
        % MEAN ABSOLUTE ERROR
        function l = mae( ~, yp, yr )
            l =  mean( abs( yr - yp ) );
        end
        function d = dev_mae( ~, yp, yr )
            d = ( yr < yp ) - ( yr > yp );
        end
        % MEAN BIAS ERROR
        function l = mbe( ~, yp, yr )
            l = mean( ( yr - yp ) );
        end
        function d = dev_mbe( ~, ~, ~ )
            d = -1;
        end
        % SUPPORT VECTOR MACHINE
        function l = svm( ~, yp, i )
            l = sum( max( 0, yp - yp( i ) + 1 ) );
        end
        function d = dev_svm( ~, yp, i )
            d = -( yp - yp( i ) + 1 ) > 0;
        end
        % CROSS ENTROPY
        function l = ce( ~, yp, yr )
            l = -yr .* log( yp ); 
        end
        function d = dev_ce( ~, yp, yr )
            d = -yr ./ yp;
        end
    end
end