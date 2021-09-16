
%--------------------------FESTIVALES DE ROCK-------------------------%

% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia],hipodromoSanIsidro).
%festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia],lunaPark).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).
%lugar(lunaPark, 88000, 4000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).
% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes:
% - campo
% - plateaNumerada(Fila)
% - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).
entradaVendida(lunaPark, plateaNumerada(2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%---- Punto 1
itinerante(Festival):-
  festival(Festival,Bandas,Lugar),
  festival(Festival,Bandas,OtroLugar),
  Lugar \= OtroLugar.

%---- Punto 2
careta(Festival):-
  festival(Festival,_,_),
  not(entradaVendida(Festival,campo)).

careta(personalFest).

%---- Punto 3
%Solucion con forall
nacAndPop(Festival):-
  festival(Festival,Bandas,_),
  forall(member(Banda,Bandas),(banda(Banda,argentina,Popularidad),Popularidad > 1000)),
  not(careta(Festival)).

% Solucion con recursividad ( No recomendado)
nacAndPop1(Festival):-
  festival(Festival,Bandas,_),
  todasSusBandasSonArgentinas(Bandas),
  not(careta(Festival)).

todasSusBandasSonArgentinas([]).
todasSusBandasSonArgentinas([Banda|Bandas]):-
  banda(Banda,argentina,Popularidad),
  Popularidad > 1000,
  todasSusBandasSonArgentinas(Bandas).

%---- Punto 4

sobrevendido(Festival):-
  festival(Festival,_,Lugar),
  lugar(Lugar,Capacidad,_),
  findall(Entrada,entradaVendida(Festival,Entrada),Entradas),
  length(Entradas,CantidadDeEntradas),
  CantidadDeEntradas > Capacidad.

%---- Punto 5
recaudacionTotal(Festival,TotalRecaudado):-
  festival(Festival,_,Lugar),
  findall(Recaudacion,recaudacion(Festival,Lugar,Recaudacion),Recaudaciones),
  sum_list(Recaudaciones, TotalRecaudado).
  
 
recaudacion(Festival,Lugar,Recaudacion):-
entradaVendida(Festival,Entrada),
 precio(Entrada,Lugar,Recaudacion).  
  
precio(campo,Lugar,Precio):-
  precioBaseDe(Lugar,Precio).

precio(plateaGeneral(Zona),Lugar,Precio):-
  precioBaseDe(Lugar,PrecioBase),
  plusZona(Lugar,Zona,Plus),
  Precio is PrecioBase + Plus.
 
precio(plateaNumerada(Fila),Lugar,Precio):-
  precioBaseDe(Lugar,PrecioBase),
  Fila > 10, 
  Precio is 3 * PrecioBase.


precio(plateaNumerada(Fila),Lugar,Precio):-
  precioBaseDe(Lugar,PrecioBase),
  Fila =< 10, 
  Precio is 6 * PrecioBase.

precioBaseDe(Lugar,Precio):-
  lugar(Lugar,_,Precio).

%---- Punto 6
delMismoPalo(UnaBanda,OtraBanda):- 
  tocoCon(UnaBanda,OtraBanda).
delMismoPalo(UnaBanda,OtraBanda):-
  tocoCon(UnaBanda,TercerBanda),
  banda(TercerBanda,_,PopularidadDeLaTercerBanda),
  banda(OtraBanda,_,PopularidadDeLaOtraBanda),
  PopularidadDeLaTercerBanda > PopularidadDeLaOtraBanda,
  delMismoPalo(TercerBanda,OtraBanda).

tocoCon(Banda, OtraBanda):-  
   festival(_,Bandas,_),
   member(Banda,Bandas),
   member(OtraBanda,Bandas),
   Banda \= OtraBanda.


