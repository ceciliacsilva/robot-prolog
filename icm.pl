:- use_module(library(clpr)).
:- consult(funcoes).

iCinematicaN(Teta11, Teta21, Teta31, X, Y, Z1, D1, L1, L2, A1, A2, Ly):-
{
    %X =< - D,
    H =< L1 + L2,
    Z =< L1 + L2 + D1,
    Z = Z1 - D1, % nao ta no plano do chao
    Teta3 = 3.1416*Teta31/180,
    Teta1 = 3.1416*Teta11/180,
    Teta2 = 3.1416*Teta21/180,
    Teta3 = 3.1416 - A,
    D = A1 + A2,
    
    H*H = Y*Y + X*X, 
    H*H = D*D + R1*R1,
    R = R1 - Ly,
    tan(Beta) = Y/X,
    tan(Alfa1) = R1/D,
    Teta + Beta = Alfa1,
    Teta1 = Teta,
    
    R2*R2 = Z*Z + R*R,
    R2*R2 = L1*L1 + L2*L2 - 2*L1*L2*cos(A),
    sin(T) = Z/R2,
    Lado = L1 + L2*cos(Teta3),
    tan(Beta1) = L2*sin(Teta3) / Lado,
    Teta2 = Beta1 + T
    /*
    Teta11 = 3.14,
    Teta21 = 1,
    Teta31 = 2
    */
}.

iCinematicaP( Teta11, Teta21, Teta31, X, Y, Z1, D1, L1, L2, A1, A2, Ly):-
{
    %X > -D,
    
    H =< L1 + L2,
    Z =< L1 + L2 + D1,
    Z = Z1 - D1, % nao ta no plano do chao
    Teta3 = 3.1416*Teta31/180,
    Teta1 = 3.1416*Teta11/180,
    Teta2 = 3.1416*Teta21/180,
    Teta3 = 3.1416 - A,
    D = A1 + A2,
    
    H*H = Y*Y + X*X,
    H*H = D*D + R1*R1,
    R = R1 - Ly,
    tan(Beta) = Y/X,
    tan(Alfa1) = R1/D,
    Teta + Beta + Alfa1 = 3.1416,
    Teta1 = Teta,
    
    R2*R2 = Z*Z + R*R,
    R2*R2 = L1*L1 + L2*L2 - 2*L1*L2*cos(A),
    sin(T) = Z/R2,
    Lado = L1 + L2*cos(Teta3),
    tan(Beta1) = L2*sin(Teta3) / Lado,
    Teta2 = Beta1 + T
    
}.

iCinematicaN2( Teta11, Teta21, Teta31, X, Y, Z1, D1, L1, L2, A1, A2, Ly):-
{
    %X > -D,
    
    H =< L1 + L2,
    Z =< L1 + L2 + D1,
    Z = Z1 - D1, % nao ta no plano do chao
    Teta3 = 3.1416*Teta31/180,
    Teta1 = 3.1416*Teta11/180,
    Teta2 = 3.1416*Teta21/180,
    Teta3 = 3.1416 - A,
    D = A1 + A2,
    
    H*H = Y*Y + X*X,
    H*H = D*D + R1*R1,
    R = R1 - Ly,
    tan(Beta) = Y/X,
    tan(Alfa1) = R1/D,
    Teta + Alfa1 = Beta,
    Teta1 = Teta,
    
    R2*R2 = Z*Z + R*R,
    R2*R2 = L1*L1 + L2*L2 - 2*L1*L2*cos(A),
    sin(T) = Z/R2,
    Lado = L1 + L2*cos(Teta3),
    tan(Beta1) = L2*sin(Teta3) / Lado,
    Teta2 = Beta1 + T
    
}.


iCinematica(Teta11, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    D is A1 + A2,
    X =< - D,
    X1 = - X,
    iCinematicaN(Teta11, Teta2, Teta3, X1, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is 90 - Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
       
    setDuty('servo1', Teta),
    setDuty('servo2', Teta2),
    setDuty('servo3', Teta3),
    escreverAngulos(Teta, Teta2, Teta3),!.

iCinematica(Teta1, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    
    X < 0,
    X1 = - X,
    iCinematicaN2(Teta11, Teta2, Teta3, X1, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is Teta11 + 90,
    Teta1 is -Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
       
    setDuty('servo1', Teta),
    setDuty('servo2', Teta2),
    setDuty('servo3', Teta3),
    escreverAngulos(Teta, Teta2, Teta3),!.

iCinematica(Teta1, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    
    iCinematicaP(Teta11, Teta2, Teta3, X, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is Teta11 + 90,
    Teta1 is -Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
       
    setDuty('servo1', Teta),
    setDuty('servo2', Teta2),
    setDuty('servo3', Teta3),
    escreverAngulos(Teta, Teta2, Teta3),!.

iCinematica(Teta1, Teta2, Teta3, _, _, _):-
    Teta1 = 'sem solucao',
    Teta2 = 'sem solucao',
    Teta3 = 'sem solucao'.

iCinematicaIr(Teta11, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    D is A1 + A2,
    X =< - D,
    X1 = - X,
    iCinematicaN(Teta11, Teta2, Teta3, X1, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is 90 - Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
       
    vaiPara(Teta, Teta2, Teta3), !.

iCinematicaIr(Teta1, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    
    X < 0,
    X1 = - X,
    iCinematicaN2(Teta11, Teta2, Teta3, X1, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is Teta11 + 90,
    Teta1 is -Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
       
    vaiPara(Teta, Teta2, Teta3), !.

iCinematicaIr(Teta1, Teta2, Teta3, X, Y, Z):-
    Z >= 0,
    Y >= 0,
    elos(D1, L1, L2, A1, A2, Ly),
    
    iCinematicaP(Teta11, Teta2, Teta3, X, Y, Z, D1, L1, L2, A1, A2, Ly),
    Teta is Teta11 + 90,
    Teta1 is -Teta11,
    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta =< Max1 + 1,
    Teta >= Min1 - 1,
    
    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
    
    vaiPara(Teta, Teta2, Teta3), !.

iCinematicaIr(Teta1, Teta2, Teta3, _, _, _, _, _, _, _):-
    Teta1 = 'sem solucao',
    Teta2 = 'sem solucao',
    Teta3 = 'sem solucao'.
