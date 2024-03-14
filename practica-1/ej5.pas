program ej5;

type
	flor= record
		num: integer;
		altura: real;
		cname: string;
		vname: string;
		color: string;
	end;

	flfile= file of flor;

	procedure agregarEspecie(var myfile:flfile; datos:flor);
	begin

	end;

	procedure totMinMax(var myfile: flfile);
	var tot: integer;
			min, max: real;
			datos:flor;
	begin
		tot := 0;
		min := 9999;
		max := -1;
		reset(myfile);
		while not eof(myfile) do
		begin
			tot:=tot+1;
			read(myfile, datos);
			if (datos.altura>max) then max:=datos.altura;
			if (datos.altura<min) then min:=datos.altura;
		end;
		writeln('La cantidad total de datos es: ', tot);
		writeln('La altura maxima es: ', max:2:2);
		writeln('La altura minima es: ', min:2:2);
		close(myfile);
	end;

	procedure ls(var myfile: flfile);
	var datos: flor;
	begin
		reset(myfile);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			writeln('El numero de la flor es: ', datos.num, ' La altura de la flor es: ', datos.altura:2:2, ' El nombre cientifico de la flor es: ', datos.cname, ' El nombre vulgar de la flor es: ', datos.vname, ' El color de la flor es: ', datos.color);
		end;
		close(myfile);
	end;

	procedure cambiarNombre(var myfile: flfile);
	var datos: flor;
			nombre: string;
	begin
		writeln('Ingrese el nombre de la flor a la que le quiere cambiar el nombre: ');
		readln(nombre);
		reset(myfile);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			if (datos.cname = nombre) then
			begin
				writeln('Flor encontrada, ingrese el nuevo nombre: ');
				readln(nombre);
				seek(myfile, filepos(myfile)-1);
				datos.cname := nombre;
				write(myfile, datos);
			end;
		end;
		close(myfile);
	end;

	procedure agregarFlor(var myfile: flfile);
	var datos: flor;
	begin
		reset(myfile);
		writeln('Ingrese el nombre cientifico: '); readln(datos.cname);
		while (datos.cname <> 'zzz') do
		begin
			writeln('Ingrese el numero de especie: '); readln(datos.num);
			writeln('Ingrese la altura maxima: '); readln(datos.altura);
			writeln('Ingrese el nombre vulgar: '); readln(datos.vname);
			writeln('Ingrese el color: '); readln(datos.color);
			seek(myfile, filesize(myfile));
			write(myfile, datos);
			writeln('Ingrese el nombre cientifico: '); readln(datos.cname);
		end;
		close(myfile);
	end;

	procedure lstxt(var myfile: flfile);
	var datos: flor;
			tfile: text;
	begin
		assign(tfile, 'tmp/flor.txt');
		rewrite(tfile);
		reset(myfile);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			writeln(tfile, datos.num, datos.altura, datos.color);
			writeln(tfile, datos.vname);
			writeln(tfile, datos.cname);
		end;
		close(myfile);
		close(tfile);
	end;

var
	myfile: flfile;
	datos: flor;
	op: integer;
begin
	assign(myfile, 'tmp/flores.bin');
	rewrite(myfile);
	writeln('Ingrese el nombre cientifico: '); readln(datos.cname);
	while (datos.cname <> 'zzz') do
	begin
		writeln('Ingrese el numero de especie: '); readln(datos.num);
		writeln('Ingrese la altura maxima: '); readln(datos.altura);
		writeln('Ingrese el nombre vulgar: '); readln(datos.vname);
		writeln('Ingrese el color: '); readln(datos.color);
		write(myfile, datos);
		writeln('Ingrese el nombre cientifico: '); readln(datos.cname);
	end;
	close(myfile);

	op := -1;
	writeln('1) Cantidad total de especies y la de menor y mayor altura.');
	writeln('2) Listar todo el contenido del archivo.');
	writeln('3) Modificar el nombre cientifico de una especie.');
	writeln('4) Agregar una o mas especies al final del archivo.');
	writeln('5) Crear flores.txt reutilizable.');
	writeln('6) Salir del programa.');

	repeat
		writeln('Ingrese la opcion requerida: ');
		readln(op);
		if (op = 1) then totMinMax(myfile);
		if (op = 2) then ls(myfile);
		if (op = 3) then cambiarNombre(myfile);
		if (op = 4) then agregarFlor(myfile);
		if (op = 5) then lstxt(myfile);
	until op=6;
end.
