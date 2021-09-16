

%---- Punto 1
cree(gabriel,campanita).
cree(gabriel,magoDeOz).
cree(gabriel,cavenaghi).
cree(juan,conejoDePascua).
cree(macarena,reyesMagos).
cree(macarena,magoCapria).
cree(macarena,campanita).
%Diego no cree en nadie: no se agrega a la base de conocimiento
%por principio de universo cerrado

%cantante(cantidadDeDiscos).
%futbolista(Equipo).
%loteria(Numeros).

suenio(gabriel,loteria([5,9])).
suenio(gabriel,futbolista(arsenal)).
suenio(juan,cantante(100000)).
suenio(macarena,cantante(10000)).

%---- Punto 2
equipo(arsenal,chico).
equipo(aldosivi,chico).
equipo(barcelona,grande).
equipo(psg,grande).

esAmbiciosa(Persona):-
suenio(Persona,_),
 findall(Dificultad,dificultadDe(Persona,_,Dificultad),Dificultades),
 sum_list(Dificultades, CantidadTotal),
 CantidadTotal > 20.

dificultadDe(Persona,Suenio,Dificultad):-
  suenio(Persona,Suenio),
  dificultadSuenio(Suenio,Dificultad).

dificultadSuenio(cantante(CantidadDeDiscos), 6):-
  CantidadDeDiscos > 500000.
dificultadSuenio(cantante(CantidadDeDiscos), 4):-
  CantidadDeDiscos =< 500000.

dificultadSuenio(loteria(Numeros),Dificultad):-
  length(Numeros,Cantidad),
  Dificultad is 10 * Cantidad.

dificultadSuenio(futbolista(Equipo),3):-
  equipo(Equipo,chico).

dificultadSuenio(futbolista(Equipo),16):-
  equipo(Equipo,grande).

%---- Punto 3

%tieneQuimica(Personaje,Persona)

tieneQuimica(Personaje,Persona):-
  cree(Persona,Personaje),
  quimica(Personaje,Persona).

quimica(campanita,Persona):-
  suenio(Persona,_),
  dificultadDe(Persona,_,Dificultad),
  Dificultad < 5.
  
quimica(_,Persona):-
  suenio(Persona,_),
  forall(suenio(Persona,Suenio),esSuenioPuro(Suenio)),
  not(esAmbiciosa(Persona)).

esSuenioPuro(futbolista(_)).
esSuenioPuro(cantante(CantidadDeDiscos)):-
  CantidadDeDiscos < 200000.

%---- Punto 4

amigo(campanita,reyesMagos).
amigo(campanita,conejoDePascua).
amigo(conejoDePascua,cavenaghi).

personajeDeBackUp(Personaje1,Personaje2):-
  amigo(Personaje1,Personaje2).

personajeDeBackUp(Personaje1,Personaje3):-
  amigo(Personaje1,Personaje2),
  personajeDeBackUp(Personaje2,Personaje3).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

persona(Persona):- suenio(Persona,_).

personaje(Personaje):- cree(_,Personaje).

puedeAlegrar(Personaje,Persona):-
  suenio(Persona,_),
  tieneQuimica(Personaje,Persona),
  esApto(Personaje).

esApto(Personaje):-
  not(estaEnfermo(Personaje)).

esApto(Personaje):-
personajeDeBackUp(Personaje,PersonajeDeBackUp),
  not(estaEnfermo(PersonajeDeBackUp)).











