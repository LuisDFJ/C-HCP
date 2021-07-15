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

n = Network( 1, 50, 10, 1000, 500, -120, Cm, Cs );
n.init_map();
n.init_edges( 5 );
n.plot();
%%
%s = Sims( 1, n, 100, 10, 20, @C_HCP );
%s.motion( 10000 );