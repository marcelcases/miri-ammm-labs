# Lab Session 2 - Mixed Integer Linear Programs
How to implement Mixed Integer Linear Program (MILP) models using the IBM ILOG OPL language and solve them using IBM CPLEX.

## Results
CPU load with LP model (simplex algorithm) using db1:
```
Total load 1238.47
Max load 72.377317913%
CPU 1 loaded at 72.377317913%
CPU 2 loaded at 72.377317913%
CPU 3 loaded at 72.377317913%
```

CPU load with MILP model (branch & cut algorithm) using db1:
```
Total load 1238.47
Max load 79.923907777%
CPU 1 loaded at 20.922736571%
CPU 2 loaded at 0.122395705%
CPU 3 loaded at 0.000162284%
```

CPU load with MILP model using db3 and k=1 (P2d.mod):

```
Total load 1583.17
Max load 64.193906822%
CPU 1 loaded at 7.902301595e-10%
CPU 2 loaded at 0.000243003%
CPU 3 loaded at 49.139439639%
```

We modify the objective function to minimize the amount of not served load (P2e.mod).
