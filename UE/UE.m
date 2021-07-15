classdef UE < dynamicprops
    properties
        
        Network;
        Controler;
        
        P;
        delta;
        
        v;
        t;
        x;
        d;
        s;
        c;
        f;
        
        h;
        r;
        
        BSp;
        BSs;
        BSt;
        BS;
        event;
        
        scheme;
        hom;
        ttt;
        tpp;
        
        HO;
        HOP;
        RLF;
        RLFP;
        HPP;
    end
    methods
        function obj = UE( Network, v, t, d, scheme )
            rng( 'shuffle' );
            obj.Network = Network;
            
            obj.randP();
            obj.randDelta();
            
            obj.v = v;
            obj.t = t;
            obj.x = v * t / 3600;
            obj.d = round( d / obj.x );
            obj.s = 0;  % Counter
            obj.c = 0;  % Counter
            obj.f = 0;  % Counter Ping-Pong
            
            obj.h = 0;  % Steps until next HO
            obj.r = 0;  % Steps until next RLF
            
            obj.BSp = 0;
            obj.BSs = 0;
            obj.BSt = 0;
            obj.event = 0;
            
            obj.hom = 3;
            obj.ttt = 300;
            obj.tpp = 2000;
            obj.scheme = scheme;
            obj.handover_scheme();
            
            obj.HO   = 0;
            obj.HOP  = 0;
            obj.RLF  = 0;
            obj.RLFP = 0;
            obj.HPP  = 0;
        end
        %
        function set_controler( obj, Controler )
            obj.Controler = Controler;
        end
        %
        function handover_scheme( obj )
            [ obj.hom, obj.ttt ] = obj.scheme( obj );
            obj.event = 0;
        end
        %
        function randP( obj )
            obj.P = obj.Network.Dim * ( rand( 1, 2 ) - 0.5 );
        end
        %
        function randDelta( obj )
            obj.delta = 2 * pi * rand();
        end
        %
        function randnDelta( obj )
            obj.delta = + obj.delta + 0.125 * pi * randn();
        end
        %
        function clearBS( obj )
            obj.BSs = 0;
            obj.BSt = 0;
            obj.BSp = 0;
            obj.h = 0;
            obj.r = 0;
        end
        %
        function move( obj )
            if ( abs( obj.P( 1 ) ) > obj.Network.Dim / 2 - 1 ) || ( abs( obj.P( 2 ) ) > obj.Network.Dim / 2 - 1 )
                obj.randP();
                obj.randDelta();
                obj.clearBS();
            else
                obj.step();
                obj.steps_ho();
                obj.steps_rlf();
                obj.pingpong_timer();
                obj.radiolink();
                obj.handover();
            end
        end
        %
        function step( obj )
            if obj.s == 0
                obj.randnDelta();
            end
            obj.P = obj.P + [ obj.x * cos( obj.delta ), obj.x * sin( obj.delta ) ];
            obj.s = mod( obj.s + 1, obj.d );
        end
        %
        function steps_ho( obj )
            if obj.BSs ~= 0
                obj.h = obj.h + 1;
            else
                obj.h = 0;
            end
        end
        %
        function steps_rlf( obj )
            if obj.BSs ~= 0
                obj.r = obj.r + 1;
            else
                obj.r = 0;
            end
        end
        %
        function pingpong_timer( obj )
            if obj.BSp ~= 0
                obj.f = mod( obj.f + 1, round( obj.tpp / obj.t ) );
            end
            if obj.f == 0
                obj.BSp = 0;
            end
        end
        %
        function radiolink( obj )
            BSmc = obj.Network.BSm.RSSF_dB( obj.P );
            BSsc = obj.Network.BSs.RSSF_dB( obj.P );
            obj.BS = [ BSmc ; BSsc ];
            if obj.BSs ~= 0
                if obj.BS( obj.BSs ) < obj.Network.RSRP
                    obj.BSs = 0;
                    obj.BSp = 0;
                    obj.RLF = obj.RLF + 1;
                    obj.average_rlf_steps();
                    %disp( "RLF" );
                end
            end
        end
        %
        function average_rlf_steps( obj )
            %disp( 'RLF steps: ' + string( obj.r ) );
            obj.RLFP = obj.RLFP * ( obj.RLF - 1 ) / obj.RLF + obj.r / obj.RLF;
            %disp( 'RLFP: ' + string( obj.RLFP ) );
            obj.r = 0;
        end
        %
        function handover( obj )
            if obj.c == 0
                [ ~, I ] = max( obj.BS );
                if obj.BS( I ) > obj.Network.RSRP
                    obj.BSt = I;
                    obj.check_target();
                    obj.handover_scheme(); %
                end
            end
            obj.c = mod( obj.c + 1, round( obj.ttt / obj.t ) );
        end
        %
        function check_target( obj )
            
            if obj.BSs ~= obj.BSt
                if obj.BSs == 0
                    obj.BSs = obj.BSt;
                    %disp( "Connect to " + string(obj.BSs) );
                else
                    if obj.BS( obj.BSs ) + obj.hom < obj.BS( obj.BSt )
                        obj.handover_event();
                        obj.pingpong_event();
                        obj.BSp = obj.BSs;
                        obj.BSs = obj.BSt;
                        obj.HO = obj.HO + 1;
                        obj.average_ho_steps();
                        %disp( "Handover to " + string(obj.BSs) );
                    end
                end
            end
            
        end
        %
        function average_ho_steps( obj )
            %disp( 'HO steps: ' + string( obj.h ) );
            obj.HOP = obj.HOP * ( obj.HO - 1 ) / obj.HO + obj.h / obj.HO;
            %disp( 'HOP: ' + string( obj.HOP ) );
            obj.h = 0;
        end
        %
        function handover_event( obj )
            
            dim = obj.Network.Dim;
            step = obj.Network.Dim / obj.Network.Res;
            cx = floor( ( obj.P(1) + dim/2 ) / step ) + 1;
            cy = floor( ( obj.P(2) + dim/2 ) / step ) + 1;
            actualBS = obj.Network.MAP.M( cy, cx );
            if actualBS == obj.BSs
                %disp( "Too early" )
                obj.event = 1;
            elseif actualBS == obj.BSt
                %disp( "Too late" )
                obj.event = 2;
            else
                %disp( "Wrong" )
                obj.event = 3;
            end
            %disp( "HOM: - " + string( obj.hom ) + " TTT: - " + string( obj.ttt ) );
            
        end
        %
        function pingpong_event( obj )
            if obj.BSp == obj.BSt
                obj.HPP = obj.HPP + 1;
                obj.BSp = 0;
                obj.f = 0;
                %disp( 'PING PONG' );
            end
        end
    end
end