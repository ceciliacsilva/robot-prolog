tempoEspera(A):-
    A = 0.00001.

caminhoServo(C):-
    %C = "/sys/devices/ocp.3/pwm_test_".
    C='teste'.

listaMotores(Lista):-
    Lista = [[0,90,90],[20,90,90],[-20,90,90],[50,20,100],[-20,40,60],[-10.43,60,78.26]].

gerador_resultados:-
    listaMotores(Lista),
    gerador_resultados(Lista).
gerador_resultados([]):-!.
gerador_resultados(Lista):-
    Lista = [[T1,T2,T3]|T],
    dCinematica(T1,T2,T3,X,Y,Z),
    iCinematica(T1i,T2i,T3i,X,Y,Z),
    resultado_arquivo(T1,T2,T3,T1i,T2i,T3i,'T1','T2','T3'),
    gerador_resultados(T).
    

resultado_arquivo(T1,T2,T3,T11,T22,T33,W,X,Z):-
    open('resultado.txt',append,F),
    write(F,W),write(F,' = '),write(F,T1),write(F,";"),nl(F),
    write(F,X),write(F,' = '),write(F,T2),write(F,";"),nl(F),
    write(F,Z),write(F,' = '),write(F,T3),write(F,";"),nl(F),
    write(F,W),write(F,' = '),write(F,T11),write(F,";"),nl(F),
    write(F,X),write(F,' = '),write(F,T22),write(F,";"),nl(F),
    write(F,Z),write(F,' = '),write(F,T33),write(F,";"),nl(F),
    nl(F),
    close(F).    

pinoServo(Servo, Pino, AngI, AngF, DutyI, DutyF):-
    Servo = 'servo1',
    Pino = "P9_16.12",
    AngI = 0,
    AngF = 180,
    DutyI = 2260000,
    DutyF = 660000.

pinoServo(Servo, Pino, AngI, AngF, DutyI, DutyF):-
    Servo = 'servo2',
    Pino = "P8_13.16",
    AngI = 0,
    AngF = 180,
    DutyI = 2195000,
    DutyF = 605000.

pinoServo(Servo, Pino, AngI, AngF, DutyI, DutyF):-
    Servo = 'servo3',
    Pino = "P9_29.14",
    AngI = 0,
    AngF = 130,
    DutyI = 890000,
    DutyF = 2290000.

setPeriod(Servo):-
    pinoServo(Servo, Pino, _, _, _, _),
    caminhoServo(A),
    text_to_string(A, C),
    string_concat(C, Pino, Buf1),
    string_concat(Buf1, '/period', Buf),
    escreverArq(Buf, 20000000).

setPolarity(Servo):-
    pinoServo(Servo, Pino, _, _, _, _),
    caminhoServo(A),
    text_to_string(A, C),
    string_concat(C, Pino, Buf1),
    string_concat(Buf1, '/polarity', Buf),
    escreverArq(Buf, 0).

setDuty(Servo, Ang):-
    pinoServo(Servo, Pino, AngI, AngF, DutyI, DutyF),
    caminhoServo(A),
    text_to_string(A, C),
    string_concat(C, Pino, Buf1),
    string_concat(Buf1, '/duty', Buf),
    map(Ang, Duty, AngI, AngF, DutyI, DutyF),
    escreverArq(Buf, Duty).

elos(D1, D2, D3, A1, A2, Ly):-
    D1 = 9.0,
    D2 = 10.55,
    D3 = 14.45,
    A1 = 4.00,
    A2 = 2.9,
    Ly = 0.7.

pegarPosicao(T, X, Y, Z):-
    [[_, _, _, X],[_, _, _, Y],[_, _, _, Z], [_, _, _, _]] = T.

map(Ang, Duty, AngIni, AngF, DutyIni, DutyF):-
    A1 = Ang - AngIni,
    A2 = AngF - AngIni,
    % D1 = Duty - DutyIni,
    D2 = DutyF - DutyIni,
    Duty2 is A1/A2 * D2 + DutyIni,
    Duty is truncate(Duty2).

