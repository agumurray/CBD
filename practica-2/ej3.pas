program ej3;
uses Sysutils;

const valoralto = 9999;
const N = 3; {reduzco para testear}

type
	registro_detalle = record
		cod,num,cant:integer;
	end;

	registro_maestro = record
		cod, num, stock, stock_minimo: integer;
		desc,color: string;
		precio:real;
	end;

	file_detalle = file of registro_detalle;
	file_maestro =  file of registro_maestro;

	array_registro_detalle = array[1..N] of registro_detalle;
	array_file_detalle = array[1..N] of file_detalle;

procedure crearArchivos();
var
	maestro:file_maestro;
	det: array_file_detalle;
	regm: registro_maestro;
	regd: registro_detalle;
	i, numDetalle: integer;
begin
	for i:=1 to N do
	begin
		assign(det[i], 'tmp/ej3/detalle'+IntToStr(i));
		rewrite(det[i]);
	end;

	assign(maestro, 'tmp/ej3/maestro');
	rewrite(maestro);

	for i:=1 to 5 do
	begin
		writeln('Ingrese los datos del calzado ', i);
		write('Codigo: '); readln(regm.cod);
		write('Numero: '); readln(regm.num);
		write('Stock: '); readln(regm.stock);
		write('Stock minimo: '); readln(regm.stock_minimo);
		write('Descripcion: '); readln(regm.desc);
		write('Color: '); readln(regm.color);
		write('Precio: '); readln(regm.precio);

		write(maestro, regm);
		writeln('Ingrese el numero de detalle al cual quiere cargar el calzado: ');
		readln(numDetalle);

		regd.cod:=regm.cod;
		regd.num:=regm.num;
		writeln('Ingrese la cantidad vendida: '); readln(regd.cant);
		write(det[numDetalle], regd);
	end;
	close(maestro);
	for i:=1 to N do close(det[i]);
end;

procedure leer(var archivo: file_detalle; var dato: registro_detalle);
begin
	if not eof(archivo) then read(archivo, dato)
	else begin dato.cod:=valoralto; dato.num:=valoralto; end;
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

procedure minimo(var regd: array_registro_detalle; var min:registro_detalle; var det:array_file_detalle);
var min_index: integer;
begin
	min_index:=minIndexValue(regd);
	min:=regd[min_index];
	leer(det[min_index], regd[min_index]);
end;

procedure actualizar(var master: file_maestro; var dets: array_file_detalle);
var
	regm:registro_maestro;
	regd: array_registro_detalle;
	min: registro_detalle;
	auxCod, auxNum, i: integer;
	informe: text;
	informeStr:string;
begin
	for i:=1 to N do
	begin
		assign(dets[i], 'tmp/ej3/detalle'+IntToStr(i)); reset(dets[i]);
		leer(dets[i], regd[i]);
	end;
	assign(master, 'tmp/ej3/maestro'); reset(master);
	assign(informe, 'tmp/ej3/calzadosinstock'); rewrite(informe);

	read(master, regm);
	minimo(regd, min, dets);

	while(min.cod<>valoralto) and (min.num<>valoralto) do
	begin
		while(regm.cod<>min.cod) and (regm.num<>min.num) do read(master, regm);
		auxCod:=min.cod; auxNum:=min.num;

		while (auxCod=min.cod) and (auxNum=min.num) do
		begin
			if (min.cant=0) then writeln('El calzado con codigo: ', min.cod, ' y numero ', min.num, ' no registro ventas.');
			if (regm.stock - min.cant < regm.stock_minimo) then
			begin
				informeStr := 'El calzado con código: ' + IntToStr(min.cod) + ' y número ' + IntToStr(min.num) + ' se encuentra por debajo del stock mínimo. Reponer';
				writeln(informe, informeStr);
			end;
			regm.stock:=regm.stock-min.cant;
			minimo(regd, min, dets);
		end;
		seek(master, filepos(master)-1);
		write(master, regm);
	end;
	for i:=1 to N do close(dets[i]);
	close(master);
	close(informe);
end;

var
	master:file_maestro;
	dets:array_file_detalle;
	regm: registro_maestro;
begin
	crearArchivos();
	actualizar(master, dets);
	assign(master, 'tmp/ej3/maestro'); reset(master);
	writeln('Codigo Numero Stock StockMinimo Descripcion Color Precio');
	while not eof(master) do
	begin
		read(master, regm);
		writeln(regm.cod,' ', regm.num,' ', regm.stock, ' ', regm.stock_minimo, ' ', regm.desc,' ', regm.color,' ', regm.precio);
	end;
	close(master);
end.
