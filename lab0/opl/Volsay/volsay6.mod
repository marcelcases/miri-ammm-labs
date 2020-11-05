main {

  // Store initial time
  var start = new Date();
  var startTime = start.getTime();

  // Set a file for output
  var out = new IloOplOutputFile("output.txt");

  // Array of file names for .dat files
  var files = new Array();   // Create an empty array
  files[0] = "volsay3a.dat"; // Set the element 0
  files[1] = "volsay3b.dat"; // Set the element 1

  var src = new IloOplModelSource("volsay3.mod");
  var def = new IloOplModelDefinition(src);
  var cplex = new IloCplex();

  // Set a time limit for CPLEX of 60 s
  cplex.tilim=60;

  for (var i = 0; i <= 1; ++i) {

    out.writeln("Iteration #" + i);

    var model = new IloOplModel(def,cplex);
    var data = new IloOplDataSource(files[i]);

    model.addDataSource(data);
    model.generate();

    if (cplex.solve()) {
      out.writeln("Optimal profit: " + cplex.getObjValue());
      for (var c=1;c<=model.nProducts;c++) {
        out.writeln("Production of product #" + c + ": " + model.Production[c]);
      }
    }
    else {
      out.writeln("Not solution found");
    }
    data.end();
    model.end();
  }
  cplex.end();
  def.end();
  src.end();

  // Write execution time
  var end = new Date();
  var endTime = end.getTime();
  out.writeln("Execution time: " + (endTime - startTime) + "ms");
};
