%%
close all
clear all
clc
%%
addpath( 'Net' );
addpath( 'UE' );
addpath( 'Utils' );
addpath( 'Models' );
%%
Cm = ABGS( 59, 11, 0, 2.8, 11.4, 2.3, 4.1, 2.1 );
Cs = ABGS( 32, 11, 0, 2.0, 31.4, 2.1, 2.9, 28.9 );


%%
V = [ 10, 20, 40, 60, 80, 120 ];


I = 5; % Iterations
T = 150; % Simulation Time [s]
U = 100; % Users
cV = 6;  % Velocity profiles



HOP = zeros( U * I, cV, 1 );
RLFP = zeros( U * I, cV, 1 );
HPPP = zeros( U * I, cV, 1 );

HO = zeros( U * I, cV, 1 );
RLF = zeros( U * I, cV, 1 );

network = Network.empty( I, 0 );

for i = 1 : I

%     n = Network( 1, 70, 10, 1000, 200, -120, Cm, Cs );
%     n.init_map();
%     network( i ) = n;
    %n = network( i );
%     for v = 1 : cV
%         s = Sims( U, n, V( v ), 10, 20, @C_HCP );
%         s.simulation( T * 1000 / 10 );
%     end
    for v = 1 : cV
        
        n = Network( 1, 70, 10, 1000, 200, -120, Cm, Cs );
        n.init_map();
        network( i ) = n;
        
        s = Sims( U, n, V( v ), 10, 20, @C_HCP );
        s.simulation( T * 2000 / 10 );
        
        
        HOP( (1:U) + (i - 1)*U, v, 1 ) = s.uHOP();
        RLFP( (1:U) + (i - 1)*U, v, 1 ) = s.uRLFP();
        HPPP( (1:U) + (i - 1)*U, v, 1 ) = s.uHPPP();
        HO( (1:U) + (i - 1)*U, v, 1 ) = s.uHO();
        RLF( (1:U) + (i - 1)*U, v, 1 ) = s.uRLF();
        
    end
    
end

disp( s.UEs( 1 ).hom );
disp( s.UEs( 1 ).ttt );

save( "Results/FC_HCP/F3_I5_UE100_TT_150_T150_SC70.mat", "HOP", "RLFP", "HPPP", "HO", "RLF", "V", "network" );

