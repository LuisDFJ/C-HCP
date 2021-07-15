classdef Mat < handle
    properties
        M;  % Matrix
    end
    methods
        function obj = Mat( M )
            obj.M = M;  % Pointer to a Matrix
        end
    end
end