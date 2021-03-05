/* These are arrays */
int nProducts   = 2;
int nComponents = 3;

range Products   = 1..nProducts;
range Components = 1..nComponents;

float Demand[Products][Components] = [ [1, 3, 0], [1, 4, 1] ];

float Profit[Products] = [40, 50];

float Stock [Components] = [50, 180, 40];

dvar float+ Production[Products];

maximize
  sum( p in Products )
     Profit[p] * Production[p];

subject to {
   forall( c in Components )
ct: sum( p in Products ) Demand[p][c] * Production[p] <= Stock[c];
}
