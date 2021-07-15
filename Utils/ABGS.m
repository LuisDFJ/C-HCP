classdef ABGS
    properties
        Ptx;
        Gtx;
        Grx;
        alpha;
        beta;
        gamma;
        sigma;
        f;
    end
    methods
        %
        function obj = ABGS( Ptx, Gtx, Grx, alpha, beta, gamma, sigma, f )
            obj.Ptx = Ptx;
            obj.Gtx = Gtx;
            obj.Grx = Grx;
            obj.alpha = alpha;
            obj.beta = beta;
            obj.gamma = gamma;
            obj.sigma = sigma;
            obj.f = f;
        end
        %
        function res = get( obj )
            res = [ obj.Ptx, obj.Gtx, obj.Grx, obj.alpha, obj.beta, obj.gamma, obj.sigma, obj.f ];
        end
    end
end