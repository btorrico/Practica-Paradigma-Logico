
%--------------------------EL ASADITO---------------------------%
% define quiénes son amigos de nuestro cliente
amigo(mati).
amigo(pablo).
amigo(leo).
amigo(fer). 
amigo(flor).
amigo(ezequiel).
amigo(marina).

% define quiénes no se pueden ver
noSeBanca(leo, flor). 
noSeBanca(fer, leo).
noSeBanca(pablo, fer).
noSeBanca(flor, fer).

% define cuáles son las comidas y cómo se componen
% functor achura contiene nombre, cantidad de calorías
% functor ensalada contiene nombre, lista de ingredientes
% functor morfi contiene nombre (el morfi es una comida principal)
comida(achura(chori, 200)). % ya sabemos que el chori no es achura
comida(achura(chinchu, 150)).
comida(ensalada(waldorf, [manzana, apio, nuez, mayo])).
comida(ensalada(mixta, [lechuga, tomate, cebolla])).
comida(morfi(vacio)).
comida(morfi(mondiola)).
comida(morfi(asado)).


% relacionamos la comida que se sirvió en cada asado
% cada asado se realizó en una única fecha posible: functor fecha + comida
asado(fecha(22,9,2011), chori). 
asado(fecha(22,9,2011), waldorf). 
asado(fecha(22,9,2011), vacio). 
asado(fecha(15,9,2011), mixta).
asado(fecha(15,9,2011), mondiola).
asado(fecha(15,9,2011), chinchu).

% relacionamos quiénes asistieron a ese asado
asistio(fecha(15,9,2011), flor).
asistio(fecha(15,9,2011), pablo). 
asistio(fecha(15,9,2011), leo). 
asistio(fecha(15,9,2011), fer). 
asistio(fecha(22,9,2011), marina).
asistio(fecha(22,9,2011), pablo).
asistio(fecha(22,9,2011), flor).
asistio(fecha(22,9,2011), mati).

% definimos qué le gusta a cada persona
leGusta(mati, chori).
leGusta(mati, vacio). 
leGusta(mati, waldorf). 
leGusta(fer, mondiola). 
leGusta(fer, vacio).
leGusta(pablo, asado).
leGusta(flor, mixta).

%----- Punto 1 
%----a
leGusta(ezequiel,Comida):-
  leGusta(mati,Comida).
leGusta(ezequiel,Comida):-
  leGusta(fer,Comida).
%----b
leGusta(marina,Comida):-
  leGusta(flor,Comida).
leGusta(marina,mondiola).

%----c
%A Leo no le gusta la ensalada waldorf. - No hace falta incluirlo en 
%la base de conocimientos.

%----- Punto 2
asadoViolento(FechaAsado):-
  asistio(FechaAsado,_),
  forall(asistio(FechaAsado,Persona),tuvoQueSoportar(Persona,_,FechaAsado)).

tuvoQueSoportar(Persona1,Persona2,Fecha):-
  asistio(Fecha,Persona1),
  asistio(Fecha,Persona2),
  noSeBanca(Persona1,Persona2),
  Persona1 \= Persona2.  

%----- Punto 3
%calorias(Comida,Calorias).
%----a
calorias(Comida,Calorias):-
  comida(ensalada(Comida,Ingredientes)),
  length(Ingredientes,Calorias).
calorias(Comida,Calorias):-
  comida(achura(Comida,Calorias)).
calorias(Comida, 200):-
  comida(morfi(Comida)).

%----- Punto 4
 asadoFlojito(FechaAsado):-
  asado(FechaAsado,_),
 findall(Calorias,caloriasEnLaFecha(FechaAsado,Calorias),ListaDeCalorias),
 sum_list(ListaDeCalorias, CaloriasTotales),
 CaloriasTotales < 400.
 

caloriasEnLaFecha(Fecha,Calorias):-
  asado(Fecha,Comida),
  calorias(Comida,Calorias). 

%----- Punto 5
%hablo(Fecha,PersonaDeLaQueSeHabla,ConocedorChisme)

hablo(fecha(15,09,2011), flor, pablo). 
hablo(fecha(22,09,2011), flor, marina).
hablo(fecha(15,09,2011), pablo, leo).
hablo(fecha(22,09,2011), marina, pablo).
hablo(fecha(15,09,2011), leo, fer). 
reservado(marina).

chismeDe(Fecha,ConocedorChisme,PersonaDeLaQueSeHabla):-
  hablo(Fecha,_,_),
 conoceChisme(ConocedorChisme,PersonaDeLaQueSeHabla),
 not(reservado(PersonaDeLaQueSeHabla)).

conoceChisme(ConocedorChisme,PersonaDeLaQueSeHabla):-
  hablo(_,PersonaDeLaQueSeHabla,ConocedorChisme).

conoceChisme(Persona3,Persona1):-
hablo(_,Persona1,Persona2),
conoceChisme(Persona3,Persona2).



%----- Punto 6

disfruto(Persona,FechaAsado):-
  asistio(FechaAsado,Persona),
  findall(Comida,leGustaAlgoDeLaFecha(FechaAsado,Persona,Comida),Comidas),
  length(Comidas,CantidadDeComidas), CantidadDeComidas >=3.

%Donni No! Genere la lista al pedo
leGustaAlgoDeLaFecha(FechaAsado,Persona,Cosa):-
  findall(Comida,asado(FechaAsado,Comida),ListaDeComidas),
  leGusta(Persona,Cosa),
  member(Cosa, ListaDeComidas).

%Alternativa Mejor 

disfruto1(Persona, FechaAsado):- 
	amigo(Persona),
	asistio(FechaAsado, Persona),
	findall(Comida, (asado(FechaAsado, Comida), leGusta(Persona, Comida)), ComidasQueLeGustanALaPersona),
	length(ComidasQueLeGustanALaPersona, CantComidas),
	CantComidas >= 3.

    
%----- Punto 7

asadoRico(CombinacionComidas):-
  findall(Comida,(distinct(Comida,esComidaRica(Comida))),ComidasRicas),
  combinacionDeComidasRicas(ComidasRicas,CombinacionComidas).

combinacionDeComidasRicas([Comida],[Comida]).

combinacionDeComidasRicas([Comida| Comidas],[Comida| OtrasComidas]):-
  combinacionDeComidasRicas(Comidas,OtrasComidas).

combinacionDeComidasRicas([_|Comidas],OtrasComidas):-
  combinacionDeComidasRicas(Comidas,OtrasComidas).

esComidaRica(Comida):-
  comida(Comida),
  comidaRica(Comida).

comidaRica(morfi(_)).
comidaRica(ensalada(_,Ingredientes)):- 
  length(Ingredientes,Cantidad), Cantidad > 3.
comidaRica(achura(chori,_)).
comidaRica(achura(morci,_)).






