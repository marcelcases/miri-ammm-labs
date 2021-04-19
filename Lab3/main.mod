/*********************************************
 * OPL 12.8.0.0 Model
 * Author: marcel.cases
 * Creation Date: 09/4/2021 at 11:40:58
 *********************************************/

main {
	var start = new Date();
    var startTime = start.getTime();
	
	var modfiles = new Array();
	    modfiles[1] = "P3.mod";
	    modfiles[2] = "P3a.mod";
	var src = new IloOplModelSource(modfiles[1]);
	var def = new IloOplModelDefinition(src);
	var cplex = new IloCplex();
	var model = new IloOplModel(def, cplex);
	var datafiles = new Array();
	    datafiles[0] = "sample.dat";
	    datafiles[1] = "dat1.dat";
	    datafiles[2] = "dat2.dat";
	    datafiles[3] = "dat3.dat";
	    datafiles[4] = "dat4.dat";
	    datafiles[5] = "dat5.dat";
	var data = new IloOplDataSource(datafiles[0]);
	
	model.addDataSource(data);
	model.generate();
	
	cplex.tilim = 10*60; // s
	cplex.epgap = 0.02;
	
	if (cplex.solve()) {
		writeln ("\nMax load " + 100 * cplex.getObjValue() + "%");
		
		for(var c = 1; c <= model.nCPUs; c++){
			var load = 0;
			for(var t = 1; t <= model.nTasks; t++)
				load += (model.rh[t] * model.x_tc[t][c]);
			load = (1 / model.rc[c]) * load;
			writeln("CPU " + c + " loaded at " + 100 * load + "%");
		}
		
		writeln("\nSolution\n" + model.printSolution());
		writeln("\nNumber of constraints: " + cplex.getNrows());
	}
	else {
		writeln("No solution found");
	}
	
	model.end();
	data.end();
	def.end();
	cplex.end();
	src.end();
	
	// Write execution time
    var end = new Date();
    var endTime = end.getTime();
    writeln("\nExecution time: " + (endTime - startTime)/1000 + "s");
};
