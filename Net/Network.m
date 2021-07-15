classdef Network < dynamicprops
    properties
        % MACROCELL's Properties
        Lm;     % Macro cell Intensity
        Nm;     % Number of Macro cells
        Cm;     % Macro cell conditions
        BSm;    % Macro Cell BS object
        % SMALLCELL's Properties
        Ls;     % Small cell Intensity
        Ns;     % Number of Small cells
        Cs;     % Small cell conditions
        BSs;    % Small Cell BS object
        % GATEWAY's Properties
        Lg;
        Ng;
        GW;
        % NETWORK's Properties
        Dim;    % Dimensions [in m]
        Res;    % Tessellation Resolution
        MAP;    % Tessellation MAP matrix
        EDGES;  % Tessellation EDGES matrix
        RSRP;   % Received Signal Received Power limit [in dB]
        Controler;
    end
    methods
        % Network constructor
        function obj = Network( Lm, Ls, Lg, Dim, Res, RSRP, Cm, Cs )
            rng( 'shuffle' );
            % NETWORK'S
            obj.Dim = Dim;
            obj.Res = Res;
            obj.MAP = Mat( zeros( Res ) );
            obj.EDGES = Mat( zeros( Res ) );
            obj.RSRP = RSRP;
            
            % MACRO CELL'S
            obj.Lm = Lm;
            obj.Nm = poissrnd( Lm * ( Dim / 1000 ) ^ 2 );
            obj.Cm = Cm;
            obj.BSm = BS( obj.Nm, obj.Dim, obj.Cm );
            % SMALL CELL'S
            obj.Ls = Ls;
            obj.Ns = poissrnd( Ls * ( Dim / 1000 ) ^ 2 );
            obj.Cs = Cs;
            obj.BSs = BS( obj.Ns, obj.Dim, obj.Cs );
            % GATEWAY CELL's
            obj.Lg = Lg;
            obj.Ng = poissrnd( Lg * ( Dim / 1000 ) ^ 2 );
            obj.GW = Gateway( obj.Ng, Dim, obj.BSs );
            
            obj.Controler = Controler( obj.Ng );
        end
        % Tessellation Map
        function init_map( obj )
            scale_d = obj.Dim / obj.Res;
            scale_o = obj.Dim / 2;
            for cy = 1 : obj.Res
                for cx = 1 : obj.Res
                    P = [ scale_d * ( cx - 1 ) - scale_o , scale_d * ( cy - 1 ) - scale_o ];
                    SC = obj.BSs.RSS_dB( P );
                    MC = obj.BSm.RSS_dB( P );
                    BS = [ MC ; SC ];
                    [ ~ , I ] = max( BS );
                    if BS( I ) < obj.RSRP
                        I = 0;
                    end
                    obj.MAP.M( cy, cx ) = I;
                end
            end
        end
        % Edges Map
        function init_edges( obj, n )
            a = zeros( n );
            for cy = 1 : obj.Res - ( n - 1 )
                for cx = 1 : obj.Res - ( n - 1 )
                    for cj = 0 : n - 1
                        for ci = 0 : n - 1
                            a( cj + 1, ci + 1 ) = obj.MAP.M( cy + cj, cx + ci );
                        end
                    end
                    if ( any( a ~= a(1,1), [ 1,2 ] ) )
                        obj.EDGES.M( cx, cy ) = 1;
                    else
                        obj.EDGES.M( cx, cy ) = 0;
                    end
                end
            end
            obj.EDGES.M = obj.EDGES.M.';
        end
        % Plot Map
        function plot_map( obj, M, color_map, name )
            %%% Plots matrix
            lim = obj.Dim / 2;
            imagesc( [ -lim, lim ], [ -lim, lim ], M );
            colormap( color_map );
            hold on
            %%% Plots macro cells
            obj.BSm.plot( 0, 'sc' );
            %%% Plots small cells
            obj.BSs.plot( obj.BSm.n, 'or' );
            %%% Plots gateway cells
            obj.GW.plot( '*b' );
            %%%
            xlim( [ -lim , lim ] );
            ylim( [ -lim , lim ] );
            title( name );
        end
        % Plot Network
        function plot( obj )
            map = [ 1 1 1 ; 0 0 0 ];
            figure( 1 );
            obj.plot_map( obj.MAP.M, 'default', 'Network Map' );
            figure( 2 );
            obj.plot_map( obj.EDGES.M, map, 'Network Map' );
        end
    end
end