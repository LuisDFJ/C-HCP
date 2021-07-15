addpath( 'Analysis' );

hop = zeros( 6, 3 );
rlfp = zeros( 6, 3 );
hppp = zeros( 6, 3 );

files = [
            "Results\FC_HCP\F3_I5_UE100_TT_150_T150_SC70.mat",
            "Results\D_HCP\I5_UE100_T150_HOM3_TTT300_SC70.mat",
            "Results\S_HCP\I5_UE100_T150_HOM3_TTT300_SC70.mat"
        ];


for j = 1: 3
    load( files( j ) );
    for i = 1: 6
        %figure( i );
        %plot_histogram( HOP( :, i, 1 ) * V( i ) / 360, 20, 'Handover probability - V' + string(V(i)), 100, 100, 'C-HCP' );
        hop(i, j) = HandoverProbability( HOP( 1:500, i, 1  ) * V( i ) / 360 , 100 );
        rlfp(i, j) = HandoverProbability( RLFP( 1:500, i, 1  ) * V( i ) / 360 , 100 );
        hppp(i, j) = HandoverProbability( HPPP( 1:500, i, 1  ) , 100 );
    end
end


V = categorical( V );

figure(1)
hold on
bar( V, hop' );
b1 = gcf;
grid on
title( "Handover Probability \lambda_S - 70" )
xlabel( "Mobility [km/h]" )
ylabel( "Empirical Probability" )
legend( "C-HCP", "D-HCP", "S-HCP", 'Location','northwest' );
ylim( [ 0, max( hop, [], 'all' ) ] );

figure(2)
hold on
bar( V, rlfp' );
b2 = gcf;
grid on
title( "RLF Probability \lambda_S - 70" )
xlabel( "Mobility [km/h]" )
ylabel( "Empirical Probability" )
legend( "C-HCP", "D-HCP", "S-HCP", 'Location','northwest' );
ylim( [ 0, max( rlfp, [], 'all' ) ] );

figure(3)
hold on
bar( V, hppp' );
b3 = gcf;
grid on
title( "HPP Probability \lambda_S - 70" )
xlabel( "Mobility [km/h]" )
ylabel( "Empirical Probability" )
legend( "C-HCP", "D-HCP", "S-HCP" );
ylim( [ 0, max( hppp, [], 'all' ) ] );

exportgraphics(b1,'Images\HOP70.png', 'Resolution', 250)
exportgraphics(b2,'Images\RLFP70.png', 'Resolution', 250)
exportgraphics(b3,'Images\HPPP70.png', 'Resolution', 250)