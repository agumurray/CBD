program ej6;

type
	libro= record
		isbn: longint;
		titulo:string;
		genero:string;
		editorial:string;
		anio:integer;
end;

lfile= file of libro;

var
	tfile: text;
	myfile: lfile;
	line: string;
	datos: libro;
begin
	assign(tfile, 'tmp/libros.txt');
	reset(tfile);

	readln(tfile, line);
	writeln(line);
end.
