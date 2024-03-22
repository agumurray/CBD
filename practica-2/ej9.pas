program ej9;
uses Sysutils;

const valoralto=9999;
const N=3;

type
	registro_detalle = record
		dni,gano:integer;
		nom:string[20];
		km:real;
	end;

	registro_maestro = record
		dni, cantGanadas:integer;
		nom:string[20];
		totalKm:real;
	end;

	file_detalle = file of registro_detalle;
	file_maestro = file of registro_maestro;

	array_registro_detalle = array[1..N] of registro_detalle;
	array_file_detalle = array[1..N] of file_detalle;

procedure crearArchivos();
var
	regd:registro_detalle;
	det:array_file_detalle;
	i, numDetalle: integer;
begin
	for i:=1 to N do
	begin
		assign(det[i], 'tmp/ej9/detalle'+IntToStr(i));
		rewrite(det[i]);
	end;

	for i:=1 to 5 do
	begin
		writeln('Ingrese los datos del corredor: ',i);
		write('Dni: '); readln(regd.dni);
		write('Nombre: '); readln(regd.nom);
		write('Km corridos: '); readln(regd.km);
		write('Gano (1 si 0 no)'); readln(regd.gano);

		writeln('Ingrese el numero de detalle al cual quiere cargar al corredor: ');
		readln(numDetalle);
		write(det[numDetalle], regd);
	end;
	for i:=1 to N do close(det[i]);
end;

procedure leer(var archivo: file_detalle; var dato: registro_detalle);
begin
	if not eof(archivo) then read(archivo, dato)
	else dato.dni:=valoralto;
end;

function minIndexValue(const arr: array_registro_detalle): integer;
var i,min_value, min_index: integer;
begin
	min_value:=arr[1].dni;
	min_index:=1;

	for i:=1 to N do
	begin
		if arr[i].dni < min_value then
		begin
			min_value:=arr[i].dni;
			min_index:=i;
		end;
	end;
	minIndexValue:=min_index;
end;

procedure minimo(var regd: array_registro_detalle; var min: registro_detalle; var det: array_file_detalle);
var min_index: integer;
begin
	min_index:=minIndexValue(regd);
	min:=regd[min_index];
	leer(det[min_index], regd[min_index]);
end;

procedure merge(var master: file_maestro; var dets: array_file_detalle);
var
	regm:registro_maestro;
	regd: array_registro_detalle;
	min:registro_detalle;
	i:integer;
begin
	for i:=1 to N do
	begin
		assign(dets[i], 'tmp/ej9/detalle'+IntToStr(i)); reset(dets[i]);
		leer(dets[i], regd[i]);
	end;
	assign(master, 'tmp/ej9/maestro'); rewrite(master);
	minimo(regd, min, dets);

	while(min.dni<>valoralto) do
	begin
		regm.dni:=min.dni;
		regm.nom:=min.nom;
		regm.cantGanadas:=0;
		regm.totalKm:=0;
		while(min.dni=regm.dni) do
		begin
			regm.totalKm:=regm.totalKm+min.km;
			if (min.gano=1) then regm.cantGanadas:=regm.cantGanadas+1;
			minimo(regd, min, dets);
		end;
		write(master, regm);
	end;
	for i:=1 to N do close(dets[i]);
	close(master);
end;

var
	master:file_maestro;
	dets:array_file_detalle;
	regm:registro_maestro;
begin
	crearArchivos();
	merge(master, dets);
	assign(master, 'tmp/ej9/maestro'); reset(master);
	writeln('DNI NOMBRE KM GANADAS');
	while not eof(master) do
	begin
		read(master, regm);
		writeln(regm.dni,' ', regm.nom,' ', regm.totalKm,' ', regm.cantGanadas);
	end;
	close(master);
end.
