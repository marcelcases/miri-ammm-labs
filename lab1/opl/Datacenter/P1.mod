/*********************************************
 * OPL 12.6.0.0 Model
 * Author: m@rcel.xyz
 * Creation Date: Nov 2, 2020 at 1:16:10 PM
 *********************************************/

 int nTasks = ...;
 int nCPUs = ...;
 
 range T = 1..nTasks;
 range C = 1..nCPUs;
 
 float rt[T] = ...;
 float rc[C] = ...;
 
 dvar float+ x_tc[T, C];
 dvar float+ z;
 
 execute {
	var totalLoad = 0;
	for (var t = 1; t <= nTasks; t++)
		totalLoad += rt[t];
	writeln("Total load " + totalLoad);
	
	var totalResources = 0;
	for (var c = 1; c <= nCPUs; c++)
		totalResources += rc[c];
		
	if (totalLoad > totalResources) {
		writeln("Load cannot be served");
		stop();		
	}
	
 };
 
 // Objective
 minimize z;
 
 subject to {
	 // Constraint 1
 		forall(t in T)
 			sum(c in C) x_tc[t,c] == 1;
 	
 	// Constraint 2
 		forall(c in C)
 			sum(t in T) rt[t] * x_tc[t,c] <= rc[c];
 			
 	// Constraint 3
 		forall(c in C)
 			z >= (1/rc[c]) * sum(t in T) rt[t] * x_tc[t,c];
 			
}


execute {

	for (var c = 1; c <= nCPUs; c++) {
		var load = 0;
		for (var t = 1; t <= nTasks; t++)
			load += (rt[t] * x_tc[t][c]);
		load = (1 / rc[c]) * load;
		writeln("CPU " + c + " loaded at " + 100 * load + "%");
	}
	
};
