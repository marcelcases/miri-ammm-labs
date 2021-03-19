# Lab Session 1 - Linear Programs
How to implement Linear Program (LP) models using the IBM ILOG OPL language and solve them using CPLEX Optimization Studio.  
The problem is about assigning a set of tasks (processes) to a set of computers in a data center.  

## About
**Author**  
Marcel Cases i Freixenet &lt;marcel.cases@estudiantat.upc.edu&gt;

**Course**  
Algorithmic Methods for Mathematical Models (AMMM-MIRI)  
FIB - Universitat Politècnica de Catalunya. BarcelonaTech  
5th March, 2021  

## Tasks
**a) Explain the P1 model in eq. (2)-(5). Specifically, define each of the constraints.**  
The model for this problem is a linear program defined by the following equations:  

* _Eq. (2)_ is the **objective function**. It consists in distributing the tasks `T` among all computers `C` so to minimize the load of the computer running at the highest load `max sum (rt/rc) · xtc`.  
* _Eq. (3)_ is the **first constraint**. It forces the ratio of resources requested by task `t` that are served from computer `c` to be 1, for all task `t` in the set `T`, in order to distribute the load equally.  
* _Eq. (4)_ is the **second constraint**. It imposes that for all computers `c` in the set `C`, the sum of the resources requested by each task `t` by its ratio on computer `c` does not exceed the capacity of the computer `rc`.  
* _Eq. (5)_ is the **third constraint**. It makes the load of the highest loaded computer `z` to be greater or equal than the weighted average of resources requested by task `t` on computer `c`.  

All variables are assumed to be real positive numbers (`float+`).  

**b) Explain how equation (1) is implemented in the model P1. Specifically, why z
is guaranteed to be equal to the load of the highest loaded computer?**  
_Eq. (1)_ is implemented as the 3rd constraint (_Eq. (5)_). `z` is defined as a positive, real number greater or equal to the sum of the loads each computer `c` has. Given that we are minimizing `z`, we make sure that it is equal to the load of the highest loaded computer.  

**c) Implement the P1 model in OPL following the steps in section 3 and solve it
using CPLEX with the provided input data.**  
The execution output for this implementation is the following:
```
Total load 1238.47
// solution (optimal) with objective 0.723773179127243
CPU 1 loaded at 72.377317913%
CPU 2 loaded at 72.377317913%
CPU 3 loaded at 72.377317913%
```

**d) Write a pre-processing block to check whether computers have enough total
capacity to serve the resources requested by all the tasks.**  
The following pre-processing script will check whether computers can handle all the tasks.
```AMPL
execute {
	var totalLoad = 0;
	for (var t = 1; t <= nTasks; t++)
		totalLoad += rt[t];
	writeln("Total load " + totalLoad);
	
	var totalCap = 0;
	for (var c = 1; c <= nCPUs; c++)
		totalCap += rc[c];
	writeln("Total capacity " + totalCap);
	
	if (totalLoad <= totalCap) {
		writeln("Computers have capacity enough to handle all the tasks");
	} else {
		writeln("Computers DO NOT HAVE capacity enough to handle all the tasks");
	}
};
```

**e) Implement the P1 model in OPL following the steps in section 4 and solve it
using CPLEX with the provided input data.**  
The execution output for this implementation is the following:
```
Total load 1238.47
Total capacity 1711.13
Computers have capacity enough to handle all the tasks
Max load 72.377317913%
CPU 1 loaded at 72.377317913%
CPU 2 loaded at 72.377317913%
CPU 3 loaded at 72.377317913%
```

**f) Analyze the optimal solution obtained in e): Would it be possible to reduce the
capacity of all computers uniformly by the same percentage? If so, which
percentage?**  
The optimal solution shows that, with all CPUs at the same load `72.37%`, all the tasks are handled and equally distributed among all computers. Since there are no differences in the load capacity, all CPUs could be downsized by `~27%` and the tasks would still be handled.
