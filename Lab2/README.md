# Lab Session 2 - Mixed Integer Linear Programs
How to implement Mixed Integer Linear Program (MILP) models using the IBM ILOG OPL language and solve them using CPLEX Optimization Studio.  
The problem is about assigning a set of tasks (processes) to a set of computers in a datacenter.  

## About
**Author**  
Marcel Cases i Freixenet &lt;marcel.cases@estudiantat.upc.edu&gt;

**Course**  
Algorithmic Methods for Mathematical Models (AMMM-MIRI)  
FIB - Universitat Politècnica de Catalunya. BarcelonaTech  
19th March, 2021  

## Tasks
**a) Implement the *P2* model in OPL and solve it using CPLEX. Use ``boolean`` to define binary variables in OPL.**  

*P2* model is the same as *P1* from the previous lab (*P1.mod*) but replacing the variable
definition `x_tc` from `float+` to `boolean`.  

Now, the decision variables are:  

````AMPL
dvar boolean x_tc[t in T, c in C];
dvar float+ z;
````

The dataset from the previous lab session (*P1.dat*) is used:

````AMPL
nTasks = 4;
nCPUs = 3;
rt = [261.27 560.89 310.51 105.80];
rc = [505.67 503.68 701.78];
````

**b) Compare *P1* and *P2* in terms of the value of the optimal solution, solving algorithm, solving time, and number of variables and constraints.**  

|                       |      P1 (LP)|      P2 (MILP)|
|:---------------------:|:-----------:|:-----------:|
| Optimal solution      | z = 0.72377 | z = 0.79924 |
| Solving algorithm     |   Simplex   |  Branch&Cut |
| Solving time          |    0.023s   |    0.029s   |
| Number of variables   |13 continuous|12 bool + 1 continuous|
| Number of constraints |      10     |      10     |

The number of variables depends in part on the dataset. In this case,
`nTasks * nCPUs`.

By using the method `cplex.getNrows()`, we get the number
of constraints the model has used.  

**c) Solve *P2* with the following data file, where a new task has been added. Analyze the obtained results and compare them when solving *P1* with the same data.**  

We introduce the following dataset to the solver:

````AMPL
nTasks = 5;
nCPUs = 3;
rt = [261.27 560.89 310.51 105.80 344.7];
rc = [505.67 503.68 701.78];
````

**Linear Program** (*P1*) results:  

````AMPL
Total load 1583.17
Total capacity 1711.13
Computers have capacity enough to handle all the tasks

Max load 92.521900732%
CPU 1 loaded at 92.521900732%
CPU 2 loaded at 92.521900732%
CPU 3 loaded at 92.521900732%

Solution
// solution (optimal) with objective 0.925219007322647
// Quality There are no bound infeasibilities.

z = 0.92522;
x_tc = [[1 0 0]
             [0 0 1]
             [0.32458 0.67542 0]
             [1 0 0]
             [0 0.74352 0.25648]];

Number of constraints: 11

Execution time: 0.391s
````

**Mixed Integer Linear Program** (*P2*) results:  

````AMPL
Total load 1583.17
Total capacity 1711.13
Computers have capacity enough to handle all the tasks
No solution found

Execution time: 0.13s
````

For the ***LP***, a solution exists, but
with the ***MILP*** there is **no solution** with this
new dataset. The problem is too restrictive.


**d) Modify the *P2* model to allow rejecting tasks, i.e. some tasks might not be processed. To this aim, consider a new parameter ``K`` defining the maximum number of tasks that can be rejected (*P2d*). Analyze the obtained results varying the value of ``K``.**  

**Constraint 1** is modified in order to allow rejecting tasks
by removing the condition that all tasks have to be
assigned as follows:

````AMPL
forall(t in T)
	sum(c in C) x_tc[t, c] <= 1;
````

**Constraint 4** is added to impose that at most `K` tasks
can be rejected as follows:

````AMPL
sum(c in C, t in T) x_tc[t,c] >= nTasks - K;
````

These are the results obtained by different `K`:

| K | z          |
|---|------------|
| 0 | Infeasible |
| 1 | 0.64194    |
| 2 | 0.51668    |
| 3 | 0.3723     |
| 4 | 0.15076    |
| 5 | 0          |

In the case that all tasks must be assigned (`K = 0`), the
problem is the same as in *(c)* (too restrictive, infeasible).  
As the allowed number of tasks to be rejected increases,
the value of the objective funcion decreases.  
If all tasks are rejected (`K >= nTasks`), the objective
value is 0 (no task is assigned anywhere, too unrestrictive).  


**e) Modify the objective function so as to minimize the amount of not served load (*P2e*).**  

Minimizing amount of not served load is the same
as maximizing the amount of served load. Thus, the
new objective function is the following:

````AMPL
maximize sum(t in T, c in C) rt[t] * x_tc[t, c];
````

The new objective function replaces **Constraint 3**, which is removed.  

**f) Compare all three models in terms of number of variables, constraints and execution time.**  

In this comparison, both *P2d* and *P2e* use the same factor `K = 1`.

|                       | P2    | P2d    | P2e    |
|-----------------------|-------|--------|--------|
| Number of variables   | 13    | 16     | 15     |
| Number of constraints | 10    | 12     | 9      |
| Execution time        | 0.13s | 0.122s | 0.087s |
