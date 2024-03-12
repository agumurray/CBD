program ej3;

var
	myfile: text;
	dino: string;
begin
	assign(myfile, 'tmp/dinosaurios');
	rewrite(myfile);

	writeln('Ingrese un tipo de dinosaurio: ');
	writeln('zzz para salir');
	readln(dino);
	while (dino <> 'zzz') do
	begin
		writeln(myfile, dino);
		writeln('Ingrese un tipo de dinosaurio: ');
		writeln('zzz para salir');
		readln(dino);
	end;
	close(myfile);
end.
