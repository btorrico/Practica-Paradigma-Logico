
%------------------------------DENTISTAS-----------------------------%

dentista(pereyra).
dentista(deLeon).
dentista(cureta).
dentista(patolinger).
dentista(saieg).

% costo de servicios para cada obra social
costo(osde, tratamientoConducto, 200).
costo(omint, tratamientoConducto, 250).

% costo de servicios por atención particular
costo(tratamientoConducto, 1200).

% porcentaje que se cobra a clínicas asociadas
clinica(odontoklin, 80).

puedeAtenderA(pereyra,pacienteObraSocial(karlsson, 1231, osde)).
puedeAtenderA(pereyra,pacienteParticular(rocchio, 24)).
puedeAtenderA(deLeon, pacienteClinica(dodino,odontoklin)).
%----Punto 1
puedeAtenderA(cureta,pacienteParticular(_,Edad)):- Edad > 60.
puedeAtenderA(cureta,pacienteClinica(_,sarlanga)).
puedeAtenderA(patolinger,Paciente):-   
  puedeAtenderA(pereyra,Paciente).
puedeAtenderA(patolinger,Paciente):-   
  not(puedeAtenderA(deLeon,Paciente)).
puedeAtenderA(saieg,_).

%----Punto 2

%precio(pacienteObraSocial(karlsson, 1231, osde), Servicio, Precio).

precio(pacienteObraSocial(_,_, ObraSocial),Servicio,Precio):-
  costo(ObraSocial,Servicio,Precio).
precio(pacienteParticular(_,Edad),Servicio,PrecioTotal):-
  costo(Servicio,Precio),
  Edad >45,PrecioTotal is Precio + 50. 
precio(pacienteParticular(_,Edad),Servicio,Precio):-
  costo(Servicio,Precio),
  Edad =< 45. 
precio(pacienteClinica(_,Clinica),Servicio,PrecioTotal):-  
  clinica(Clinica,Precio),
  costo(Servicio,PrecioParticular),
PrecioTotal is (Precio * PrecioParticular) / 100.

%----Punto 3

%servicioRealizado(fecha, dentista, servicio(servicio, functor paciente))

servicioRealizado(fecha(10, 11, 2010), pereyra, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))).
servicioRealizado(fecha(16, 11, 2010), pereyra,servicio(tratamientoConducto,pacienteClinica(dodino, odontoklin))).
servicioRealizado(fecha(21, 12, 2010), deLeon, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))).



montoFacturacion(Medico,Mes,PrecioTotal):-
dentista(Medico),
findall(Precio,cobro(Medico,Precio,Mes),Precios),
sum_list(Precios, PrecioTotal).

cobro(Dentista,Precio,Mes):-
  servicioRealizado(Fecha,Dentista,servicio(_,Paciente)),
  precio(Paciente,_,Precio),
  mesDeUnServicio(Fecha,Mes).

mesDeUnServicio(fecha(_,Mes,_),Mes).

%----Punto 4

dentistaCool(Dentista):-
  dentista(Dentista),
  forall(servicioRealizado(_,Dentista,servicio(_,Paciente)),
  esPacienteInteresante(Paciente)).

esPacienteInteresante(pacienteObraSocial(Paciente,Legajo,ObraSocial)):- 
  precio(pacienteObraSocial(Paciente,Legajo,ObraSocial),tratamientoConducto,Precio),
  Precio > 1000.
esPacienteInteresante(pacienteParticular(_,_)).

%----Punto 5
confia(pereyra, deLeon).
confia(cureta, pereyra).

%atiendeDeUrgenciaA
paciente(pacienteObraSocial(karlsson, 1231, osde)).
paciente(pacienteParticular(rocchio, 24)).
paciente(pacienteClinica(dodino, odontoklin)).

atiendeDeUrgenciaA(Paciente,Dentista):-
  dentista(Dentista),
  paciente(Paciente),
  puedeAtenderA(Dentista,Paciente).

atiendeDeUrgenciaA(Paciente,Dentista):-
  confia(Dentista,OtroDentista),
  atiendeDeUrgenciaA(Paciente,OtroDentista).

%----Punto 6
pacienteAlQueLeVieronLaCara(Paciente):-
  paciente(Paciente),
 forall(servicioRealizado(_, _, servicio(Servicio,Paciente)),esCaro(Servicio,Paciente)).

serviciosCaros(osde, [tratamientoConducto, implanteOseo]).

esCaro(Servicio,pacienteObraSocial(_,_,ObraSocial)):-
  serviciosCaros(ObraSocial,Servicios),
  servicioRealizado(_,_, servicio(Servicio,_)),
  member(Servicio, Servicios).
  

esCaro(Servicio,pacienteParticular(_,_)):-
precio(pacienteParticular(_,_),Servicio,Precio),
Precio >500.

%----Punto 7
serviciosMalHechos(Dentista,Servicios):-
  dentista(Dentista),
  findall(Servicio,servicioMalo(Servicio,Dentista,_),Servicios).


servicioMalo(Servicio,Dentista,Mes):-
  servicioRealizado(Fecha1,Dentista, servicio(Servicio, Paciente)),
  mesDeUnServicio(Fecha1,Mes),
  servicioRealizado(Fecha2,_, servicio(Servicio, Paciente)),
  mesDeUnServicio(Fecha2,MesSiguiente),
  MesSiguiente is Mes + 1.

