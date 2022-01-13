# Dynamic Bidirected Dyck-Reachability Algorithms
This is an implementation for the dynamic algorithms for bidirected Dyck-reachability problems.
The description of the algorithm can be found in the POPL 2022 paper ``Efficient Algorithms for Dynamic Bidirected Dyck-Reachability''.

#### Build the Dynamic Algorithms
The source code of the dynamic algorithms are under the `dynamic` directory. One can build the dynamic algorithms using the following command: `cd dynamic; make`

#### Usage
To run the dynamic algorithm, use the following command:

`/path/to/DyckReach <0/1:0=recompute,1=dynamic> <initgraph.dot> <sequence.seq>.`

where <initgraph.dot> is the initial graph fed to the dynamic algorithm, and the <sequence.seq> is the edge update sequence fed to the algorithm.

#### Evaluation over DDlog
One of the evaluation requires the installation the Datalog solver [DDlog](https://github.com/vmware/differential-datalog).

We implement the Dyck language in Datalog under the file `ddlog/dyck.dl`. 
To build the DDlog implementation for the Dyck-reachability solver, please run `./compile` under the `ddlog` directory.

To generate the results for DDlog, run the following command:
`bash run_ddlog.sh`

To generate the results for Dynamic Dyck algorithms, run the following commands:
`bash ./scripts/gen_table3.sh > table3_dyndyck.out`
`bash ./scripts/gen_table4.sh > table4_dyndyck.out`
