function [ hom, ttt ] = D_HCP( obj )
    
    dhom = 0;
    dttt = 0;
    switch obj.event
        case 1 % Too early
            dhom = 1;
            dttt = 20;
        case 2 % Too late
            dhom = -1;
            dttt = -20;
        case 3 % Wrong
            dhom = -1;
            dttt = 20;
    end
    hom = obj.hom + dhom;
    ttt = obj.ttt + dttt;
    if ttt < 10
        ttt = 10;
    end
    
end