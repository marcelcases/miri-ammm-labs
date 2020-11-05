main {

  /* Imports a .mod file */
  var src = new IloOplModelSource("volsay3.mod");

  /* Links a model to an imported .mod file */
  var def = new IloOplModelDefinition(src);

  /* Creates a solver object */
  var cplex = new IloCplex();

  /* Links the model with the solver */
  var model = new IloOplModel(def,cplex);

  /* Imports a .dat file */
  var data = new IloOplDataSource("volsay3a.dat");

  /* Links the model with the data */
  model.addDataSource(data);

  /* Prepare model for solver to be run */
  model.generate();

  /* Call the solver */
  if (cplex.solve()) {

    /* Do whatever with the outcome of the optimization */
    writeln("Optimal profit: " + cplex.getObjValue());
    for (var c=1;c<=model.nProducts;c++) {
      writeln("Production of product #" + c + ": " + model.Production[c]);
    }
  }
  else {
    writeln("Not solution found");
  }
  data.end();
  model.end();
  cplex.end();
  def.end();
  src.end();
};
