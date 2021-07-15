classdef activation < handle
    properties
        fnc;
        fnc_dev;
        tag;
    end
    methods
        function obj = activation( tag )
            obj.tag = tag;
            switch tag 
                case 'tanh'
                    obj.fnc = @obj.tanh;
                    obj.fnc_dev = @obj.dev_tanh;
                case 'relu'
                    obj.fnc = @obj.relu;
                    obj.fnc_dev = @obj.dev_relu;
                case 'sigmoid'
                    obj.fnc = @obj.sigmoid;
                    obj.fnc_dev = @obj.dev_sigmoid;
            end
        end
        % SOFTMAX
        function z = softmax( ~, x )
            z = exp( x ) / sum( exp( x ) );
        end
        % HIPERBOLIC TAN
        function z = tanh( ~, x )
            z = ( exp( 2*x ) - 1 ) ./ ( exp( 2*x ) + 1 ); 
        end
        function z = dev_tanh( ~, x )
            z = 1 - x.^2;
        end
        % RECTIFIED LINEAR UNIT
        function z = relu( ~, x )
            z =  x .* ( x > 0 ); 
        end
        function z = dev_relu( ~, x )
            z = ( x > 0 );
        end
        % SIGMOID
        function z = sigmoid( ~, x )
            z = 1 ./ ( 1 + exp( -x ) ); 
        end
        function z = dev_sigmoid( ~, x )
            z = x .*( 1 - x );
        end
    end
end