escreverArq(NomeArq, Conteudo):-
    open(NomeArq, write, _, [alias(input)]),
    write(input, Conteudo),
    close(input).

lerArq(NomeArq, Conteudo):-
    open(NomeArq, read, Fd),
    read_line_to_codes(Fd, ConteudoC),
    number_codes(Conteudo, ConteudoC),
    close(Fd).

escreverAngulos(Teta1, Teta2, Teta3):-
    escreverArq('motor1', Teta1),
    escreverArq('motor2', Teta2),
    escreverArq('motor3', Teta3).

vaiPara(Teta1, Teta2, Teta3):-
    irMotor('motor1', Teta1),
    irMotor('motor2', Teta2),
    irMotor('motor3', Teta3),
    escreverAngulos(Teta1, Teta2, Teta3).

irMotor(Nome, Teta):-
    Nome = 'motor1',
    lerArq('motor1', Valor),
    Valor < Teta,
    irFrente('motor1', Teta, Valor),
    setDuty('servo1', Teta).

irMotor(Nome, Teta):-
    Nome = 'motor1',
    lerArq('motor1', Valor),
    Valor > Teta,
    irReverso('motor1', Teta, Valor),
    setDuty('servo1', Teta).


irMotor(Nome, Teta):-
    Nome = 'motor2',
    lerArq('motor2', Valor),
    Valor < Teta,
    irFrente('motor2', Teta, Valor),
    setDuty('servo2', Teta).

irMotor(Nome, Teta):-
    Nome = 'motor2',
    lerArq('motor2', Valor),
    Valor > Teta,
    irReverso('motor2', Teta, Valor),
    setDuty('servo2', Teta).

irMotor(Nome, Teta):-
    Nome = 'motor3',
    lerArq('motor3', Valor),
    Valor < Teta,
    irFrente('motor3', Teta, Valor),
    setDuty('servo3', Teta).

irMotor(Nome, Teta):-
    Nome = 'motor3',
    lerArq('motor3', Valor),
    Valor > Teta,
    irReverso('motor3', Teta, Valor),
    setDuty('servo3', Teta).

irMotor(_, _):-
    !.

irFrente(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor1',
    Valor < Teta,
    setDuty('servo1', Valor),
    Valor1 is Valor + 5,
    irFrente(Nome, Teta, Valor1).

irFrente(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor1',
    setDuty('servo1', Teta), !.

irFrente(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor2',
    Valor < Teta,
    setDuty('servo2', Valor),
    Valor1 is Valor + 5,
    irFrente(Nome, Teta, Valor1).

irFrente(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor2',
    setDuty('servo2', Teta), !.

irFrente(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor3',
    Valor < Teta,
    setDuty('servo3', Valor),
    Valor1 is Valor + 5,
    irFrente(Nome, Teta, Valor1).

irFrente(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor3',
    setDuty('servo3', Teta), !.


irReverso(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor1',
    Valor > Teta,
    setDuty('servo1', Valor),
    Valor1 is Valor - 5,
    irFrente(Nome, Teta, Valor1).

irReverso(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor1',
    setDuty('servo1', Teta), !.

irReverso(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor2',
    Valor > Teta,
    setDuty('servo2', Valor),
    Valor1 is Valor - 5,
    irFrente(Nome, Teta, Valor1).

irReverso(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor2',
    setDuty('servo2', Teta), !.

irReverso(Nome, Teta, Valor):-
    tempoEspera(A),sleep(A),
    Nome = 'motor3',
    Valor > Teta,
    setDuty('servo3', Valor),
    Valor1 is Valor - 5,
    irFrente(Nome, Teta, Valor1).

irReverso(Nome, Teta, _):-
    tempoEspera(A),sleep(A),
    Nome = 'motor2',
    setDuty('servo2', Teta), !.
