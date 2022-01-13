# Dynamic Bidirected Dyck-Reachability Algorithms
This is an implementation for the dynamic algorithms for bidirected Dyck-reachability problems.
The description of the algorithm can be found in the POPL 2022 paper ``Efficient Algorithms for Dynamic Bidirected Dyck-Reachability''.

#### Build the Dynamic Algorithms
The source code of the dynamic algorithms are under the `dynamic` directory. One can build the dynamic algorithms using the following command: `cd dynamic; make`

#### Usage
To run the dynamic algorithm, use the following command:

`/path/to/DyckReach <0/1:0=recompute,1=dynamic> <initgraph.dot> <sequence.seq>.`

where <initgraph.dot> is the initial graph fed to the dynamic algorithm, and the <sequence.seq> is the edge update sequence fed to the algorithm.

#### Data Format
The initial graph should be a text file satisfying the following format:
For each line in the graph file, it should be in the format of `first_node_id->second_node_id[label="edge_type--edge_id"]`

The first_node_id and second_node_id are the node ids for the ids of the two end-nodes for the edge. The edge_type can be "op", "cp", representing the open-parenthesis and close-parenthesis. The edge-id should be the index of the parenthesis type. 

The edge update file should be a text file with each line satisfying the following format: `update_type first_node_id second_node_id edge_type--edge_id`
The update_type can be "A" or "D", which means adding or deleting edges.

Examples for the data files can be found in the `benchmark` directory.

#### Evaluation over DDlog
One of the evaluation requires the installation the Datalog solver [DDlog](https://github.com/vmware/differential-datalog).

We implement the Dyck language in Datalog under the file `ddlog/dyck.dl`. 
To build the DDlog implementation for the Dyck-reachability solver, please run `./compile` under the `ddlog` directory.

To generate the results for DDlog, run the following command:
`bash run_ddlog.sh`

To generate the results for Dynamic Dyck algorithms, run the following commands:
`bash ./scripts/gen_table3.sh > table3_dyndyck.out`
`bash ./scripts/gen_table4.sh > table4_dyndyck.out`

The previous commands will generate experimental result tables.

An alternative evaluation docker container artifact can also be found via [zenodo link](https://doi.org/10.5281/zenodo.5553759). 
