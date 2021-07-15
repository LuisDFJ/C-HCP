function R = HandoverProbability( Array, NUE )
    average = 0;
    for i = 1 : NUE
        if Array( i ) ~= Inf
            average = average + Array( i );
        end
    end
    R = average / NUE;
end