program ej10;
uses Sysutils;

const
	N = 3;
	valoralto = 9999;

type
	registro_detalle=record
		cod, ventas:integer;
	end;

	registro_maestro=record
		cod, ventas, maxVentas:integer;
		nom,desc:string[20];
		precio:real;
	end;

	file_detalle = file of registro_detalle;
	file_maestro = file of registro_maestro;

	array_registro_detalle = array[1..N] of registro_detalle;
	array_file_detalle = array[1..N] of file_detalle;

procedure crearArchivos();
var
	maestro: file_maestro;
	det: array_file_detalle;
	regm: registro_maestro;
	regd: registro_detalle;
	i, numDetalle: integer;
begin
	for i:=1 to N do
	begin
		assign(det[i], 'tmp/ej10/detalle'+IntToStr(i));
		rewrite(det[i]);
	end;

	assign(maestro, 'tmp/ej10/maestro');
	rewrite(maestro);

	for i:=1 to 5 do
	begin
		writeln('Ingrese los datos del producto ', i);
		write('Codigo: '); readln(regm.cod);
		write('Nombre: '); readln(regm.nom);
		write('Descripcion: '); readln(regm.desc);
		write('Cantidad de ventas: '); readln(regm.ventas);
		write('Mayor cantidad vendida en un mes: '); readln(regm.maxVentas);
		write('Precio: '); readln(regm.precio);

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

procedure leer(var det: file_detalle; var datos: registro_detalle);
begin
	if not eof(det) then read(det, datos)
	else datos.cod := valoralto;
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


procedure minimo(var regd: array_registro_detalle; var min:registro_detalle; var det: array_file_detalle);
var min_index: integer;
begin
	min_index:=minIndexValue(regd);
	min:=regd[min_index];
	leer(det[min_index], regd[min_index]);
end;

procedure actualizar(var master: file_maestro; var dets: array_file_detalle);
var
	regm: registro_maestro;
	regd: array_registro_detalle;
	min:registro_detalle;
	aux,totalMes,i:integer;
begin
	for i:=1 to N do
	begin
		assign(dets[i], 'tmp/ej10/detalle'+IntToStr(i)); reset(dets[i]);
		leer(dets[i], regd[i]);
	end;
	assign(master, 'tmp/ej10/maestro'); reset(master);

	read(master, regm);
	minimo(regd, min, dets);

	while(min.cod<>valoralto) do
	begin
		while(regm.cod<>min.cod) do read(master, regm);
		aux:=min.cod;
		totalMes:=0;

		while(aux=min.cod) do
		begin
			totalMes:=totalMes+min.ventas;
			regm.ventas:=regm.ventas+min.ventas;
			minimo(regd, min, dets);
		end;
		if (totalMes>regm.maxVentas) then
		begin
			writeln('El producto con codigo ',regm.cod,' supero el maximo de ventas previo.');
			writeln('Maximo previo: ', regm.maxVentas);
			writeln('Nuevo maximo: ', totalMes);
			regm.maxVentas:=totalMes;
		end;
		seek(master, filepos(master)-1);
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
	actualizar(master, dets);
	assign(master, 'tmp/ej10/maestro'); reset(master);
	writeln('Codigo Nombre Ventas MaxVentas');
	while not eof(master) do
	begin
		read(master, regm);
		writeln(regm.cod,' ', regm.nom,' ', regm.ventas,' ', regm.maxVentas);
	end;
	close(master);
end.
