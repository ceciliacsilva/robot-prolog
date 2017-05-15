:- use_module(library(clpfd)).

% N is the dot product of lists V1 and V2.
dot(V1, V2, N) :- maplist(product,V1,V2,P), sumlist(P,N).
product(N1,N2,N1*N2).

% Matrix multiplication with matrices represented
% as lists of lists. M3 is the product of M1 and M2
mmult(M1, M2, M3) :- transpose(M2,MT), maplist(mm_helper(MT), M1, M3).
mm_helper(M2, I1, M3) :- maplist(dot(I1), M2, M3).


%matDH

matDH(A, Alfa1, D, Teta1, T):-
    Teta = (pi*Teta1/180),
    Alfa = pi*Alfa1/180,
    A11 is cos(Teta),
    A12 is -sin(Teta)*cos(Alfa),
    A13 is sin(Teta)*sin(Alfa),
    A14 is A*cos(Teta),
    A21 is sin(Teta),
    A22 is cos(Teta)*cos(Alfa),
    A23 is -cos(Teta)*sin(Alfa),
    A24 is A*sin(Teta),
    A31 = 0,
    A32 is sin(Alfa),
    A33 is cos(Alfa),
    A34 = D,
    A41 = 0,
    A42 = 0,
    A43 = 0,
    A44 = 1,
    T = [[A11, A12, A13, A14], [A21, A22, A23, A24], [A31, A32, A33, A34], [A41, A42, A43, A44]].

a(A1, B1, C):-
    
    A = pi*A1/180,
    B = pi*B1/180,
    C is -cos(A)*cos(B).

tFinal(Teta1, Teta2, Teta3, T):-
    elos(D1, L1, L2, A1, A2, Ly),
    Alfa1 = -90,
    matDH(Ly, Alfa1, D1, Teta1, T1),
    matDH(L1, 0, A1+A2, Teta2, T2),
    matDH(L2, 0, 0, Teta3, T3),
    mmult(T1, T2, T12),
    mmult(T12, T3, T).

