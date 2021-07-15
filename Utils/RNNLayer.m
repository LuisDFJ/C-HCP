classdef RNNLayer < dynamicprops
    properties
        % MAT Pointer Properties
        X;      % INPUT Pointer
        S;      % OUTPUT Pointer
        St_1;   % OUTPUT t-1 Pointer
        dL;     % IN-LOSS Gradient
        dX;     % OUT-LOSS Gradient
        % MAT Properties
        Z;      % SUM Matrix
        Wxs;    % WEIGHT input Matrix
        Wss;    % WEIGHT state Matrix
        Sk_1;   % OUTPUT t-1 Eval Matrix
        d;      % GRADIENT Matrix
        % LAYER Properties
        Size;       % [ Output, Input ]
        activation; % Activation function
        n;          % Learning factor
    end
    methods
        function obj = RNNLayer( Size, n, tag )
            obj.Size = Size;
            obj.Wxs  = rand( Size ) - 0.5;
            obj.Wss  = rand( Size( 1 ) ) - 0.5;
            obj.activation = activation( tag );
            obj.n    = n;
        end
        % CONNECT INPUT
        function assemble_input( obj, X )
            obj.X    = X;
            obj.Z    = zeros( obj.Size( 1 ), size( X.M, 2 ) );
            obj.S    = Mat( zeros( obj.Size( 1 ), size( X.M, 2 ) ) );
            obj.St_1 = Mat( zeros( obj.Size( 1 ), size( X.M, 2 ) ) );
            obj.d    = zeros( obj.Size( 1 ), size( X.M, 2 ) );
            obj.dX   = Mat( zeros( size( X.M ) ) );
        end
        % CONNECT OUTPUT
        function assemble_output( obj, dL )
            obj.dL = dL;
        end
        % FEEEDFORWARD
        function feedforward( obj )
            obj.St_1.M = obj.S.M;
            obj.Z = obj.Wxs * obj.X.M + obj.Wss * obj.St_1.M;
            obj.S.M = obj.activation.fnc( obj.Z ); 
        end
        % BACKPROPAGATION
        function backpropagation( obj )
            obj.d = obj.dL.M .* obj.activation.fnc_dev( obj.S.M );
            obj.dX.M = obj.Wxs' * obj.d;
            obj.Wxs = obj.Wxs - obj.n * obj.d * obj.X.M';
            obj.Wss = obj.Wss - obj.n * obj.d * obj.St_1.M';
        end
        % EVAL LAYER
        function S = eval( obj, X )
            if isempty( obj.Sk_1 )
                S = obj.activation.fnc( obj.Wxs * X );
            else 
                S = obj.activation.fnc( obj.Wxs * X + obj.Wss * obj.Sk_1 );
            end
            obj.Sk_1 = S;
        end
        
        function print( obj )
            disp( 'W_xs' + string( size( obj.Wxs ) ) );
            disp( 'W_ss' + string( size( obj.Wss ) ) );
            disp( 'X' + string( size( obj.X.M ) ) );
            disp( 'Z' + string( size( obj.Z ) ) );
            disp( 'S_t' + string( size( obj.S.M ) ) );
            disp( 'S_t_1' + string( size( obj.St_1.M ) ) );
        end
        
        function print_values( obj )
            disp( 'W_xs' );
            disp( obj.Wxs );
            disp( 'W_ss' );
            disp( obj.Wss );
            disp( 'S_t' );
            disp( obj.S.M );
            disp( 'S_t_1' );
            disp( obj.St_1.M );
        end
    end
end