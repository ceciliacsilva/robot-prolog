:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

% we need this module from the HTTP client library for http_read_data
:- use_module(library(http/http_client)).
:- http_handler('/', web_form, []).
:- http_handler('/cinematica', landing_pad, []).
:- http_handler('/direta', cDireta, []).
:- http_handler('/inversa', cInversa, []).
:- http_handler('/circunferencia', tCircunferencia, []).
:- http_handler('/reta', tReta, []).
:- consult(matDH).
:- consult(icm).

server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    setPeriod('servo1'),
    setPeriod('servo2'),
    setPeriod('servo3'),
    setPolarity('servo1'),
    setPolarity('servo2'),
    setPolarity('servo3'),
    dCinematica(0, 90, 90, _,_,_).
    
    
    web_form(_Request) :-
	reply_html_page(
	    title('Robotica'),
	    [
	     h1('Trabalho de robotica'),
	     form([action='/cinematica', method='POST'], [
		      p([], [
			    input([name=escolha, type=radio, value='1']), 'Cinematica direta',br([]),
			    input([name=escolha, type=radio, value='2']), 'Cinematica inversa', br([]),
			    input([name=escolha, type=radio, value='3']), 'Circunferencia', br([]), 
			    input([name=escolha, type=radio, value='4']), 'Reta', br([])
			]),
		      p([], input([name=submit, type=submit, value='Enter'], []))
		  ]),
	     br([]),
	     pre('Artigo')
	    ]).
    
landing_pad(Request) :-
    member(method(post), Request), !,
    http_read_data(Request, [escolha=E, _], []),
    % format('Content-type: text/html~n~n', []),
    % format('<p>',[]),
    atom_number(E, Opcao),
    calculos(Opcao).
    % portray_clause(Opcao).

calculos(Opcao):-
    Opcao = 2,
    reply_html_page(
	    title('Robotica'),
	    [
	     form([action='/inversa', method='POST'], [
		p([], [
		  label([for=x],'X: '),
		  input([name=x, type=textarea])
		      ]),
		p([], [
		  label([for=y],'Y: '),
		  input([name=y1, type=textarea])
		      ]),
		p([], [
		  label([for=z],'Z: '),
		  input([name=z, type=textarea])
		      ]),
		
		p([], input([name=submit, type=submit, value='Enter'], []))
	      ])]).

calculos(Opcao):-
    Opcao = 1,
    reply_html_page(
	    title('Robotica'),
	    [
	     form([action='/direta', method='POST'], [
		p([], [
		  label([for=teta1],'Teta1:'),
		  input([name=teta1, type=textarea])
		      ]),
		p([], [
		  label([for=teta2],'Teta2:'),
		  input([name=teta2, type=textarea])
		      ]),
		p([], [
		  label([for=teta3],'Teta3:'),
		  input([name=teta3, type=textarea])
		      ]),
		
		p([], input([name=submit, type=submit, value='Enter'], []))
	      ])]).

calculos(Opcao):-
    Opcao = 3,
    reply_html_page(
	    title('Robotica'),
	    [
	     form([action='/circunferencia', method='POST'], [
		p([], [
		  label([for=x],'X: '),
		  input([name=x, type=textarea])
		      ]),
		p([], [
		  label([for=r],'R: '),
		  input([name=r, type=textarea])
		      ]),
		p([], [
		  label([for=z],'Z: '),
		  input([name=z, type=textarea])
		      ]),
		
		p([], input([name=submit, type=submit, value='Enter'], []))
	      ])]).

calculos(Opcao):-
    Opcao = 4,
    reply_html_page(
	    title('Robotica'),
	    [
	     form([action='/reta', method='POST'], [
		p([], [
		  label([for=x],'X: '),
		  input([name=x, type=textarea])
		      ]),
		p([], [
		  label([for=y],'Y: '),
		  input([name=y, type=textarea])
		      ]),
		p([], [
		  label([for=z],'Z: '),
		  input([name=z, type=textarea])
		      ]),
		
		p([], input([name=submit, type=submit, value='Enter'], []))
	      ])]).


