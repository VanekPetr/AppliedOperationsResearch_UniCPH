$TITLE Problem 3: Fleet Planning
$eolcom //
*Applied operations research: Assignment one
*Author: Petr Vaněk
*NOTE: Results are written also under the code, no need to run it

//Definition of sets for 5 ships, 2 routes, 8 ports and two incompatiable pairs of ports
Sets
    v ships /v1*v5/
    r routes /Asia, ChinaPacific/
    p ports /Singapore, Incheon, Shanghai, Sydney, Gladstone, Dalian, Osaka, Victoria/
    h1(p) first pair /Singapore, Osaka/
    h2(p) second pair /Incheon, Victoria/
;

//Given data about costs of the ships, number of days for each ship to sail,
//cost of each route for given ship, needed time for each route and given ship
//needed number of visits for each port, and data about which route passes through each port
Parameters
F(v) cost of the ship /v1 65,v2 60,v3 92, v4 100, v5 110/
G(v) days in a year /v1 300, v2 250, v3 350, v4 330, v5 300/
C(v,r) cost of one route /v1 . Asia 1.41
                          v2 . Asia 3.0
                          v3 . Asia 0.4
                          v4 . Asia 0.5
                          v5 . Asia 0.7
                          v1 . ChinaPacific 1.9
                          v2 . ChinaPacific 1.5
                          v3 . ChinaPacific 0.8
                          v4 . ChinaPacific 0.7
                          v5 . ChinaPacific 0.8/
T(v,r) time for one route /v1 . Asia 14.4
                           v2 . Asia 13.0
                           v3 . Asia 14.4
                           v4 . Asia 13.0
                           v5 . Asia 12.0
                           v1 . ChinaPacific 21.2
                           v2 . ChinaPacific 20.7
                           v3 . ChinaPacific 20.6
                           v4 . ChinaPacific 19.2
                           v5 . ChinaPacific 20.1/
D(p) visits of the port /Singapore 15
                         Incheon 18
                         Shanghai 32
                         Sydney 32
                         Gladstone 45
                         Dalian 32
                         Osaka 15
                         Victoria 18/
A(r,p) passes through p /Asia . Singapore 1
                         Asia . Incheon 1
                         Asia . Shanghai 1
                         Asia . Sydney 0
                         Asia . Gladstone 0
                         Asia . Dalian 1
                         Asia . Osaka 1
                         Asia . Victoria 0
                         ChinaPacific . Singapore 0
                         ChinaPacific. Incheon 0
                         ChinaPacific . Shanghai 1
                         ChinaPacific . Sydney 1
                         ChinaPacific . Gladstone 1
                         ChinaPacific . Dalian 1
                         ChinaPacific . Osaka 0
                         ChinaPacific . Victoria 1/
;

Scalar
    PM number of served ports (at least)
    M big M
;
//Set numbers for scalars
PM = 5;
M = 1000000;


//Definition of variables for our problem
Variable
    z minimized costs for objective function
    k(v,r) how many times each available ship sail each route
    ship(v) this ship is used or not
    port(p) this port is served or not
;

//Variable k is integer
Integer variable k;

//Variables ship and port are binary
Binary variable ship;
Binary variable port;
    
//Our model for Problem 3
EQUATIONS
    LimDays(v)      'Equation defining the time limit for each ship'
    extra3(v)       'Equation defining the the condition for binary variable ship'
    VisitPort(p)    'Equation defining the needed number of visits for each port'
    NumPorts        'Equation defining the minimal number of ports'
    Con1            'Equation defining the first pair of ports'
    Con2            'Equation defining the second pair of ports'   
    ObjDef          'Objective function definition';
    
//our s.t.
//Each ship ship v can sail only G(v) days
LimDays(v)      ..   SUM(r, k(v,r)*T(v,r))          =l= G(v);

//If ship v was at least once on route r, then binary variable ship equals 1
extra3(v)       ..   1 =g= SUM((p,r), k(v,r)*A(r,p))+1 -M*ship(v);

//Each "used" port has to be visited at least D(p) times
VisitPort(p)    ..   SUM(r, SUM(v, k(v,r)*A(r,p)))  =g= D(p)*port(p);

//Conpany has to use at least 5 ports
NumPorts        ..   SUM(p, port(p))                =g= PM;

//Company can visit at most one port from pair (Singapore, Osaka)
Con1            ..   SUM(h1, port(h1))              =l= 1;   

//Company can visit at most one port from pair (Incheon, Victoria)
Con2            ..   SUM(h2, port(h2))              =l= 1; 

//our objective function
//Minimizing the fixed cost for each used ship and cost for sailing each chosen route
ObjDef          ..   z   =e= SUM(v, ship(v)*F(v)) + SUM(r,SUM(v, k(v,r)*C(v,r)));

MODEL FleetPlan 'Problem3' /all/;           //declaration of the model
SOLVE FleetPlan MINIMIZING z USING minlp;   //solving statement

Display z.l, ship.l, port.l, k.l;

////////////////////////////////////////////////////////////////////
/// RESULTS ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

*Company should use ship v1, v2 and v3, should service ports Shanghai, Sydney,
*Dalian, Osaka and Victoria.
*Minimized the total yearly cost is 274.300 million dollars.
*In the table below we can observe how many times each of chosen ships should
*sail given route:
*          Asia  ChinaPacic
*
*v1                  14.000
*v2       1.000      11.000
*v3      14.000       7.000

             