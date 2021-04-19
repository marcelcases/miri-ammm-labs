# Lab Session 3 - More on Mixed Integer Linear Programs
How to implement Mixed Integer Linear Program (MILP) models using the IBM ILOG OPL language and solve them using CPLEX Optimization Studio.

The problem is about assigning a set of tasks (processes) to a set of computers in a datacenter.

A Python script is used to generate instances of increasing size to test the performance of the solver.

## About
**Author**  
Marcel Cases i Freixenet &lt;marcel.cases@estudiantat.upc.edu&gt;

**Course**  
Algorithmic Methods for Mathematical Models (AMMM-MIRI)  
FIB - Universitat Politècnica de Catalunya. BarcelonaTech  
9th April, 2021

## Tasks

**a) Implement the *P3* model in OPL and solve it using CPLEX with the following data file**

The model is implemented in `P3.mod` and the sample data file is in `sample.dat`.

The output of the solver is the following:

````AMPL
Total load 1644.32
Total capacity 1711.13
Computers have capacity enough to handle all the tasks

Max load 53.282605185%
CPU 1 loaded at 162.588249253%
CPU 2 loaded at 111.35840216%
CPU 3 loaded at 37.229616119%

Solution
// solution (optimal) with objective 0.532826051849107
// Quality Incumbent solution:
// MILP objective                                 5.3282605185e-01
// MILP solution norm |x| (Total, Max)            1.25328e+01  1.00000e+00
// MILP solution error (Ax=b) (Total, Max)        2.84217e-14  2.84217e-14
// MILP x bound error (Total, Max)                0.00000e+00  0.00000e+00
// MILP x integrality error (Total, Max)          0.00000e+00  0.00000e+00
// MILP slack bound error (Total, Max)            0.00000e+00  0.00000e+00
// 

z = 0.53283;
x_hk = [[0 1 0 0 0 0 0 0 0]
             [1 0 0 0 0 0 0 0 0]
             [0 0 0 0 0 0 1 0 0]
             [0 0 0 0 0 0 0 1 0]
             [0 0 0 0 1 0 0 0 0]
             [0 0 0 1 0 0 0 0 0]
             [1 0 0 0 0 0 0 0 0]
             [1 0 0 0 0 0 0 0 0]];
x_tc = [[1 0 0]
             [0 0 1]
             [0 1 0]
             [1 0 0]];


Number of constraints: 32

Execution time: 0.033s

````

**b) Generate instances of increasing size with the instance generator script and use the *P3* model to solve them**

The following **feasible instances** have been generated:

| Instance (.dat) | nTasks | nThreads | nCPUs | nCores |
|-----------------|--------|----------|-------|--------|
| dat1            | 20     | 29       | 15    | 25     |
| dat2            | 25     | 36       | 20    | 37     |
| dat3            | 30     | 45       | 26    | 49     |
| dat4            | 32     | 45       | 28    | 61     |
| dat5            | 35     | 56       | 30    | 61     |

The execution results are reported at *(d)*.

**c) Modify the *P3* model to maximize the number of computers with all their cores empty (*P3a*)**

The objective function is redefined in order to maximize the number of computers with all their cores empty, or in other words, to minimize the number of computers with all their cores working:

````AMPL
minimize sum(h in H, k in K) x_hk[h][k];
````

**d) Compare both models (*P3* and *P3a*) in terms of number of variables, constraints and execution time for the generated instances. Recall that you can tune the `epgap` param to control when CPLEX stops**

Models comparison and execution:

For *P3*

| Instance (.dat) | Execution time (s) | Objective value z | Number of constraints |
|-----------------|--------------------|-------------------|-----------------------|
| dat1            | 1.514              | 0.39425           | 369                   |
| dat2            | 2.698              | 0.41054           | 593                   |
| dat3            | 40.418             | 0.3677            | 900                   |
| dat4            | 4.825              | 0.31081           | 1030                  |
| dat5            | 186.653            | 0.3597            | 1197                  |

For *P3a*

| Instance (.dat) | Execution time (s) | Objective value z | Number of constraints |
|-----------------|--------------------|-------------------|-----------------------|
| dat1            | 0.117              | 0.29              | 354                   |
| dat2            | 0.275              | 0.36              | 573                   |
| dat3            | 0.507              | 0.45              | 874                   |
| dat4            | 0.586              | 0.45              | 1002                  |
| dat5            | 0.82               | 0.56              | 1167                  |

Parameter `epgap` was set to `0.01`, and time limit `tilim` to 10 min.
