$TITLE Problem 2: Key Management in Wireless Sensor Networks
$eolcom //
*Applied operations research: Assignment one
*Author: Petr Vaněk
*NOTE: Results are written under the code, no need to run it

//Definition of sets for 8 nodes and 30 keys
Sets
    n nodes /n1*n8/
    k keys /k1*k30/
;
//we need one more name j for set of nodes to check whether two nodes has the same key
ALIAS(n,j);

Scalars
    TM total memory
    m memory needed for one key 
    q needed number of keys 
    T time limit for keys
    BM Big M
;

//Set numbers for scalars
TM = 1000;                //Total memory
m = 186;                  //Each key is occupying m of the memory
q = 3;                    //Number of the same keys needed for direct connection
T = 2;                    //Limit for a key repetition
BM = 10000;               //Big M

Display TM, m, q, T;

//Definition of variables for our problem
Variable
    r maximized number of connections
    x(n,k)  saved key k on node n or not
    y(n,j,k) n and j has common key k
    z(n,j) n and j has 3 common keys
;

//Variables x,y and z are binary
Binary variable x;
Binary variable y;
Binary variable z;


//Our model for Problem 2
EQUATIONS
    LimMemory(n)    'Equation defining the limit of each node memory'
    LimKeys(k)      'Equation defining the max number of each key'
    con1(n,j,k)     'Equation defining the first condition for y'
    con2(n,j,k)     'Equation defining the second condition for y'
    con3(n,j)       'Equation defining the first condition for z'
    con4(n,j)       'Equation defining the second condition for z'
    ObjDef          'Objective function definition';
        
//our s.t.
//Each node has the memory limit which is equal to 1000kB
LimMemory(n)    ..   SUM(k,m*x(n,k)) =l= TM;

//Each key can appear in our system max T-times
LimKeys(k)      ..   SUM(n, x(n,k))  =l= T;

//if two nodes do not have the same key then y equals 0
con1(n,j,k)$(ord(j)>ord(n))     ..  (x(n,k) + x(j,k))  =g= 1 + 1 - BM*(1-y(n,j,k));

//if two nodes have the same key then y equals 1
con2(n,j,k)$(ord(j)>ord(n))     ..  2                  =g= (x(n,k)+x(j,k)) + 1 - BM*y(n,j,k);

//if two nodes do not have 3 common keys then z equals 0
con3(n,j)$(ord(j)>ord(n))       ..  SUM(k, y(n,j,k))   =g= 2 + 1 - BM*(1-z(n,j));

//if two  nodes have 3 common keys then z equals 1
con4(n,j)$(ord(j)>ord(n))       ..  q                  =g= SUM(k,y(n,j,k)) + 1 - BM*z(n,j); 

//our objective function
//Maximizing the number of direct connections (pair of nodes with three the same keys)
ObjDef          ..   r  =e= SUM(n, SUM(j$(ord(j)>ord(n)), z(n,j)));


MODEL Network 'Problem2' /all/;         //declaration of the model
SOLVE Network MAXIMIZING r USING mip;   //solving statement

Display r.l, x.l, y.l, z.l;

////////////////////////////////////////////////////////////////////
/// RESULTS ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

*The maximized number of direct connections is qeual to 4
*In the table below we can see which keys are assigned to each node in order to maximize
*the number of direct connections:
*            k3          k4          k5          k6          k7          k8         k12         k13         k14         k15         k16         k18         k19         k20         k21         k23         k24         k26         k27         k29         k30
*
*n1                                                                               1.000       1.000                   1.000                                                                   1.000                                                       1.000
*n2                   1.000                               1.000                                                                               1.000                               1.000
*n3                                                                               1.000                               1.000                                                                   1.000                                           1.000
*n4                                                                   1.000                               1.000                   1.000                   1.000       1.000
*n5                               1.000                               1.000                   1.000       1.000                                                       1.000
*n6                   1.000                               1.000                                                                                           1.000                   1.000                                           1.000
*n7       1.000                   1.000       1.000                                                                               1.000                                                                               1.000
*n8       1.000                               1.000

*Table below shows which nodes has the direct connections:
*            n3          n5          n6          n8
*
*n1       1.000
*n2                               1.000
*n4                   1.000
*n7                                           1.000                                                                                                                                                    1.000       1.000       1.000