cDireta(Request) :-
    member(method(post), Request), !,
    http_read_data(Request, [teta1=Teta11, teta2=Teta21, teta3=Teta31, _], []),
    format('Content-type: text/html~n~n', []),
    format('<p>',[]),
    portray_clause('Calculando a cinematica direta'),
    atom_number(Teta11, Teta1),
    atom_number(Teta21, Teta2),
    atom_number(Teta31, Teta3),
    dCinematica(Teta1, Teta2, Teta3, X, Y, Z),
    format('</p><p>========<br></br>X = ', []),
    portray_clause(X),
    format('</p><p>Y = ', []),
    portray_clause(Y),
    format('</p><p>Z = ', []),
    portray_clause(Z),
    format('</p><br></br>'),
    format('<form action="/", method="POST">
  <input type="submit" value="Voltar">
</form> ').

cInversa(Request) :-
    member(method(post), Request), !,
    http_read_data(Request, [x=X1, y1=Y1, z=Z1, _], []),
    format('Content-type: text/html~n~n', []),
    format('<p>',[]),
    portray_clause('Calculando a cinematica indireta'),
    atom_number(X1, X),
    atom_number(Y1, Y),
    atom_number(Z1, Z),
    iCinematicaIr(Teta1, Teta2, Teta3, X, Y, Z),
    format('</p><p>========<br></br>Teta1 = ', []),
    portray_clause(Teta1),
    format('</p><p>Teta2 = ', []),
    portray_clause(Teta2),
    format('</p><p>Teta3 = ', []),
    portray_clause(Teta3),
    format('</p><br></br>'),
    format('<form action="/", method="POST">
  <input type="submit" value="Voltar">
</form> ').

tCircunferencia(Request) :-
    member(method(post), Request), !,
    http_read_data(Request, [x=X1, r=R1, z=Z1, _], []),
    format('Content-type: text/html~n~n', []),
    format('<style>
table {
    width:100%;
}
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
table#t01 tr:nth-child(even) {
    background-color: #eee;
}
table#t01 tr:nth-child(odd) {
   background-color:#fff;
}
table#t01 th	{
    background-color: black;
    color: white;
}
</style>', []),
    format('<p>', []),
    portray_clause('Trajetoria Circunferencia'),
    atom_number(X1, X),    
    atom_number(R1, R),
    atom_number(Z1, Z),
    write('<table id="t01">
  <tr>
    <th>X</th>
    <th>Y</th>		
    <th>Z</th>
    <th>Teta1</th>
    <th>Teta2</th>
    <th>Teta3</th>
  </tr>'),
    trajetoriaCircunferencia(X, Z, R),
    write('</table>'),
    format('</p><p>========<br></br>Raio = ', []),
    portray_clause(R),
    format('</p><p>Z = ', []),
    portray_clause(Z),
    format('</p><br></br>'),
    format('<form action="/", method="POST">
  <input type="submit" value="Voltar">
</form> ').

tReta(Request) :-
    member(method(post), Request), !,
    http_read_data(Request, [x=X1, y=Y1, z=Z1, _], []),
    format('Content-type: text/html~n~n', []),
    format('<style>
table {
    width:100%;
}
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
table#t01 tr:nth-child(even) {
    background-color: #eee;
}
table#t01 tr:nth-child(odd) {
   background-color:#fff;
}
table#t01 th	{
    background-color: black;
    color: white;
}
</style>', []),
    format('<p>',[]),
    portray_clause('Trajetoria Reta'),
    atom_number(X1, X),
    atom_number(Y1, Y),
    atom_number(Z1, Z),
    write('<table id="t01">
  <tr>
    <th>X</th>
    <th>Y</th>		
    <th>Z</th>
    <th>Teta1</th>
    <th>Teta2</th>
    <th>Teta3</th>
  </tr>'),
    trajetoriaReta(X, Y, Z),
    write('</table>'),
    format('</p><p>========<br></br> Y = ', []),
    portray_clause(Y),
    format('</p><p>Z = ', []),
    portray_clause(Z),
    format('</p><br></br>'),
    format('<form action="/", method="POST">
  <input type="submit" value="Voltar">
</form> ').

dCinematica(Teta1, Teta2, Teta3, X, Y, Z):-
    Teta11 is 90 + Teta1,
    Teta22 is - Teta2,
    Teta33 is Teta3,

    pinoServo('servo1', _, Min1, Max1, _, _),
    Teta11 =< Max1 + 1,
    Teta11 >= Min1 - 1,

    pinoServo('servo2', _, Min2, Max2, _, _),
    Teta2 =< Max2 + 1,
    Teta2 >= Min2 - 1,

    pinoServo('servo3', _, Min3, Max3, _, _),
    Teta3 =< Max3 + 1,
    Teta3 >= Min3 - 1,
    
    tFinal(Teta11, Teta22, Teta33, T),
    pegarPosicao(T, X, Y, Z),
    Y >= 0,
    Z >= 0,
    Teta is 90 - Teta1,
    %setDuty('servo1', Teta11),
    %setDuty('servo2', Teta2),
    %setDuty('servo3', Teta3), 
    vaiPara(Teta, Teta2, Teta3),
!.

dCinematica(_, _, _, X, Y, Z):-
    X='Sem Solucao',
    Y='Sem Solucao',
    Z='Sem Solucao'.

trajetoriaCircunferencia(X, Z, R):-
    %R > X,
    Y2 is R*R - X*X,
    Y is sqrt(Y2),
    iCinematicaIr(TetaM, Teta2, Teta3, -X, Y, Z),
    conferir(-X, Y, Z, TetaM, Teta2, Teta3),
    sleep(2),
    trajetoriaCircunferencia2(-X, Z, R, X).

trajetoriaCircunferencia2(X, _, _, XF):-
    X > XF, !.

trajetoriaCircunferencia2(X, Z, R, XF):-
    Y2 is R*R - X*X,
    Y is sqrt(Y2),
         
    iCinematica(TetaM, Teta2, Teta3, X, Y, Z),
    conferir(X, Y,Z, TetaM, Teta2, Teta3),
    sleep(0.01),
    X1 is X + 0.01,
    trajetoriaCircunferencia2(X1, Z, R, XF).
    
trajetoriaReta(X, Y, Z):-
         
    iCinematicaIr(TetaM, Teta2, Teta3, -X, Y, Z),
    conferir(-X, Y,Z, TetaM, Teta2, Teta3),
    sleep(4),
    trajetoriaReta2(-X, Y, Z, -13).

trajetoriaReta2(X, _, _, XF):-
    X < XF, !.

trajetoriaReta2(X, Y, Z, XF):-

    iCinematica(TetaM, Teta2, Teta3, X, Y, Z),
    
    conferir(X, Y, Z, TetaM, Teta2, Teta3),
    sleep(0.1),
    X1 is X - 0.5,
    trajetoriaReta2(X1, Y, Z, XF).

modulo(X,Y,Xo,Yo,M):-
{
    M * M = (X - Xo) * (X -Xo) + (Y - Yo) * (Y - Yo)
}.

vetor(X, Y, Xo, Yo,Alfa,Beta):-
    modulo(X, Y, Xo, Yo, Modulo),
    Alfa is (X - Xo) / Modulo,
    Beta is (Y - Yo) / Modulo.

trajReta(X, Y, Xo, Yo):-
    vetor(X,Y,Xo,Yo,Alfa,Beta),
    iCinematicaIr(_, _, _, Xo, Yo, 10),
    sleep(4),
    trajReta2(X,Y,Xo,Yo,Alfa,Beta,0).

trajReta2(X,_,Xo,_,_,_,_):-
    X>=Xo, !. 

trajReta2(X,Y,Xo,Yo,Alfa,Beta,T):-
    X2 is Xo + Alfa * T,
    Y2 is Yo + Beta * T,
    T1 is T + 0.01,
     
    iCinematica(TetaM, Teta2, Teta3, X2, Y2, 10),
    conferir(X2, Y2, 10, TetaM, Teta2, Teta3),
    sleep(0.05),
    trajReta2(X,Y,X2,Y2,Alfa,Beta,T1).


conferir(X, Y, Z, TetaM, Teta2, Teta3):-
    write('<tr>'),
    write('<td>'),
    write(X),
    write('</td><td>'),
    write(Y),
    write('</td><td>'),
    write(Z),
    write('</td><td>'),
    write(TetaM),
    write('</td><td>'),
    write(Teta2),
    write('</td><td>'),
    write(Teta3),
    write('</td></tr>\n').
    
