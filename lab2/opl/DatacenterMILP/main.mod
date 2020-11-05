/*********************************************
 * OPL 12.10.0.0 Model
 * Author: marce
 * Creation Date: 5 Nov 2020 at 19:32:19
 *********************************************/

 main {
	var src = new IloOplModelSource("P2e.mod");
	var def = new IloOplModelDefinition(src);
	var cplex = new IloCplex();
	var model = new IloOplModel(def,cplex);
	var data = new IloOplDataSource("db3.dat");
	model.addDataSource(data);
	model.generate();
	cplex.epgap = 0.01;
	if (cplex.solve()) {
		writeln("Max load " + 100 * cplex.getObjValue() + "%");
		for (var c = 1; c <= model.nCPUs; c++) {
			var load = 0;
			for (var t = 1; t <= model.nTasks; t++) {
				load += (model.rt[t] * model.x_tc[t][c]);
				load = (1/model.rc[c]) * load;
 			}			
			writeln("CPU " + c + " loaded at " + 100 * load + "%");
		}
	}
  	else {
		writeln("No solution was found");
  	}
	model.end();
	data.end();
	def.end();
	cplex.end();
	src.end();
};
