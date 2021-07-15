classdef Controler < dynamicprops
    properties
        NN;
        X;
        Y;
        n;
    end
    methods
        function obj = Controler( n )
            obj.X   = Mat( zeros( 5, 1 ) );
            obj.Y   = Mat( zeros( 2, 1 ) );
            obj.n   = n;
            obj.build();
        end
        function build( obj )
            obj.NN = NN.empty( obj.n, 0 ); 
            for i = 1 : obj.n
                LayerRNN    = RNNLayer( [ 4, 5 ], 0.1, 'sigmoid' );
                LayerNN     = NNLayer( [ 2, 4 ], 0.1, 'sigmoid' );
                obj.NN( i ) = NN( { LayerRNN, LayerNN }, 'mse', obj.X , obj.Y );
            end
        end
        
        function set_loss( obj, L, n )
            obj.NN( n ).dL.M = L;
        end
        
        function S = feedforward( obj, n )
            [ ~, S ] = obj.NN( n ).feedforward();
        end
        function backpropagation( obj, n )
            obj.NN( n ).backpropagation();
        end
    end
end