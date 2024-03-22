program ej7;
uses Sysutils;

const valoralto = 9999;
const N = 3;

type
	registro_maestro = record
		cod,stock,stock_minimo:integer;
		nom,desc:string[20];
		precio:real;
	end;

	registro_detalle = record
		cod,ventas:integer;
	end;

	file_maestro = file of registro_maestro;
	file_detalle = file of registro_detalle;

	array_registro_detalle = array[1..N] of registro_detalle;
	array_file_detalle = array[1..N] of file_detalle;

procedure crearArchivos();
var
	maestro: file_maestro;
	productos:text;
	det: array_file_detalle;
	regm: registro_maestro;
	regd: registro_detalle;
	i, numDetalle:integer;
	auxCod:string[1];
	auxStock:string[3];
begin
	for i:=1 to N do
	begin
		assign(det[i], 'tmp/ej7/detalle'+IntToStr(i));
		rewrite(det[i]);
	end;

	assign(maestro, 'tmp/ej7/maestro'); rewrite(maestro);
	assign(productos, 'tmp/ej7/productos.txt'); reset(productos);

	for i:=1 to 5 do begin
		readln(productos,auxCod);
		regm.cod:=StrToInt(auxCod);
		readln(productos, regm.nom);
		readln(productos, regm.desc);
		readln(productos,auxStock);
		regm.stock:=StrToInt(auxStock);
		readln(productos, auxStock);
		regm.stock_minimo:=StrToInt(auxStock);
		readln(productos, auxStock);
		regm.precio:=StrToInt(auxStock);

		write(maestro, regm);
		writeln('Ingrese el numero de detalle al cual quiere agregar el producto: ');
		readln(numDetalle);

		regd.cod:=regm.cod;
		write('Ventas: '); readln(regd.ventas);
		write(det[numDetalle], regd);
	end;
	close(maestro);
	for i:=1 to N do close(det[i]);
end;

procedure leer(var det:file_detalle; var datos:registro_detalle);
begin
	if not eof(det) then read(det, datos)
	else datos.cod:=valoralto;
end;


function minIndexValue(const arr:array_registro_detalle): integer;
var i,min_value,min_index:integer;
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

procedure minimo(var regd: array_registro_detalle; var min:registro_detalle; var det: array_file_detalle);
var min_index: integer;
begin
	min_index:=minIndexValue(regd);
	min:=regd[min_index];
	leer(det[min_index], regd[min_index]);
end;

procedure actualizar(var master: file_maestro; var dets:array_file_detalle);
var
	regm:registro_maestro;
	regd: array_registro_detalle;
	min:registro_detalle;
	aux,i:integer;
begin
	for i:=1 to N do
	begin
		assign(dets[i], 'tmp/ej7/detalle'+IntToStr(i)); reset(dets[i]);
		leer(dets[i], regd[i]);
	end;
	assign(master, 'tmp/ej7/maestro'); reset(master);

	read(master, regm);
	minimo(regd, min, dets);

	while(min.cod<>valoralto) do
	begin
		while(regm.cod<>min.cod) do read(master,regm);
		aux:=min.cod;

		while(aux=min.cod) do
		begin
			regm.stock:=regm.stock-min.ventas;
			minimo(regd,min,dets);
		end;
		seek(master,filepos(master)-1);
		write(master, regm);
	end;
	for i:=1 to N do close(dets[i]);
	close(master);
end;

var
	master:file_maestro;
	dets:array_file_detalle;
	regm: registro_maestro;
	op:integer;
begin
	writeln('Seleccione una opcion: ');
	writeln('1) Crear el archivo maestro a partir de productos.txt');
	writeln('2) Actualizar el archivo maestro con los archivos detalle');
	writeln('3) Salir');
	readln(op);
	while (op<>3)do begin
	case op of
		1: crearArchivos();
		2: actualizar(master, dets);
	end;
		readln(op);
	end;
	assign(master,'tmp/ej7/maestro'); reset(master);
	writeln('Codigo Nombre Stock');
	while(not eof(master)) do
	begin
		read(master, regm);
		writeln(regm.cod, ' ', regm.nom, ' ', regm.stock);
	end;
	close(master);
end.
