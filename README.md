# Transitive Closure


In this project I implement a domain-specific programming
language that allows me to specify network topologies and check their
connectivity. Production datacenters and commercial networks are
composed of myriad hosts, routers, and switches, connected in a
complex web of infrastructure.

In this project, I built a minimal language for expressing
network topologies and implement transitive closure, the algorithm for
graph reachability. This will allow to check for connectivity
properties of (potentially huge) graphs. My language is loosely
inspired by [NetKAT](https://cornell-pl.github.io/cs6114/netkat.html).

## Input Format

Networks include various pieces of physical infrastructure: routers,
switches, and servers. In this project every entity capable of sending or receiving 
data are "nodes" which are connected by (directed) links. Both nodes and 
links are specified as commands, each command residing on a unique line 
of the input file format. Syntactically, the two specification commands
are (a) the `NODE <name>` command, which specifies the existence of a node 
named `<name>` and (b) the `LINK <from> <to>` command, which establishes a
(directed) link from node `<from>` to node `<to>`. For convenience,
assume all nodes are specified before any occurrences of `LINK`
commands. For example, the following is valid:

```
NODE node0-name
NODE node1-name
LINK node0-name node1-name
```

This can be visualised in the following way:

```
    +------------+  link    +------------+
    | node0-name | -------> | node1-name |
    +------------+          +------------+
```

Graphs of links are represented as Racket `hashes`. 

To represent a graph as a hash: keys will be strings, and their associated values will
be sets of strings, manipulated using Racket's `set`s. For example,
the first example graph would be represented as

```
(define x (hash "node0-name" (set "node1-name")
                "node1-name" (set "node2-name")))
```

`set-add` is used to add a new link to the graph in order to
extend the set of nodes. For example, consider that we wanted to
extend the above graph with a pointer from `node0-name` to
`node3-name`, it would look like the following:

```
(hash-set x "node0-name" (set-add (hash-ref x "node0-name") "node3-name"))
```

- `(parse-line l)` -- Parses an input line given as a string
  and transforms it into an output that conforms to
  `line?`, using `string-split` and matching. 

- `(forward-link? graph n0 n1)` -- Checks whether there is a forward
  link from `n0` to `n1` in the graph `graph`. Returns `#t` iff `n1` is
  linked to from (pointed at by) `n0`. 

- `(add-link graph from to)` -- Adds an "edge" in the graph from node 
  `from` to node `to`, using `hash-ref`, `set-add`, and `hash-set`. 
 

- `(build-init-graph input)` -- Assuming that `input` is a program given
  as input. This function will build up an *initial* graph datastructure
  corresponding to the program. Essentially, it is building an
  initial graph upon which it will subsequently perform iterative
  rounds of transitive closure.This will be done by changing the hash of
  each line of input in one of two ways:

    -> When it encounters a `(node <n>)` command, it will add a self link
    between `n` and itself.
    -> When it encounters a `(link <from> <to>)` command, it will insert an
    edge from `from` to `to`.

- `(transitive-closure graph)` -- Performs the transitive closure of
  the graph `graph`. 

