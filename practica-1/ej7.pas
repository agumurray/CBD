program ej7;

type
	alumno= record
		dni: longint;
		legajo: integer;
		nombre: string;
		apellido: string;
		direccion: string;
		anio: integer;
		fecha: longint;
	end;

	afile= file of alumno;

	procedure listarCaracter(var myfile: afile);
	var
		datos: alumno;
		c: char;
	begin
		writeln('Ingrese el caracter requerido: ');
		readln(c);
		reset(myfile);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			if (datos.nombre[1] = c) then
			begin
				writeln('Nombre: ', datos.nombre, ' Apellido: ', datos.apellido);
				writeln(' DNI: ', datos.dni, ' Legajo: ', datos.legajo);
				writeln(' Fecha: ', datos.fecha, ' Direccion: ', datos.direccion);
				writeln(' Anio: ', datos.anio);
			end;
		end;
		close(myfile);
	end;

	procedure exportarQuinto(var myfile: afile);
	var
		datos: alumno;
		tfile: text;
	begin
		assign(tfile, 'tmp/alumnosAEgresar.txt');
		rewrite(tfile);
		reset(myfile);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			if (datos.anio = 5) then
			begin
				writeln(tfile, datos.dni);
				writeln(tfile,datos.legajo);
				writeln(tfile, datos.nombre);
				writeln(tfile, datos.apellido);
				writeln(tfile, datos.direccion);
				writeln(tfile, datos.anio);
				writeln(tfile, datos.fecha);
			end;
		end;
		close(tfile);
		close(myfile);
	end;

	procedure agregarAlumno(var myfile: afile);
	var
		datos: alumno;
	begin
		reset(myfile);

		writeln('Nombre: '); readln(datos.nombre);
		while (datos.nombre <> 'zzz') do
		begin
			writeln('Apellido: '); readln(datos.apellido);
			writeln('DNI: '); readln(datos.dni);
			writeln('Legajo: '); readln(datos.legajo);
			writeln('Direccion: '); readln(datos.direccion);
			writeln('Anio: '); readln(datos.anio);
			writeln('Nacimiento: '); readln(datos.fecha);
			seek(myfile, filesize(myfile));
			write(myfile, datos);
			writeln('Nombre: '); readln(datos.nombre);
		end;

		close(myfile);
	end;

	procedure modificarLegajo(var myfile: afile);
	var
		datos: alumno;
		n: integer;
	begin
		reset(myfile);
		writeln('Ingrese el legajo del alumno al que quiere cambiarle el anio de cursada: '); readln(n);
		while not eof(myfile) do
		begin
			read(myfile, datos);
			if (datos.legajo = n) then
			begin
				writeln('Alumno encontrado, ingrese el nuevo anio: '); readln(n);
				datos.anio := n;
				seek(myfile, filepos(myfile)-1);
				write(myfile, datos);
			end;
		end;
		close(myfile);
	end;

var
	myfile: afile;
	tfile: text;
	datos: alumno;
	op: integer;
begin
	assign(myfile, 'tmp/alumnos.bin');
	assign(tfile, 'tmp/alumnos.txt');

	writeln('-----------------------------');
	writeln('Creando binario alumnos.txt');
	writeln('-----------------------------');

	rewrite(myfile);
	reset(tfile);

	while not eof(tfile) do
	begin
		readln(tfile, datos.dni, datos.legajo);
		readln(tfile, datos.nombre);
		readln(tfile, datos.apellido);
		readln(tfile, datos.direccion);
		readln(tfile, datos.anio, datos.fecha);
		write(myfile, datos);
	end;
	close(myfile);
	close(tfile);

	writeln('-----------------------------');
	writeln('Archivo creado correctamente.');
	writeln('-----------------------------');

	writeln('Seleccione una opcion: ');
	writeln('1) Listar en pantalla alumnos cuyo nombre comience con una letra proporcionada.');
	writeln('2) Listar en archivo de texto alumnos de 5 anio.');
	writeln('3) Agregar alumno al final del archivo. ');
	writeln('4) Modificar anio que cursa un alumno. ');

	op := -1;
	repeat
		readln(op);
		case op of
		1: listarCaracter(myfile);
		2: exportarQuinto(myfile);
		3: agregarAlumno(myfile);
		4: modificarLegajo(myfile);
	else if (op<>5) then writeln('Opcion invalida.');
		end;
	until op = 5;
end.
