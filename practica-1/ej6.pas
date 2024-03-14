program ej6;

type
	libro= record
		isbn: string[13];
		titulo:string[50];
		genero:string[30];
		editorial:string[30];
		anio:integer;
end;

lfile= file of libro;

procedure binarioTexto(var tfile: text; var myfile: lfile);
var
	line: string;
	datos: libro;
begin
	reset(tfile);
	rewrite(myfile);

	while not eof(tfile) do
	begin
		readln(tfile, line);
		datos.isbn := copy(line, 1, 13);
		datos.titulo := copy(line, 15, 50);

		readln(tfile, line);
		val(copy(line,1,4), datos.anio);
		datos.editorial := copy(line, 6, 30);

		readln(tfile, datos.genero);

		write(myfile, datos);
	end;

	close(tfile);
	close(myfile);
end;

procedure modificarBinario(var myfile: lfile);
var
	datos: libro;
	isbn: string[13];
	found: boolean;
begin
	found := false;
	writeln('Ingrese el ISBN del libro a buscar.');
	readln(isbn);

	reset(myfile);
	while not eof(myfile) do
	begin
		read(myfile, datos);
		if (datos.isbn = isbn) then
		begin
			found := true;
			writeln('El libro fue encontrado. Ingrese los nuevos datos: ');
			writeln('Titulo: '); readln(datos.titulo);
			writeln('Anio edicion: '); readln(datos.anio);
			writeln('Editorial: '); readln(datos.editorial);
			writeln('Genero: '); readln(datos.genero);

			seek(myfile, filepos(myfile)-1);
			write(myfile, datos);
			writeln('El libro se ha actualizado correctamente. ');
			break;
		end;
	end;

	close(myfile);
	if not found then writeln('El libro no fue encontrado con el isbn ingresado.');
end;

procedure agregarBinario(var myfile: lfile);
var datos: libro;
begin
	writeln('Ingrese los datos del nuevo libro');
	writeln('ISBN: '); readln(datos.isbn);
	writeln('Titulo: '); readln(datos.titulo);
	writeln('Anio edicion: '); readln(datos.anio);
	writeln('Editorial: '); readln(datos.editorial);
	writeln('Genero: '); readln(datos.genero);

	reset(myfile);
	seek(myfile, filesize(myfile));
	write(myfile, datos);
	close(myfile);
end;

var
	tfile: text;
	myfile: lfile;
	op: integer;
begin
	assign(myfile, 'tmp/libros.bin');
	assign(tfile, 'tmp/libros.txt');

	writeln('Seleccione una opcion: ');
	writeln('1) Crear archivo binario desde archivo de texto.');
	writeln('2) Modificar libro en archivo binario.');
	writeln('3) Agregar libro en archivo binario.');
	writeln('4) Salir.');

	op := -1;
	repeat
		readln(op);
		case op of
			1: binarioTexto(tfile, myfile);
			2: modificarBinario(myfile);
			3: agregarBinario(myfile);
	else
		if (op <> 4) then writeln('Opcion invalida.');
	end;
	until op = 4;

end.
