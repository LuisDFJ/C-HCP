classdef NNLayer < dynamicprops
    properties
        % MAT Pointer Properties
        X;      % INPUT Pointer
        S;      % OUTPUT Pointer
        dL;     % IN-LOSS Gradient
        dX;     % OUT-LOSS Gradient
        % MAT Properties
        Z;      % SUM Matrix
        Wxs;    % WEIGHT input Matrix
        d;      % GRADIENT Matrix
        % LAYER Properties
        Size;       % [ OUTPUT, INPUT ]
        activation; % Activation Function
        n;          % Learning Factor
    end
    methods
        function obj = NNLayer( Size, n, tag )
            obj.Size = Size;
            obj.Wxs  = rand( Size ) - 0.5;
            obj.activation = activation( tag );
            obj.n    = n;
        end
        % CONNECT INPUT
        function assemble_input( obj, X )
            obj.X   = X;
            obj.Z   = zeros( obj.Size( 1 ), size( X.M, 2 ) );
            obj.S   = Mat( zeros( obj.Size( 1 ), size( X.M, 2 ) ) );
            obj.d   = zeros( obj.Size( 1 ), size( X.M, 2 ) );
            obj.dX  = Mat( zeros( size( X.M ) ) );
        end
        % CONNECT OUTPUT
        function assemble_output( obj, dL )
            obj.dL = dL; 
        end
        % FEEDFORWARD
        function feedforward( obj )
            obj.Z = obj.Wxs * obj.X.M;
            obj.S.M = obj.activation.fnc( obj.Z ); 
        end
        % BACKPROPAGATION
        function backpropagation( obj )
            obj.d = obj.dL.M .* obj.activation.fnc_dev( obj.S.M );
            obj.dX.M = obj.Wxs' * obj.d;
            obj.Wxs = obj.Wxs - obj.n * obj.d * obj.X.M';
        end
        % EVAL LAYER
        function S = eval( obj, X )
            S = obj.activation.fnc( obj.Wxs * X );
        end
        
        function print( obj )
            disp( 'W_xs' + string( size( obj.Wxs ) ) );
            disp( 'X' + string( size( obj.X.M ) ) );
            disp( 'Z' + string( size( obj.Z ) ) );
            disp( 'S' + string( size( obj.S.M ) ) );
        end
        
        function print_values( obj )
            disp( 'W_xs' );
            disp( obj.Wxs );
            disp( 'S' );
            disp( obj.S.M );
        end
    end
end