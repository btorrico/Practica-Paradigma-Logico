% jugadores conocidos
jugador(maradona).
jugador(chamot).
jugador(balbo).
jugador(caniggia).
jugador(passarella).
jugador(pedemonti).
jugador(basualdo).

% relaciona lo que toma cada jugador
tomo(maradona, sustancia(efedrina)).
tomo(maradona, compuesto(cafeVeloz)).
tomo(caniggia, producto(cocacola, 2)).
tomo(chamot, compuesto(cafeVeloz)).
tomo(balbo, producto(gatoreit, 2)).
%----- Punto 1
tomo(pedemonti,Bebida):-
  tomo(chamot,Bebida).
tomo(pedemonti,Bebida):-
  tomo(maradona,Bebida).
tomo(passarella,Bebida):-
  %tomo(_,Bebida),
 not(tomo(maradona,Bebida)).

% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir
maximo(cocacola, 3).
maximo(gatoreit, 1).
maximo(naranju, 5).

% relaciona las sustancias que tiene un compuesto
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]).

% sustancias prohibidas por la asociación
sustanciaProhibida(efedrina).
sustanciaProhibida(cocaina).


%----- Punto 2

puedeSerSuspendido(Jugador):- 
  distinct(Jugador,tomo(Jugador,Bebida)),
  seraSuspendido(Bebida).

seraSuspendido(sustancia(Sustancia)):- 
  sustanciaProhibida(Sustancia).

seraSuspendido(compuesto(Compuesto)):-
  composicion(Compuesto,SustanciasProhibidas),
  sustanciaProhibida(Sustancia),
  member(Sustancia, SustanciasProhibidas).

seraSuspendido(producto(Producto,Cantidad)):-
  maximo(Producto,CantidadMaxima), 
  Cantidad > CantidadMaxima.
  
%----- Punto 3
amigo(maradona, caniggia).
amigo(caniggia, balbo).
amigo(balbo, chamot).
amigo(balbo, pedemonti).


malaInfluencia(Jugador1, Jugador2):- 
  puedeSerSuspendido(Jugador1),
  puedeSerSuspendido(Jugador2),
  seConocen(Jugador1,Jugador2),
  Jugador1 \= Jugador2.

seConocen(Jugador1, Jugador2):-
amigo(Jugador1, Jugador2).

seConocen(Jugador1, Jugador3):-
 amigo(Jugador1, Jugador2),
  seConocen(Jugador2, Jugador3).


%----- Punto 4

atiende(cahe, maradona).
atiende(cahe, chamot).
atiende(cahe, balbo).
atiende(zin, caniggia).
atiende(cureta, pedemonti).
atiende(cureta, basualdo).

chanta(Medico):-
  medico(Medico),
  forall(atiende(Medico,Jugador),puedeSerSuspendido(Jugador)).

medico(Medico):-
  distinct(Medico,atiende(Medico,_)).
  
%----- Punto 5

nivelFalopez(efedrina, 10).
nivelFalopez(cocaina, 100).
nivelFalopez(extasis, 120).
nivelFalopez(omeprazol, 5).

cuantaFalopaTiene(Jugador,NivelDeAlteracion):-
  jugador(Jugador),
  findall(Nivel,alteracion(Jugador,Nivel),Niveles),sum_list(Niveles, NivelDeAlteracion).

alteracion(Jugador,Nivel):-
  tomo(Jugador,Cosa),
  nivelDeAlteracionDe(Cosa,Nivel).

nivelDeAlteracionDe(sustancia(Cual),Valor):-
  nivelFalopez(Cual,Valor).

nivelDeAlteracionDe(producto(_,_),0).

/* Muestra un resultado a la vez de cada compuesto, no la sumatoria
nivelDeAlteracionDe(compuesto(Cual),Valor):-
  composicion(Cual,ListaSustancias),
  member(Sustancia,ListaSustancias),
  nivelFalopez(Sustancia,Valor).
*/

% Solucion que muestra la soma total de la lista de compuestos
nivelDeAlteracionDe(compuesto(Cual),Valor):-
  composicion(Cual,ListaSustancias),
  findall(Nivel,(member(Sustancia,ListaSustancias),nivelFalopez(Sustancia,Nivel)),Niveles),
  sum_list(Niveles,Valor).
  

%----- Punto 6

medicoConProblemas(Medico):-
  atiende(Medico,_),
 findall(JugadorConflictivo,
   (distinct(JugadorConflictivo,atiende(Medico,JugadorConflictivo)),
 esJugadorConflictivo(JugadorConflictivo)),Jugadores),
  length(Jugadores, Cantidad), Cantidad > 3. 
  

esJugadorConflictivo(Jugador):-
  puedeSerSuspendido(Jugador).

esJugadorConflictivo(Jugador):-
  jugador(Jugador),
  seConocen(maradona,Jugador).

%----- Punto 7
programaTVFantinesco(JugadoresCombinados):-
  findall(Jugador,puedeSerSuspendido(Jugador),Jugadores),
  combinacionDeJugadores(Jugadores,JugadoresCombinados).

combinacionDeJugadores([],[]).
combinacionDeJugadores([Jugador| Jugadores],[Jugador| OtrosJugadores]):-
   combinacionDeJugadores(Jugadores,OtrosJugadores).

 combinacionDeJugadores([_|Jugadores],OtrosJugadores):-
  combinacionDeJugadores(Jugadores,OtrosJugadores). 