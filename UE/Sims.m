classdef Sims < dynamicprops
    properties
        UEs;
        Controler;
        N;
        P;
        T;
    end
    methods
        %
        function obj = Sims( N, Network, v, t, d, scheme )
            obj.N = N;
            obj.Controler = Network.Controler;
            obj.init_UE( Network, v, t, d, scheme );
            obj.P = zeros( N, 2 );
            obj.T = t;
        end
        %
        function init_UE( obj, Network, v, t, d, scheme )
            obj.UEs = UE.empty( obj.N, 0 );
            for i = 1 : obj.N
                obj.UEs( i ) = UE( Network, v, t, d, scheme );
                obj.UEs( i ).set_controler( obj.Controler );
            end
        end
        %
        function motion( obj, N )
            h = plot( obj.P( : , 1 ), obj.P( :, 2 ), 'og' );
            h.XDataSource = 'obj.P( : , 1 )';
            h.YDataSource = 'obj.P( : , 2 )';
            for i = 1 : N
                for u = 1 : obj.N
                    obj.UEs( u ).move();
                    obj.P( u, : ) = obj.UEs( u ).P;
                end
                refreshdata( h, 'caller' );
                pause( obj.T / 1000 )
            end
        end
        %
        function simulation( obj, N )
            for i = 1 : N
                for u = 1 : obj.N
                    obj.UEs( u ).move();
                end
            end
        end
        %
        function HOP = uHOP( obj )
            HOP = zeros( obj.N, 1 );
            for i = 1 : obj.N
                if obj.UEs( i ).HOP ~= 0
                    HOP( i ) = 1 / obj.UEs( i ).HOP;
                end
            end
        end
        %
        function RLFP = uRLFP( obj )
            RLFP = zeros( obj.N, 1 );
            for i = 1 : obj.N
                if obj.UEs( i ).RLFP ~= 0
                    RLFP( i ) = 1 / obj.UEs( i ).RLFP;
                end
            end
        end
        %
        function HO = uHO( obj )
            HO = zeros( obj.N, 1 );
            for i = 1 : obj.N
                HO( i ) = obj.UEs( i ).HO;
            end
        end
        %
        function RLF = uRLF( obj )
            RLF = zeros( obj.N, 1 );
            for i = 1 : obj.N
                RLF( i ) = obj.UEs( i ).RLF;
            end
        end
        %
        function HPPP = uHPPP( obj )
            HPPP = zeros( obj.N, 1 );
            for i = 1 : obj.N
                if obj.UEs( i ).HPP ~= 0
                    HPPP( i ) = obj.UEs( i ).HPP / obj.UEs( i ).HO;
                end
            end
        end
    end
end