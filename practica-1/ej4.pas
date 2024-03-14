program ej4;

procedure copiarArchivo(var tfile1: text);
var
	tfile2: text;
	line: string;
begin
	assign(tfile2, 'tmp/copiadinos');
	rewrite(tfile2);

	while not eof(tfile1) do
	begin
		readln(tfile1, line);
		writeln('La linea actual es: ', line);
		writeln(tfile2, line);
		writeln('La linea fue copiada en el archivo de texto.')
	end;
	close(tfile2);
end;

var
	tfile1: text;
	line: string;
begin
	assign(tfile1, 'tmp/dinosaurios');
	reset(tfile1);

	copiarArchivo(tfile1);
	close(tfile1);
end.
