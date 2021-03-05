// to run on terminal, >> oplrun volsay3.mod volsay3b.dat

int nProducts   = ...;
int nComponents = ...;

range Products   = 1..nProducts;
range Components = 1..nComponents;

float Demand[Products][Components] = ...;

float Profit[Products] = ...;

float Stock [Components] = ...;

dvar float+ Production[Products];

maximize
  sum( p in Products )
    Profit[p] * Production[p];
subject to {
  forall( c in Components )
    ct:
      sum( p in Products ) Demand[p][c] * Production[p] <= Stock[c];
}
