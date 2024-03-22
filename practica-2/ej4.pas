program ej4;
uses Sysutils;

const valoralto=9999;
const N = 3; {para testear}

type
	registro_detalle = record
		cod,duracion,cant:integer;
		nombre,genero,director:string[20];
		fecha:string[6];
	end;

	file_detalle = file of registro_detalle;

	array_registro_detalle = array[1..N] of registro_detalle;
	array_file_detalle = array[1..N] of file_detalle;

procedure crearArchivos();
var
	regd:registro_detalle;
	det:array_file_detalle;
	i, numDetalle:integer;
begin
	for i:=1 to N do
	begin
		assign(det[i], 'tmp/ej4/detalle'+IntToStr(i));
		rewrite(det[i]);
	end;

	for i:=1 to 5 do
	begin
		writeln('Ingrese los datos de la funcion ',i);
		write('Codigo: '); readln(regd.cod);
		write('Nombre: '); readln(regd.nombre);
		write('Genero: '); readln(regd.genero);
		write('Director: '); readln(regd.director);
		write('Duracion: '); readln(regd.duracion);
		write('Fecha: '); readln(regd.fecha);
		write('Cantidad de asistentes: '); readln(regd.cant);

		writeln('Ingrese el numero de detalle al cual quiere cargar la funcion: ');
		readln(numDetalle);
		write(det[numDetalle], regd);
	end;
	for i:=1 to N do close(det[i]);
end;

procedure leer(var archivo: file_detalle; var dato: registro_detalle);
begin
	if not eof(archivo) then read(archivo, dato)
	else dato.cod:=valoralto;
end;

function minIndexValue(const arr: array_registro_detalle): integer;
var i,min_value, min_index: integer;
begin
	min_value:=arr[1].cod;
	min_index:=1;

	for i:=1 to N do
	begin
		if arr[i].cod < min_value then
		begin
			min_value:=arr[i].cod;
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


procedure merge(var master:file_detalle; var dets: array_file_detalle);
var
	regm:registro_detalle;
	regd: array_registro_detalle;
	min: registro_detalle;
	i: integer;
begin
	for i:=1 to N do
	begin
		assign(dets[i], 'tmp/ej4/detalle'+IntToStr(i)); reset(dets[i]);
		leer(dets[i], regd[i]);
	end;
	assign(master, 'tmp/ej4/maestro'); rewrite(master);
	minimo(regd, min, dets);

	while(min.cod<>valoralto) do
	begin
		regm:=min;
		regm.cant:=0;
		while(min.cod=regm.cod)do
		begin
			regm.cant:=regm.cant+min.cant;
			minimo(regd, min, dets);
		end;
		write(master, regm);
	end;
	for i:=1 to N do close(dets[i]);
	close(master);
end;

var
	master:file_detalle;
	dets:array_file_detalle;
	regm: registro_detalle;
begin
	crearArchivos();
	merge(master, dets);
	assign(master, 'tmp/ej4/maestro'); reset(master);
	writeln('Codigo Nombre Genero Director Duracion Cantidad');
	while not eof(master)do
	begin
	read(master, regm);
	writeln(regm.cod,' ', regm.nombre,' ', regm.genero, ' ',regm.director,' ', regm.duracion,' ', regm.cant);
	end;
	close(master);
end.


