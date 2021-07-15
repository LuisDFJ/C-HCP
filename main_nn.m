close all
clear all
clc

addpath( 'Utils' );

X = Mat( [ 0,1,0,0;
           0,0,1,0;
           0,1,0,1;
           1,0,1,1;
           1,1,0,1;
           1,0,0,1 ]' ); 
Y = Mat( [ 1,0;
           0,1;
           1,1;
           1,0;
           0,1;
           1,1 ]' );

Layers = { RNNLayer( [ 3, 4 ], 1, 'sigmoid' ), RNNLayer( [ 3, 3 ], 1, 'sigmoid' ), RNNLayer( [ 2, 3 ], 1, 'sigmoid' ) };
n = NN( Layers, 'mse', X, Y );

e = 1000;
L = zeros( e, 1 );

for i = 1:e   
    L(i) = mean( n.feedforward() );
    n.backpropagation();
end

plot( 1:e, L )
