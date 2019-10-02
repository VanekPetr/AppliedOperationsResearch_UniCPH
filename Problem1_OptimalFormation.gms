$TITLE Problem 1: Optimal Formation
$eolcom //
*Applied operations research: Assignment one
*Author: Petr Vaněk
*NOTE: Results are written under the code, no need to run it

//Definition of sets for team formations, roles for each player, names of players,
//subsets for quality and strength players
Sets
    i       formations      /442, 352, 4312, 433, 343, 4321/
    j       roles           /GK, CDF, LB, RB, CMF, LW, RW, OMF, CFW, SFW/
    p       players         /P1*P25/
    pq(p)   quality players /p13, p20, p21, p22/
    ps(p)   strength player /p10, p12, p23/
;

//Table 1 from the Assignment one
Table t(i,j) number of players required for each formatin and role
        GK  CDF LB  RB  CMF LW  RW  OMF CFW SFW
442     1   2   1   1   2   1   1   0   2   0
352     1   3   0   0   3   1   1   0   1   1
4312    1   2   1   1   3   0   0   1   2   0
433     1   2   1   1   3   0   0   0   1   2
343     1   3   0   0   2   1   1   0   1   2
4321    1   2   1   1   3   0   0   2   1   0        
;

//Table 2 from the Assignment one
Table f(p,j) fitness player-role
    GK  CDF LB  RB  CMF LW  RW  OMF CFW SFW
P1  10  0   0   0   0   0   0   0   0   0
P2  9   0   0   0   0   0   0   0   0   0
P3  8.5 0   0   0   0   0   0   0   0   0
P4  0   8   6   5   4   2   2   0   0   0
P5  0   9   7   3   2   0   2   0   0   0
P6  0   8   7   7   3   2   2   0   0   0
P7  0   6   8   8   0   6   6   0   0   0
P8  0   4   5   9   0   6   6   0   0   0
P9  0   5   9   4   0   7   2   0   0   0
P10 0   4   2   2   9   2   2   0   0   0
P11 0   3   1   1   8   1   1   4   0   0
P12 0   3   0   2   10  1   1   0   0   0
P13 0   0   0   0   7   0   0   10  6   0
P14 0   0   0   0   4   8   6   5   0   0
P15 0   0   0   0   4   6   9   6   0   0
P16 0   0   0   0   0   7   3   0   0   0
P17 0   0   0   0   3   0   9   0   0   0
P18 0   0   0   0   0   0   0   6   9   6
P19 0   0   0   0   0   0   0   5   8   7
P20 0   0   0   0   0   0   0   4   4   10
P21 0   0   0   0   0   0   0   3   9   9
P22 0   0   0   0   0   0   0   0   8   8
P23 0   3   1   1   8   4   3   5   0   0
P24 0   3   2   4   7   6   5   6   4   0
P25 0   4   2   2   6   7   5   2   2   0
;

//Definition of variables for our problem
Variables
    z       total fitness of the players for objective function
    d(i)    formation i is chosen, or not
    x(p,j)  player p is playing in role j, or not
;

//Variables d and x are binary
binary variable d;
binary variable x;

//Our model for Problem 1
EQUATIONS
    NumForm         'Equation defining the number of formations'
    NumRoles(p)     'Equation defining the max number of roles for each player'
    FormRules(j)    'Equation defining needed players for each formation'
    Con1            'Equation defining the condition for quality players'
    Con2            'Equation defining the condition for strenght players'
    ObjDef          'Objective function definition';

//our s.t.
//There is only one allowed formation
NumForm        ..   SUM(i, d(i))             =e= 1;

//Each player has max one role
NumRoles(p)    ..   SUM(j, x(p,j))           =l= 1;

//Each formation has to have exact number of players with given roles (from Table 1)
FormRules(j)   ..   SUM(p, x(p,j))           =e= SUM(i, d(i)*t(i,j));

//The coach has to employ at least one quality player
Con1           ..   SUM(j, SUM(pq, x(pq,j))) =g= 1;

//If all quality players are employed, at least one strength player is employed
Con2           ..  SUM(j, SUM(pq, x(pq,j)))  =l= SUM(j, SUM(ps, x(ps,j))) +card(pq) -1;  

//our objective function
//Maximizing the total fitness player-role
ObjDef         ..   z  =e= SUM(p, SUM(j, x(p,j)*f(p,j)));


MODEL Football 'Problem1' /all/;         //declaration of the model
SOLVE Football MAXIMIZING z USING mip;   //solving statement

Display x.l, z.l, d.l;

////////////////////////////////////////////////////////////////////
/// RESULTS ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

* The coach should decide to play in the formation 4321
* The maximized total fitnes is eqaul to 97
* In the table below we can see the employed players and in which role each employed
* player should play in order to cover the roles of the formation:
*             GK         CDF          LB          RB         CMF         OMF         CFW
*
*P1        1.000
*P4                    1.000
*P5                    1.000
*P8                                            1.000
*P9                                1.000
*P10                                                       1.000
*P12                                                       1.000
*P13                                                                   1.000
*P21                                                                               1.000
*P23                                                       1.000
*P24                                                                   1.000
    