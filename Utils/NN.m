classdef NN < dynamicprops
    properties
        % LAYERS
        Layers;
        % NETWORK PROPERTIES
        loss_function;  % Loss Function
        X;  % Input  [ MAT ]
        Y;  % Output [ MAT ]
        dL; % Loss Gradient [ MAT ]
    end
    methods
        % CONSTRUCTOR
        function obj = NN( Layers, loss, X, Y )
            obj.Layers = Layers;
            obj.loss_function = loss_function( loss );
            obj.X = X;
            obj.Y = Y;
            obj.dL = Mat( zeros( size( Y.M ) ) );
            obj.build();
        end
        % ASSEMBLE LAYERS
        function build( obj )
            n = length( obj.Layers );
            % FORWARD ASSEMBLY
            obj.Layers{ 1 }.assemble_input( obj.X );
            for i = 2 : n
                obj.Layers{ i }.assemble_input( obj.Layers{ i - 1 }.S );
            end
            % BACK ASSEMBLY
            obj.Layers{ n }.assemble_output( obj.dL );
            for i = n : -1 : 2
                obj.Layers{ i - 1 }.assemble_output( obj.Layers{ i }.dX );
            end
        end
        % FEEDFORWARD
        function [ L, Y ] = feedforward( obj )
            n = length( obj.Layers );
            for i = 1 : n
                obj.Layers{ i }.feedforward();
            end
            obj.set_loss( obj.loss_function.fnc_dev( obj.Layers{ n }.S.M, obj.Y.M ) );
            L = obj.loss_function.fnc( obj.Layers{ n }.S.M, obj.Y.M );
            Y = obj.Layers{ n }.S.M;
        end
        % SET LOSS GRADIENT
        function set_loss( obj, loss )
            n = length( obj.Layers );
            obj.Layers{ n }.dL.M = loss;
        end
        % BACKPROPAGATION
        function backpropagation( obj )
            n = length( obj.Layers );
            for i = n : -1 : 1
                obj.Layers{ i }.backpropagation();
            end
        end
        % EVAL NETWORK
        function R = eval( obj, X )
            n = length( obj.Layers );
            S = obj.Layers{ 1 }.eval( X );
            for i = 2 : n
                S = obj.Layers{ i }.eval( S );
            end
            R = S;
        end
    end
end