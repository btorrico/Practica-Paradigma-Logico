% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina,opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

%------ Punto 1
% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
  guardia(Guardia),
  prisionero(Otro,_),
  not(controla(Otro, Guardia)).

%Indicar, justificando, si es inversible y, en caso de no serlo, dar ejemplos de las consultas que NO podrían hacerse y corregir la implementación para que se pueda.

% el predicado controla no es inversible para su primer argumento ya que tiene el universo de los prisioneros pero no el de los guardias.
% Ejemplo de consulta que no podria hacerse: controla(Quien,suzanne)

%------ Punto 2

conflictoDeIntereses(Persona, OtraPersona):-
  controlanALaMismaPersona(Persona,OtraPersona),
  noSeControlanMutuamente(Persona,OtraPersona),
Persona \= OtraPersona.


noSeControlanMutuamente(Persona,OtraPersona):-  
 not(controla(Persona,OtraPersona)),
 not(controla(OtraPersona,Persona)).

controlanALaMismaPersona(Persona,OtraPersona):-
 controla(Persona,TerceraPersona),
 controla(OtraPersona,TerceraPersona).

%------ Punto 3

peligroso(Prisionero):-
  prisionero(Prisionero,_),
  forall(prisionero(Prisionero,Crimen),esGrave(Crimen)).

esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):-
  length(Drogas, Cantidad), Cantidad >= 5.
esGrave(narcotrafico(Drogas)):-
  member(metanfetaminas, Drogas).
  
%------ Punto 4
ladronDeGuanteBlanco(Prisionero):-
  prisionero(Prisionero,_),
  forall(prisionero(Prisionero,Crimen),(monto(Crimen,Monto), Monto > 100000)).
  
 monto(robo(Monto),Monto).

%------ Punto 5
%---- Solucion con Polimorfismo
pena(robo(Monto),Pena):-
  Pena is Monto / 10000.
pena(homicidio(Persona),9):- 
  guardia(Persona).
pena(homicidio(Persona),7):-
  not(guardia(Persona)).
pena(narcotrafico(Drogas),Pena):-
length(Drogas,Cantidad),
 Pena is 2 * Cantidad.

condena(Prisionero,AniosACumplir):-
  prisionero(Prisionero,_),
 findall(Pena,(prisionero(Prisionero,Crimen),pena(Crimen,Pena)),ListaDeAnios),
 sum_list(ListaDeAnios, AniosACumplir).


%---- Solucion sin Polimorfismo

condena1(Prisionero,AniosACumplir):-
  prisionero(Prisionero,_),
 findall(Anio,aniosDePrisionPara(Prisionero,Anio),ListaDeAnios),
 sum_list(ListaDeAnios, AniosACumplir).
aniosDePrisionPara(Prisionero,AniosACumplir):-
  prisionero(Prisionero,robo(Cantidad)),
  AniosACumplir is Cantidad  / 10000.

aniosDePrisionPara(Prisionero,7):-
 prisionero(Prisionero,homicidio(_)).

 aniosDePrisionPara(Prisionero,9):-
 prisionero(Prisionero,homicidio(Persona)),
 guardia(Persona).

aniosDePrisionPara(Prisionero,AniosACumplir):-
 prisionero(Prisionero,narcotrafico(Drogas)),
 length(Drogas,Cantidad),
 AniosACumplir is 2 * Cantidad.


%------ Punto 6
capoDiTutiLiCapi(Prisionero):-
not(controla(_,Prisionero)),
forall(persona(Persona),controlaDirectaOIndirectamente(Prisionero,Persona)).

controlaDirectaOIndirectamente(Prisionero,Persona):-
  controla(Prisionero,Persona).

controlaDirectaOIndirectamente(Prisionero,OtraPersona):-
  controla(Prisionero,Persona),
  controlaDirectaOIndirectamente(Persona,OtraPersona).

persona(Persona):-
  guardia(Persona).

persona(Persona):-
  prisionero(Persona,_).
  
