/*********************************************
 * OPL 12.10.0.0 Model
 * Author: marce
 * Creation Date: 9 Apr 2021 at 10:39:34
 *********************************************/

int nTasks = ...;
int nThreads = ...;
int nCPUs = ...;
int nCores = ...;

range T = 1..nTasks;
range C = 1..nCPUs;
range H = 1..nThreads;
range K = 1..nCores;

float rh[H] = ...;
float rc[C] = ...;

int CK[C][K] = ...;
int TH[T][H] = ...;

dvar boolean x_tc[T][C];
dvar boolean x_hk[H][K];
dvar float+ z;


// Pre-processing
execute {
	var totalLoad = 0;
	for (var t = 1; t <= nTasks; t++)
		totalLoad += rh[t];
	writeln("Total load " + totalLoad);
	
	var totalCap = 0;
	for (var c = 1; c <= nCPUs; c++)
		totalCap += rc[c];
	writeln("Total capacity " + totalCap);
	
	if (totalLoad <= totalCap) {
		writeln("Computers have capacity enough to handle all the tasks");
	} else {
		writeln("Computers DO NOT HAVE capacity enough to handle all the tasks");
		stop();
	}
};

// To obtain the number of threads of each task and the number of cores in each computer
int Ht[T];
int Kc[C];

execute {
  for (var i = 1; i <= nTasks; i++) {
    for (var j = 1; j <= nThreads; j++) {
      Ht[i] += TH[i][j];
    }
  }
  for (var i = 1; i <= nCPUs; i++) {
    for (var j = 1; j <= nCores; j++) {
      Kc[i] += CK[i][j];
    }
  }
}

// Objective
minimize z;

subject to {
	
	forall(h in H)
		sum(k in K) x_hk[h, k] == 1;
	
	forall (t in T, c in C)
    	sum(h in H, k in K : CK[c][k] * TH[t][h] == 1) x_hk[h][k] == Ht[t] * x_tc[t][c];

	forall (c in C, k in K : CK[c][k] == 1)
		sum(h in H) rh[h] * x_hk[h][k] <= rc[c];
    
	forall (c in C)
		z >= (1/(Kc[c] * rc[c])) * sum(h in H, k in K : CK[c][k] == 1) rh[h] * x_hk[h][k];

}
