/*********************************************
 * OPL 12.8.0.0 Model
 * Author: marcel.cases
 * Creation Date: 19/3/2021 at 11:40:58
 *********************************************/

main {
	var start = new Date();
    var startTime = start.getTime();
	
	var modfiles = new Array();
	    modfiles[1] = "P1.mod";
	    modfiles[2] = "P2.mod";
	    modfiles[3] = "P2d.mod";
	    modfiles[4] = "P2e.mod";
	var src = new IloOplModelSource(modfiles[4]);
	var def = new IloOplModelDefinition(src);
	var cplex = new IloCplex();
	var model = new IloOplModel(def, cplex);
	var datafiles = new Array();
	    datafiles[1] = "P1.dat";
	    datafiles[2] = "P2.dat";
	var data = new IloOplDataSource(datafiles[2]);
	
	model.addDataSource(data);
	model.generate();
	
	cplex.tilim = 30*60; // s
	cplex.epgap = 0.01;
	
	if (cplex.solve()) {
		writeln ("\nMax load " + 100 * cplex.getObjValue() + "%");
		
		for(var c = 1; c <= model.nCPUs; c++){
			var load = 0;
			for(var t = 1; t <= model.nTasks; t++)
				load += (model.rt[t] * model.x_tc[t][c]);
			load = ( 1 / model.rc[c]) * load;
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
