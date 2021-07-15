classdef BS < dynamicprops
    properties
        % SPATIAL Properties
        n;      % Number of BS
        dim;    % DImensions [m]
        Q;      % Position vector [m]
        
        G;
        
        % PROPAGATION Properties
        Ptx;    % Transmission Power
        Gtx;    % Transmission Gain
        Grx;    % Receiver Gain
        alpha;  % 
        beta;   %   ABG Path Loss Model Parameter
        gamma;  %
        sigma;  %   LogNormal Deviation
        f;      %   Frequency
        % AUXILIAR PROPERTIES
        B;      % Bias [dB]
    end
    methods
        % -->
        % Base Station Constructor
        function obj = BS( n, dim, c )
            rng( 'shuffle' );
            % Spatial Properties
            obj.n = n;
            obj.dim = dim;
            obj.Q = dim * ( rand( n, 2 ) - 0.5 );
            obj.G = zeros( n, 1 );
            % Propagation Properties
            c = c.get();
            obj.Ptx     = c( 1 );
            obj.Gtx     = c( 2 );
            obj.Grx     = c( 3 );
            obj.alpha   = c( 4 );
            obj.beta    = c( 5 );
            obj.gamma   = c( 6 );
            obj.sigma   = c( 7 );
            obj.f       = c( 8 );
            % Bias          Gains & Powers                ABG Path Loss Model
            obj.B = obj.Ptx + obj.Gtx + obj.Grx - ( obj.beta + 10 * log10( obj.f ) * obj.gamma );
        end
        
        % Get Bias With Shadow Fading [W]
        function B = Bias( obj )
            B = 10 .^ ( 0.1 * ( obj.B - obj.sigma .* randn( obj.n, 1 ) ) );
        end
        % Received Signal Strength [W]
        function R = RSS( obj, P )
            R = obj.B ./ ( ( obj.Q( :, 1 ) - P( 1 ) ) .^ 2 + ( obj.Q( :, 2 ) - P( 2 ) ) .^ 2 ) .^ ( obj.alpha / 2 );
        end
        % Received Signal Strength w/ Fading [W]
        function R = RSSF( obj, P )
            R = obj.Bias() ./ ( ( obj.Q( :, 1 ) - P( 1 ) ) .^ 2 + ( obj.Q( :, 2 ) - P( 2 ) ) .^ 2 ) .^ ( obj.alpha / 2 );
        end
        % Get Bias With Shadow Fading [dB]
        function B = Bias_dB( obj )
            B = obj.B - obj.sigma .* randn( obj.n, 1 );
        end
        
        % -->
        % Received Signal Strength [dB]
        function R = RSS_dB ( obj, P )
            R = obj.B - 10 * log( ( obj.Q( :, 1 ) - P( 1 ) ) .^ 2 + ( obj.Q( :, 2 ) - P( 2 ) ) .^ 2 ) * ( obj.alpha / 2 );
        end
        
        % -->
        % Received Signal Strength w/ Fading [dB]
        function R = RSSF_dB ( obj, P )
            R = obj.Bias_dB() - 10 * log( ( obj.Q( :, 1 ) - P( 1 ) ) .^ 2 + ( obj.Q( :, 2 ) - P( 2 ) ) .^ 2 ) * ( obj.alpha / 2 );
        end
        
        % -->
        % Plot BS
        function plot( obj, n, id )
            pBSm = plot( obj.Q( :, 1 ), obj.Q( :, 2 ), id );
            if obj.n > 0
                pBSm.DataTipTemplate.DataTipRows(1).Label = 'X pos:';
                pBSm.DataTipTemplate.DataTipRows(2).Label = 'Y pos:';
                pBSm.DataTipTemplate.DataTipRows(3) = dataTipTextRow( 'BS:', ( 1:obj.n ) + n );
                pBSm.DataTipTemplate.DataTipRows(4) = dataTipTextRow( 'GW:', obj.G );
            end
        end
    end
end