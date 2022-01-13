import sys

if len(sys.argv) != 2:
    print("Usage: python3 bidirected_edge_gen.py <dotfile>")
    exit(0)


class Graph:
    '''
    edges should have the key value pair of (int, [pair(int, int)]) meaning (from, [pair(to, eid)])
    '''
    def __init__(self):
        self.edges = dict()
class DisjointSet:
    def __init__(self):
        self.root = dict()
    def find(self, a):
        if a not in self.root:
            self.root[a] = a
        return self.root[a]
    def join(self, a, b):
        if a not in self.root:
            self.root[a] = a
        if b not in self.root:
            self.root[b] = b
        rootb = self.find(b)
        self.root[a] = rootb
dotfile = sys.argv[-1]

if __name__ == "__main__":
    graph = Graph()
    nodestr2id = dict()
    edgestr2id = dict()
    nodeid = 0
    edgeid = 0
    edgenum = 0
    with open(dotfile, "r") as f:
        for line in f:
            if "[" not in line:
                continue
            edgenum += 1
            nodes_str = line.split("[")[0]
            from_node = nodes_str.split("->")[0]
            to_node = nodes_str.split("->")[1]
            eid = line.split("[label=\"")[-1].split("\"]")[0]

            if from_node not in nodestr2id:
                nodestr2id[from_node] = nodeid
                nodeid += 1 
            if to_node not in nodestr2id:
                nodestr2id[to_node] = nodeid
                nodeid += 1 
            if eid[1:] not in edgestr2id:
                edgestr2id[eid[1:]] = edgeid
                edgeid += 1

    # node number
    print(len(nodestr2id), end=" ")
    # edge number
    print(edgenum, end=" ")
    # field number / kinds of parentheses
    print(len(edgestr2id), end=" ")

